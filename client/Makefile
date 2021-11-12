
REGISTRY_URL ?= registry.test.pensando.io:5000
PYCLIENT_CONTAINER ?= pyclient:0.3
TARGETDIR ?= `pwd`
DISTRIBUTIONS ?= cloud ent dss

ALL_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
LANG := $(word 1, $(ALL_ARGS))
LANG_ARGS := $(wordlist 3,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

# target:;@:
# above format creates a no-op target and prints nothing
$(eval $(ALL_ARGS):;@:)

.PHONY: $(ALL_ARGS)

gen:
	cd $(word 1, $(LANG)) && $(MAKE) $(LANG_ARGS)

default:
	$(eval TGTS := $(addprefix pypi_,$(DISTRIBUTIONS)))
	make $(TGTS)

e2e:
	make getswagger
	make build-generator
	make genclient
	make tests

build-generator:
	cd openapi-generator && mvn clean install -DskipTests
	mkdir -p bin
	mv openapi-generator/modules/openapi-generator-cli/target/openapi-generator-cli.jar bin/openapi-generator-cli.jar

tests:
	cd python && python3 scripts/test_apps.py

clean:
	if [ -d "./apigroups" ] ; then find ./apigroups -mindepth 1 ! -regex '^./apigroups/test/.*' -delete ; fi
	rm -rf $(addprefix src_,$(DISTRIBUTIONS))  $(addsuffix .sh, $(addprefix gen_,$(DISTRIBUTIONS)))  $(addsuffix .json, $(addprefix genconfig_,$(DISTRIBUTIONS))) swagger_*

run-container:
	docker run -it -v ~/.psm:/root/.psm -v `pwd`:/client ${REGISTRY_URL}/${PYCLIENT_CONTAINER} /bin/bash

build-container:
	docker build -t ${REGISTRY_URL}/${PYCLIENT_CONTAINER} .
