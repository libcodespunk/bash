# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_ENUM ]] &&
   return
_H_CODESPUNK_BASH_ENUM=true

## ##

function _enum() {
   local len=${#ENUM[@]}
   
   for (( i=0; i < $len; i++ )); do
      eval "${ENUM[i]}=$i"
   done
}
