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

## ##

function _print_stacktrace_e() {
   >&2 echo -e 'Exception in thread "main": '$@
   
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
      
      ! [ x$source_file = x ] &&
         stack_path=$source_file:$line_number \
      ||
         stack_path="Unknown Source"
      
      >&2 echo "   at $function($stack_path)"
   done
}
