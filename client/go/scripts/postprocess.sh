#!/bin/bash

function setupvendors() {
	cd examples && go mod vendor
}

################################################################
# Main
################################################################

pipeline=$1
destdir=$2

setupvendors