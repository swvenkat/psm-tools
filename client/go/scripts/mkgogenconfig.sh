#!/bin/bash

function usage() {
   echo "Usage: $0 [cloud|ent] targetdir" 
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

echo Creating gogenconfig_$1.json ...
cat <<EOF > gogenconfig_$1.json
{
    "libName": "psm_$1",
    "libAlias": "pensando_psm",
    "generatorName": "go",
    "templateDir": "templates",
    "packageName": "psm_$1",
    "modelPackage": "model",
    "apiPackage": "api",
    "allgroups" : `mkallgroups $1`
 }
EOF

}

function mkgensh() {
dirname=${destdir}/generated/src_${1}/`cat gogenconfig_${1}.json | jq .libName |sed -e 's^"^^g'`
[ ! -d $dirname ] || mkdir $dirname

echo Creating gogen_$1.sh ...
cat <<EOF > gogen_$1.sh
#!/bin/bash

for file in ./swagger_${1}/*
do
  group=\`basename \${file} | sed -e 's/.json//'\`
  dir=\`cat gogenconfig_${1}.json | jq .libName | tr -d "\""\`

  java -jar ../bin/openapi-generator-cli.jar generate -i "\$file" -p group=\${group^} -c gogenconfig_${1}.json -o ${dirname}/

  echo "\$group"
done

EOF

}

################################################
#
#  main
#
################################################

[ $# -eq 2 ] || usage

echo $1 | egrep 'cloud|ent' > /dev/null || usage
pipeline=$1
src_dirname=generated/src_${1}
destdir=$2

mkgenconfig $pipeline 
mkgensh $pipeline

exit 0
