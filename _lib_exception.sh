# LICENSE
# 
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details
# at http://www.gnu.org/copyleft/gpl.html
# 
# You should have received a copy of the GNU General Public License along with
# this program. If not, see http://www.gnu.org/licenses
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

function _print_stacktrace_e() {
   >&2 echo 'Exception in thread "main": '$@
   
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
