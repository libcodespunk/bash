# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

function _busybox() {
   ! [[ $__g_busybox_exists ]] &&
      return 1
   
   __g_busybox_exists=true
   
   [[ "$1" = --available ]] && [[ $__g_busybox_exists ]] &&
      return 0
   
   busybox "$@"
}

function _busybox_has() {
   builtin command -v busybox >/dev/null ||
      return 1

   # Sanitize searches for '[' and '[['
   a=$1
   a=${a//[/\\[}

   [[ $(busybox) =~ [[:space:]]($a)([,]|$) ]] ||
     return 1
}
