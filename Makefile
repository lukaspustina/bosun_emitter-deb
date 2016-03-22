BASE_NAME=bosun-emitter
BIN_NAME=emit_bosun

all:
	@echo 'Example: BIN_DIR=../bosun_emitter/target/debug ARCH=amd64 VERSION=0.1.0-alpha-3 TAG=$VERSION DIST=trusty package'

package: $(BASE_NAME)-$(VERSION)-$(DIST)-$(ARCH).deb

$(BASE_NAME)-$(VERSION)-$(DIST)-$(ARCH).deb: $(BASE_NAME)/DEBIAN/control $(BASE_NAME)/usr/bin/$(BIN_NAME)
	chmod +x $<
	dpkg-deb -b $(BASE_NAME) $@
	dpkg-deb -I $@

clean:
	-rm -fR $(BASE_NAME)
	-rm $(BASE_NAME)-$(VERSION)-$(ARCH).deb

$(BASE_NAME)/DEBIAN/control: templates/DEBIAN/control $(BASE_NAME)/usr/bin/$(BIN_NAME) $(BASE_NAME)/DEBIAN
	SIZE=`du -s $(BASE_NAME)/usr/bin/$(BIN_NAME) | awk '{ print $$1}'`; SAN_VERSION=`echo $$VERSION | sed 's/^[a-z]*//'`; sed "s/@@PACKAGE_NAME@@/$(BASE_NAME)/; s/@@VERSION@@/$${SAN_VERSION}/; s/@@ARCH@@/$(ARCH)/; s/@@SIZE@@/$${SIZE}/" $< > $@

$(BASE_NAME)/usr/bin/$(BIN_NAME): $(BIN_DIR)/$(BIN_NAME) $(BASE_NAME)/usr/bin
	cp $< $@

$(BASE_NAME)/usr/bin:
	mkdir -p $@

$(BASE_NAME)/DEBIAN:
	mkdir -p $@

