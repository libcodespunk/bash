# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

# COMMAND
#   _md5 - wraps environment binary or busybox equivalent if available
#   
# USAGE
#   _md5 ...
#   _md5 --available
#   
function function _md5() {
   if builtin command -v md5 >/dev/null; then
      [[ $1 = --available ]] &&
         return 0
      
      md5 "$@" | awk '{print $1}'
   elif builtin command -v md5sum  >/dev/null; then
      [[ $1 = --available ]] &&
         return 0
      
      md5sum "$@" | awk '{print $1}'
   elif echo | busybox md5sum &>/dev/null; then
      [[ $1 = --available ]] &&
         return 0
      
      busybox md5sum "$@" | awk '{print $1}'
   elif builtin command -v openssl >/dev/null; then
      [[ $1 = --available ]] &&
         return 0
      
      openssl md5 "$@" | awk '{print $2}'
   else
      return 1
   fi
   
   return 0
}
