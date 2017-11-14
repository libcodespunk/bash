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
