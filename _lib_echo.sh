# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

function _echo_error_e() {
   local trailing_newline=true
   
   if [[ "$1" = "-n" ]]; then
      trailing_newline=
      shift
   fi
   
   if [[ "$@" ]]; then
      line="$(caller 0 | cut -d' ' -f1)"
      file="$(caller 0 | cut -d' ' -f3)"
      
      >&2 echo -n "$(basename $file):$line" "$@"
   fi
   
   [[ $trailing_newline ]] && \
      >&2 printf "\n"
}

function _echo_error_ex() {
   _echo_error_e $@
   
   exit 1
}
