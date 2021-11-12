TARGETDIR ?= `pwd`

%: gogenconfig_%
	$(eval TGT := $(shell echo $@ | sed 's/.*_//'))
	@echo Making $(TGT)
	bash gogen_$(TGT).sh
	bash scripts/postprocess.sh $(TGT) $(TARGETDIR)

gogenconfig_%:
	$(eval TGT := $(shell echo $@ | sed 's/.*_//'))
	@echo "\n\nPlease point to a *`echo $(TGT)|tr a-z A-Z`* PSM ...\n"
	@rm -f ~/.psm/config.json
	@python3 ../scripts/getswagger.py $(TGT)
	bash scripts/mkgogenconfig.sh $(TGT) $(TARGETDIR)