#!/bin/bash

function cplogin() {
    dirname=${destdir}/src_${1}/`cat genconfig_${1}.json | jq .libName |sed -e 's^"^^g'`/`cat genconfig_${1}.json | jq .packageName |sed -e 's^"^^g'`
	mkdir -p ${dirname}/utils
	cp login.py ${dirname}/
}

################################################################
# Main
################################################################

pipeline=$1
destdir=$2

cplogin $pipeline