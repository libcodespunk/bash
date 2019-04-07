# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_COREUTILS_BASENAME ]] &&
   return
_H_CODESPUNK_BASH_COREUTILS_BASENAME=true

[[ $CODESPUNK_HOME ]] || {
>&2 echo ERROR: CODESPUNK_HOME is set to an invalid directory.
>&2 echo CODESPUNK_HOME = \"$CODESPUNK_HOME\"
>&2 echo Please set the CODESPUNK_HOME variable in your environment to match \
the location of your libcodespunk installation
}

source "$CODESPUNK_HOME/bash/_lib_echo.sh" || exit 1

## ##

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
