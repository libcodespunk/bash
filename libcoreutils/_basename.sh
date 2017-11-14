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

function __EXPORT_RESULT() {
   local result
   
   result=$1
   
   [[ $use_r ]] && {
      _r=$result
      
      [[ $r ]] &&
         eval $r=\$result
   } \
   ||
      echo $result
}

# COMMAND
#   _basename_e - strip directory and suffix from filenames
#   
# USAGE
#   _basename_e NAME [SUFFIX]
#   
function _basename_e() {
   local path=$1
   local suffix=$2
   
   # Provide export _r/echo
   local r use_r; [[ ${r+x} ]] && use_r=true
   
   ! [[ $path ]] && {
      __EXPORT_RESULT ""
      
      return 0
   }
   
   while [[ ${path#${path%?}} = / ]]; do
      path=${path%/}
   done
   
   ! [[ $path ]] && {
      __EXPORT_RESULT /
      
      return 0
   }
   
   path=${path##*/}
   
   [[ $path = $suffix ]] && {
      __EXPORT_RESULT "$path"
      
      return 0
   }
   
   __EXPORT_RESULT "${path%$suffix}"
   
   return 0
}
