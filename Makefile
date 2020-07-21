MOONC?=moonc
MOON_FILES=control.moon settings.moon
LUA_FILES=$(patsubst %.moon,%.lua,$(MOON_FILES))
PACKAGE_DIR?=out
PACKAGE_FILES=info.json locale LICENSE.md $(LUA_FILES)
PACKAGE_NAME=hourly_autosaves
PACKAGE_VERSION?=$(shell cat info.json | jq -r .version)

.PHONY: all build package clean watch

all: build

build: $(LUA_FILES) CHANGELOG.md

%.lua: %.moon
	$(MOONC) $< -o $@

CHANGELOG.md:
	factorio-changelog-creator ./ changelog.json --format md

package: build $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION).zip

$(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION).zip:
	@test -d $(@D) || mkdir -p $(@D)
	mkdir -p $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)
	cp -r $(PACKAGE_FILES) $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)/
	factorio-changelog-creator $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)/ changelog.json --format ingame
	cd $(PACKAGE_DIR); zip -r $@ -xi $(PACKAGE_NAME)_$(PACKAGE_VERSION)/
	rm -rf $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)/

watch: build
	moonc -w $(MOON_FILES)

clean:
	rm -rf $(LUA_FILES) CHANGELOG.md $(PACKAGE_DIR)/*.zip
