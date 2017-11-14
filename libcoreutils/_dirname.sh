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

__script_path=${BASH_SOURCE[0]%/*}

! [[ -f $__script_path ]] ||
   [[ $__script_path = */* ]] ||
      __script_path=.

pushd "$__script_path" 1>/dev/null
popd 1>/dev/null

__LIB_REQUIRE_SCRIPT_PATH=$OLDPWD

source "$__LIB_REQUIRE_SCRIPT_PATH/../_lib_echo.sh" || exit 1

function __EXPORT_RESULT() {
   local __result
   
   __result=$1
   
   [[ $use_r ]] && {
      _r=$__result
      
      [[ $r ]] &&
         eval $r=\$__result
   } \
   ||
      echo $__result
}

# COMMAND
#   _dirname_e - strip last component from file name
#   
# USAGE
#   _dirname_e NAME
#   
function _dirname_e() {
   ! [[ ${1+x} ]] && {
     _echo_error_e _dirname_e missing operand [NAME]
      
      return 1
   }
   
   local __path=$1
   
   # Provide export _r/echo
   local r use_r; [[ ${r+x} ]] && use_r=true
   
   while ! [[ ${__path%/} = $__path ]]; do
     __path=${__path%/}
   done
   
   ! [[ $__path ]] && {
      __EXPORT_RESULT /
      
      return 0
   }
   
   [[ $__path = */* ]] && {
      __path="${__path%/*}"
      
      [[ $__path ]] &&
         __EXPORT_RESULT $__path ||
         __EXPORT_RESULT $__path /
      
      return 0
   }
   
   __EXPORT_RESULT "."
   
   return 0
}
