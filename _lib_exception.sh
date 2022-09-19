# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_EXCEPTION ]] &&
   return
_H_CODESPUNK_BASH_EXCEPTION=true

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

source "$CODESPUNK_HOME/bash/_lib_display.sh" || exit 1

## ##

function _exception_print_stacktrace_e() {
   local color=
   
   # while true; do
   #    case $1 in
   #    --color=[a-zA-Z]*)
   #       color=$1
   #       color=${color#*=}
         
   #       shift
   #    ;;
      
   #    *)
   #       break
   #    esac
   # done
   
   >&2 echo -e -n 'Exception in thread "main": '
   
   _display_set_color >&2 RED
   
   >&2 echo $@
   
   _display_set_color >&2 RESET
   
   local i
   local stack_size=${#FUNCNAME[@]}
   
   for (( i=1; i<$stack_size; i++ )); do
      local function
      local line_number
      local source_file
      
      function=${FUNCNAME[$i]}
      
      [ x$function = x ] &&
         function=main
      
      line_number=${BASH_LINENO[(( i - 1 ))]}
      source_file=${BASH_SOURCE[$i]}
      
      # Replace all / with \
      source_file=${source_file////\\}
      
      ! [ x$source_file = x ] &&
         stack_path=$source_file:$line_number \
      ||
         stack_path="Unknown Source"
      
      >&2 echo "   at $function($stack_path)"
   done
   
   return 1
}
