# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_SYSTEM_MKTEMP ]] &&
   return
_H_CODESPUNK_BASH_SYSTEM_MKTEMP=true

[[ ! $CODESPUNK_HOME && -d "/usr/local/lib/codespunk/bash" ]] &&
   export CODESPUNK_HOME="/usr/local/lib/codespunk"

[[ $CODESPUNK_HOME ]] || {
>&2 cat << EOF
 A required environment variable is set to an invalid directory:
    CODESPUNK_HOME = "$CODESPUNK_HOME"
 
 Please configure your environment to include the location of your libcodespunk
 installation.
 
 If the required dependencies are not available from the package manager, they
 can be downloaded and installed directly from the following repository:
 
 $ git clone https://github.com/zhro/libcodespunk_bash.git
 $ cd libcodespunk_bash
 $ sudo make install
EOF
   
   exit 1
}

source "$CODESPUNK_HOME/bash/_lib_busybox.sh" || exit 1

## ##

# COMMAND
#   _mktmp - wraps environment binary or busybox equivalent if available
#   
# USAGE
#   _mktmp ...
#   _mktmp --available
#   
function _mktemp() {
   ! [[ $__g_mktemp_exists ]] && {
      ! mktemp --help 2>/dev/null >/dev/null && {
         ! _busybox_has mktemp &&
            return 1
         
         __g_busybox_mktemp_exists=true
      }
      
      __g_mktemp_exists=true
   }
   
   [[ $1 = --available ]] && [[ $__g_mktemp_exists ]] &&
      return 0
   
   [[ $__g_busybox_mktemp_exists ]] &&
      busybox mktemp "$@"
   ||
      mktemp "$@"
}
