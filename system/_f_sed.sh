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

__SYSTEM_F_SED_SCRIPT_PATH=$OLDPWD

source "$__SYSTEM_F_SED_SCRIPT_PATH/../_lib_busybox.sh" || exit 1

# COMMAND
#   _sed - wraps environment binary or busybox equivalent if available
#   
# USAGE
#   _sed ...
#   _sed --available
#   
function _sed() {
   ! [[ $__g_sed_exists ]] && {
      ! sed --help 2>/dev/null >/dev/null && {
         ! _busybox_has sed &&
            return 1
         
         __g_busybox_sed_exists=true
      }
      
      __g_sed_exists=true
   }
   
   [[ $1 = --available ]] && [[ $__g_sed_exists ]] &&
      return 0
   
   [[ $__g_busybox_sed_exists ]] &&
      busybox sed "$@"
   ||
      sed "$@"
}
