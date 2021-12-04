#!/bin/bash

function usage() {
   echo "Usage: $0 [cloud|dss|ent] targetdir" 
   exit 1
}

function mkallgroups(){
allgrps=()
for file in ./swagger_$1/*
do
  group=`basename $file| sed -e 's/.json//'`
  allgrps+=($group)
done

export allgroups="\"${allgrps[0]}\""
for i in "${allgrps[@]:1}"; do
   allgroups+=",\"$i\""
done

echo "[$allgroups]"
}

function mkgenconfig() {
[ ! -d $src_dirname ] && echo "Creating $src_dirname ..."; mkdir $src_dirname

echo Creating genconfig_$1.json ...
cat <<EOF > genconfig_$1.json
{
    "libName": "pensando_$1",
    "libAlias": "pensando_psm",
    "generatorName": "python",
    "templateDir": "templates/",
    "packageName": "psm",
    "modelPackage": "model",
    "apiPackage": "api",
    "pipeline" : "$1",
    "allgroups" : `mkallgroups $1`
 }
EOF

}

function mkgensh() {
dirname=${destdir}/src_${1}/`cat genconfig_${1}.json | jq .libName |sed -e 's^"^^g'`
[ ! -d $dirname ] || mkdir $dirname

echo Creating gen_$1.sh ...
cat <<EOF > gen_$1.sh
#!/bin/bash

for file in ./swagger_${1}/*
do
  group=\`basename \${file} | sed -e 's/.json//'\`
  dir=\`cat genconfig_${1}.json | jq .libName | tr -d "\""\`

  java -jar ../bin/openapi-generator-cli.jar generate -i "\$file" -p group=\$group -c genconfig_${1}.json -o ${dirname}/

  echo "\$group"
done

EOF

}

function mkpypimeta() {

mkdir -p ${destdir}/${src_dirname}
cat <<EOF > ${destdir}/${src_dirname}/pyproject.toml
[build-system]
requires = [
    "setuptools>=42",
    "wheel"
]
build-backend = "setuptools.build_meta"
EOF
 
cat <<EOF > ${destdir}/${src_dirname}/setup.cfg
[metadata]
name = pensando_${1}
version = ${version}
author = Jeff Silberman
author_email = jeff@pensando.io
description = Python language bindings for Pensando ${1}
long_description = file: README.md
long_description_content_type = text/markdown
url = https://github.com/pensando/pypi
project_urls =
    Bug Tracker = https://github.com/pensando/psm-tools/issues
classifiers =
    Programming Language :: Python :: 3
    License :: OSI Approved :: MIT License
    Operating System :: OS Independent

[options]
install_requires =
    nulltype
package_dir =
    = .
packages = find:
python_requires = >=3.6

[options.packages.find]
where = .
exclude = test
EOF

}

################################################
#
#  main
#
################################################

[ $# -eq 2 ] || usage

echo $1 | egrep 'cloud|dss|ent' > /dev/null || usage
pipeline=$1
src_dirname=src_${1}
destdir=$2/generated

PSM_IP=`cat ~/.psm/config.json | jq '."psm-ip"' | sed -e 's/"//g'` 
echo -n "User: "
read USER
echo -n "Password: "
read -s PASSWORD
echo

version=`python3 getversion.py $PSM_IP $USER $PASSWORD`

mkgenconfig $pipeline 
mkgensh $pipeline
mkpypimeta $pipeline 

exit 0