# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_SYSTEM_SED ]] &&
   return
_H_CODESPUNK_BASH_SYSTEM_SED=true

[[ $CODESPUNK_HOME ]] || {
   >&2 echo A required environment variable is set to an invalid directory.
   >&2 echo CODESPUNK_HOME = \"$CODESPUNK_HOME\"
   >&2 echo Please configure your environment to include the location of your \
   libcodespunk installation.
   
   exit 1
}

source "$CODESPUNK_HOME/bash/_lib_busybox.sh" || exit 1

## ##

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
