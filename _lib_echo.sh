# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_ECHO ]] &&
   return
_H_CODESPUNK_BASH_ECHO=true

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

source "$CODESPUNK_HOME/bash/_lib_color.sh" || exit 1

## ##

function _echo_error_e() {
   local trailing_newline=true
   local color=
   
   while true; do
      case $1 in
      -n)
         trailing_newline=
         shift
         
         echo "! -n"
      ;;
      
      -c)
         shift
         color=$1
         shift
      ;;
      *)
         break
      esac
   done
   
   if [[ "$@" ]]; then
      line="$(caller 0 | cut -d' ' -f1)"
      file="$(caller 0 | cut -d' ' -f3)"
      
      >&2 echo -n "$(basename $file):$line "
      
      [[ $color ]] && {
         >&2 _display_format_text_e $color $@
      } || \
         >&2 echo -e -n $@
   fi
   
   [[ $trailing_newline ]] && \
      >&2 printf "\n"
}
