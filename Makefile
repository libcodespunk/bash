# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif

codespunk_path := $(PREFIX)/lib/codespunk/
lib_path := $(codespunk_path)bash/

.PHONY: install
install:
	mkdir -p "$(lib_path)"
	rsync -av --exclude=".*" . "$(lib_path)"
