#!/bin/bash

function mkallgroups(){
allgrps=()
for file in ./swagger/*
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


echo Creating genconfig.json ...
cat <<EOF > genconfig.json
{
    "libName": "apigroups",
    "packageName": "client",
    "modelPackage": "model",
    "apiPackage": "api",
    "allgroups" : `mkallgroups $1`
 }
EOF
