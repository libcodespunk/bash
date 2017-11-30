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

__LIB_BUILD_SCRIPT_PATH=$OLDPWD
__LIB_BUILD_SCRIPT_ETC_BUILD_PATH=$CODESPUNK_HOME/../../etc/codespunk/build

source "$__LIB_BUILD_SCRIPT_PATH/_lib_exception.sh" || exit 1
source "$__LIB_BUILD_SCRIPT_PATH/_lib_echo.sh" || exit 1

source "$__LIB_BUILD_SCRIPT_PATH/libcoreutils/_dirname.sh" || exit 1

source "$__LIB_BUILD_SCRIPT_ETC_BUILD_PATH/compilers.sh" \
   || exit 1

source "$__LIB_BUILD_SCRIPT_PATH/_lib_common.sh" || exit 1
source "$__LIB_BUILD_SCRIPT_PATH/_lib_echo.sh" || exit 1
source "$__LIB_BUILD_SCRIPT_PATH/_lib_environment.sh" || exit 1
source "$__LIB_BUILD_SCRIPT_PATH/_lib_os.sh" || exit 1
source "$__LIB_BUILD_SCRIPT_PATH/_lib_require.sh" || exit 1

declare -A g_environment_stack

function _build_runtime_error_e() {
   if [[ "$@" ]]; then
      #echo $'\e[1;31m'$@$'\e[0;0m'
      >&2 echo $@
   fi
   
   #echo -n $'\e[0;0m';
   
   return 1
}

function _build_project_makefile_gnu_e() {
   local _1="$1"; shift # Project makefile
   local _2="$1"; shift # Working directory
   
   local script_path="$__LIB_BUILD_SCRIPT_PATH"
   
   _environment_push
   
   [[ $BUILD_CONFIG_PROJECT_TYPE ]] || {
      # Not always applicable (jar for example)
#       _echo_error_e "warning: Project type is undefined; defaulting to \
# executable"
      
      _build_set_project_type "executable"
      # _environment_pop_r
      # return 1
   }
   
   case $BUILD_CONFIG_PROJECT_TYPE in
   EXECUTABLE);;
   STATIC);;
   SHARED);;
   *)
      _print_stacktrace_e "Project type is invalid"
      _environment_pop_r
      return 1
   esac
   
   [[ $BUILD_CONFIG_COMPILER ]] || {
      _print_stacktrace_e "Compiler is undefined"
      _environment_pop_r
      return 1
   }
   
   source "$script_path/../build/compilers/$BUILD_CONFIG_COMPILER" || {
      _print_stacktrace_e "Invalid or unsupported compiler target"
      _environment_pop_r
      return 1
   }
   
   make -C "${_2}" -f "${_1}" --no-print-directory $@ ||
      _build_runtime_error_e || return 1
    
   _environment_pop_r
   
   [[ $? ]] || {
      _print_stacktrace_e "An unexpected error occurred while restoring the \
         environment state"
      
      _environment_pop_r
      
      return 1
   }
   
   #echo -n $'\e[0;0m'
}

function _build_set_compiler_r() {
   local script_path="$__LIB_BUILD_SCRIPT_PATH"
   local compiler_path
   
   [[ $1 ]] || {
      _print_stacktrace_e "Invalid or unsupported compiler target"
      
      return 1
   }
   
   read -r compiler_path < "$__LIB_BUILD_SCRIPT_ETC_BUILD_PATH/compilers/$1"
   
   [[ $compiler_path ]] || {
      _print_stacktrace_e "Invalid compiler path for $1"
      
      return 1
   }
   
   ! [[ -e $compiler_path ]] && {
      _print_stacktrace_e "Compiler path does not exist: $compiler_path"
      
      return 1
   }
   
   export BUILD_CONFIG_COMPILER=$1
   export $1=$compiler_path
}

function _build_push_compiler_environment_r() {
   local script_path="$__LIB_BUILD_SCRIPT_PATH"
   
   [[ $BUILD_CONFIG_COMPILER ]] || {
      _print_stacktrace_e "Compiler is undefined"
      
      return 1
   }
   
   _environment_push
   
   source "$script_path/../build/compilers/$BUILD_CONFIG_COMPILER" || {
      _print_stacktrace_e "Invalid or unsupported compiler target"
      _environment_pop_r
      return 1
   }
}

function _build_pop_compiler_environment_r() {
   local script_path="$__LIB_BUILD_SCRIPT_PATH"
   
   [[ $BUILD_CONFIG_COMPILER ]] || {
      _print_stacktrace_e "Compiler is undefined"
      
      return 1
   }
   
   _environment_pop_r
}

function _build_set_project_type() {
   export BUILD_CONFIG_PROJECT_TYPE="${1^^}"
}

function _build_set_target_name() {
   export BUILD_CONFIG_TARGET_NAME="$1"
}

function _build_set_target_postfix() {
   export BUILD_CONFIG_TARGET_POSTFIX="$1"  
}

_source_path_r "$__LIB_BUILD_SCRIPT_PATH/libbuild/config"

case $(_os_get_system_name_e) in
cygwin)
   _source_path_r "$__LIB_BUILD_SCRIPT_PATH/libbuild/win32"
   _source_path_r "$__LIB_BUILD_SCRIPT_PATH/libbuild/config/win32"
   ;;
darwin)
   _source_path_r "$__LIB_BUILD_SCRIPT_PATH/libbuild/config/osx"
   ;;
linux)
   _source_path_r "$__LIB_BUILD_SCRIPT_PATH/libbuild/config/linux"
   ;;
esac
