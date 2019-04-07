# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_SYSTEM_TAIL ]] &&
   return
_H_CODESPUNK_BASH_SYSTEM_TAIL=true

[[ $CODESPUNK_HOME ]] || {
>&2 echo ERROR: CODESPUNK_HOME is set to an invalid directory.
>&2 echo CODESPUNK_HOME = \"$CODESPUNK_HOME\"
>&2 echo Please set the CODESPUNK_HOME variable in your environment to match \
the location of your libcodespunk installation
}

source "$CODESPUNK_HOME/bash/_lib_busybox.sh" || exit 1

## ##

# COMMAND
#   _tail - wraps environment binary or busybox equivalent if available
#   
# USAGE
#   _tail ...
#   _tail --available
#   
function _tail() {
   ! [[ $__g_tail_exists ]] && {
      ! tail --help 2>/dev/null >/dev/null && {
         ! _busybox_has tail &&
            return 1
         
         __g_busybox_tail_exists=true
      }
      
      __g_tail_exists=true
   }
   
   [[ $1 = --available ]] && [[ $__g_tail_exists ]] &&
      return 0
   
   [[ $__g_busybox_tail_exists ]] &&
      busybox tail "$@"
   ||
      tail "$@"
}
