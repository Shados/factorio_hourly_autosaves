MOONC?=moonc
MOON_FILES=control.moon data.moon settings.moon $(wildcard migrations/*.moon) $(wildcard lib/*.moon)
LUA_FILES=$(patsubst %.moon,%.lua,$(MOON_FILES))
PACKAGE_DIR?=out
PACKAGE_FILES=info.json locale graphics LICENSE.md $(LUA_FILES)
PACKAGE_NAME=hourly_autosaves
PACKAGE_VERSION?=$(shell cat info.json | jq -r .version)

.PHONY: all build debug develop package clean watch

all: build

build: $(LUA_FILES) CHANGELOG.md

%.lua: %.moon
	$(MOONC) $< -o $@

CHANGELOG.md: changelog.json
	factorio-changelog-creator ./ changelog.json --format md

package: build $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION).zip

debug: build $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)

develop:
	inotifywait -r Makefile $(MOON_FILES) $(PACKAGE_FILES) -m --event close_write 2>/dev/null | while read ev; do \
		rm -rf $(PACKAGE_DIR)/hourly_autosaves*; \
		$(MAKE) debug; \
		done

$(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION): changelog.json $(PACKAGE_FILES)
	@test -d $@ || mkdir -p $@
	cp --parents -r $(PACKAGE_FILES) $@/
	factorio-changelog-creator $@/ changelog.json --format ingame

$(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION).zip: $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)
	cd $(PACKAGE_DIR); zip -r $@ -xi $(PACKAGE_NAME)_$(PACKAGE_VERSION)/
	rm -rf $(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)/

watch: build
	moonc -w $(MOON_FILES)

clean:
	rm -rf $(LUA_FILES) CHANGELOG.md $(PACKAGE_DIR)/*.zip
