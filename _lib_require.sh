# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

__script_path=${BASH_SOURCE[0]%/*}

! [[ -f $__script_path ]] ||
   [[ $__script_path = */* ]] ||
      __script_path=.

pushd "$__script_path" 1>/dev/null
popd 1>/dev/null

__LIB_REQUIRE_SCRIPT_PATH=$OLDPWD

source "$__LIB_REQUIRE_SCRIPT_PATH/_lib_echo.sh" || exit 1
source "$__LIB_REQUIRE_SCRIPT_PATH/_lib_exception.sh" || exit 1

function _require_get_bash_version_major_e() {
   echo "$(bash --version | head -n1 | cut -d' ' -f4 | cut -d'.' -f1)"
}

function _require_bash_3_r() {
   if ! (( $(_require_get_bash_version_major_e) >= 3 )); then
      _print_stacktrace_e "Bash 3 or higher is required to run this script"
      
      return 1
   fi
}

function _require_bash_4_r() {
   if ! (( $(_require_get_bash_version_major_e) >= 4 )); then
      _print_stacktrace_e "Bash 4 or higher is required to run this script"
      
      return 1
   fi
}

# Associative arrays require bash 4
if (( $(_require_get_bash_version_major_e) >= 4 )); then
   declare -A __g_lib_require_dependencies
fi

function _require_add() {
   if ! [[ ${__g_lib_require_dependencies[len]} ]]; then
      __g_lib_require_dependencies[len]=0
   fi
   len=${__g_lib_require_dependencies[len]}
   
   __g_lib_require_dependencies[$len]="$@"
   
   __g_lib_require_dependencies[len]=$(expr $len + 1)
}

function _require_report_r() {
   local len=${__g_lib_require_dependencies[len]}
   local error
   
   ! [[ $len ]] &&
      return 0
   
   for (( i=0; i<$len; i++ )); do
      d=${__g_lib_require_dependencies[$i]}
      
      _print_stacktrace_e "Missing script dependency '$d'"
      
      error=true
   done
   
   [[ $error ]] &&
      return 1
}
