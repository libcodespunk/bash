# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

__script_path=${BASH_SOURCE[0]%/*}

! [[ -f $__script_path ]] ||
   [[ $__script_path = */* ]] ||
      __script_path=.

pushd "$__script_path" 1>/dev/null
popd 1>/dev/null

__SYSTEM_F_GZIP_SCRIPT_PATH=$OLDPWD

source "$__SYSTEM_F_GZIP_SCRIPT_PATH/../_lib_busybox.sh" || exit 1

# COMMAND
#   _gzip - wraps environment binary or busybox equivalent if available
#   
# USAGE
#   _gzip ...
#   _gzip --available
#   
function _gzip() {
   ! [[ $__g_gzip_exists ]] && {
      ! gzip --help 2>/dev/null >/dev/null && {
         ! _busybox_has gzip &&
            return 1
         
         __g_busybox_gzip_exists=true
      }
      
      __g_gzip_exists=true
   }
   
   [[ $1 = --available ]] && [[ $__g_gzip_exists ]] &&
      return 0
   
   [[ $__g_busybox_gzip_exists ]] &&
      busybox gzip "$@"
   ||
      gzip "$@"
}
