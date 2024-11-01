MOONC?=moonc
MOON_FILES=control.moon data.moon settings.moon $(wildcard migrations/*.moon) $(wildcard lib/*.moon)
LUA_FILES=$(patsubst %.moon,%.lua,$(MOON_FILES))
BUILT_FILES=$(LUA_FILES) CHANGELOG.md
PACKAGE_DIR?=out
PACKAGE_FILES=info.json locale graphics thumbnail.png LICENSE.md $(LUA_FILES)
PACKAGE_NAME=hourly_autosaves
PACKAGE_VERSION?=$(shell cat info.json | jq -r .version)
PACKAGE_BASE_PATH=$(PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)

.PHONY: all build debug develop package clean watch

all: build

build: $(BUILT_FILES)

%.lua: %.moon
	$(MOONC) $< -o $@

CHANGELOG.md: changelog.json
	touch $@
	# factorio-changelog-creator ./ changelog.json --format md

package: $(BUILT_FILES) $(PACKAGE_BASE_PATH).zip

debug: $(BUILT_FILES) $(PACKAGE_BASE_PATH)
	echo 'settings.global["hourly_autosaves_debug"] = { value = true }' >> $(PACKAGE_BASE_PATH)/control.lua

develop:
	inotifywait -r Makefile $(MOON_FILES) $(PACKAGE_FILES) -m --event close_write 2>/dev/null | while read ev; do \
		rm -rf $(PACKAGE_DIR)/hourly_autosaves*; \
		$(MAKE) debug; \
		done

$(PACKAGE_BASE_PATH): changelog.json $(PACKAGE_FILES)
	@test -d $@ || mkdir -p $@
	cp --parents -r $(PACKAGE_FILES) $@/
	# factorio-changelog-creator $@/ changelog.json --format ingame

$(PACKAGE_BASE_PATH).zip: $(PACKAGE_BASE_PATH)
	cd $(PACKAGE_DIR); zip -r $(abspath $@) -xi $(PACKAGE_NAME)_$(PACKAGE_VERSION)/
	rm -rf $(PACKAGE_BASE_PATH)/

watch: build
	moonc -w $(MOON_FILES)

clean:
	rm -rf $(LUA_FILES) CHANGELOG.md $(PACKAGE_DIR)/*.zip
