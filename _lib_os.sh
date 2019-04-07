# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_OS ]] &&
   return
_H_CODESPUNK_BASH_OS=true

## ##

function _os_get_system_name_e() {
   echo $(uname -s | cut -d'-' -f1 | cut -d'_' -f1 | tr '[:upper:]' '[:lower:]')
}
