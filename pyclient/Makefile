
REGISTRY_URL ?= registry.test.pensando.io:5000
PYCLIENT_CONTAINER ?= pyclient:0.3
TARGETDIR ?= `pwd`
PIPELINES ?= cloud ent

default:
	$(eval TGTS := $(addprefix pypi_,$(PIPELINES)))
	make $(TGTS)

genconfig_%:
	$(eval TGT := $(shell echo $@ | sed 's/.*_//'))
	@echo "\n\nPlease point to a *`echo $(TGT)|tr a-z A-Z`* PSM ...\n"
	@rm -f ~/.psm/config.json
	@python3 getswagger.py $(TGT)
	bash mkpypigenconfig.sh $(TGT) $(TARGETDIR)

pypi_%: genconfig_%
	$(eval TGT := $(shell echo $@ | sed 's/.*_//'))
	@echo Making $(TGT)
	bash gen_$(TGT).sh
	bash postprocess.sh $(TGT) $(TARGETDIR)

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
	python3 test_apps.py

clean:
	if [ -d "./apigroups" ] ; then find ./apigroups -mindepth 1 ! -regex '^./apigroups/test/.*' -delete ; fi
	rm -rf $(addprefix src_,$(PIPELINES))  $(addsuffix .sh, $(addprefix gen_,$(PIPELINES)))  $(addsuffix .json, $(addprefix genconfig_,$(PIPELINES))) swagger_*

run-container:
	docker run -it -v ~/.psm:/root/.psm -v `pwd`:/pyclient ${REGISTRY_URL}/${PYCLIENT_CONTAINER} /bin/bash

build-container:
	docker build -t ${REGISTRY_URL}/${PYCLIENT_CONTAINER} .
