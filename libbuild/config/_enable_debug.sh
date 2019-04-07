# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

function _build_config_enable_debug() {
   export BUILD_CONFIG_DEBUG=true
}

function _build_config_disable_debug() {
   unset BUILD_CONFIG_DEBUG
}
