# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
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
