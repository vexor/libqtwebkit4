SOURCES_LIST := /etc/apt/sources.list.d/sources.list

.PHONY: deps patch build

all: build

deps:
	sudo apt-get install devscripts -qy

$(SOURCES_LIST):
	echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty main restricted universe" | sudo tee $@
	echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe" | sudo tee -a $@
	sudo apt-get update -qq

source: $(SOURCES_LIST)
	sudo apt-get build-dep libqtwebkit4 -qy
	apt-get source libqtwebkit4 -qy

patch: source
	patch -p1 < debian.rules.patch

build: patch
	(cd qtwebkit-source-2.3.2 ; debuild -us -uc -b)
