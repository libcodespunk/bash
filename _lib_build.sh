# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_BUILD ]] &&
   return
_H_CODESPUNK_BASH_BUILD=true

[[ $CODESPUNK_HOME ]] || {
>&2 echo ERROR: CODESPUNK_HOME is set to an invalid directory.
>&2 echo CODESPUNK_HOME = \"$CODESPUNK_HOME\"
>&2 echo Please set the CODESPUNK_HOME variable in your environment to match \
the location of your libcodespunk installation
}

source "$CODESPUNK_HOME/bash/_lib_common.sh" || exit 1
source "$CODESPUNK_HOME/bash/_lib_echo.sh" || exit 1
source "$CODESPUNK_HOME/bash/_lib_environment.sh" || exit 1
source "$CODESPUNK_HOME/bash/_lib_exception.sh" || exit 1
source "$CODESPUNK_HOME/bash/_lib_os.sh" || exit 1
source "$CODESPUNK_HOME/bash/_lib_require.sh" || exit 1
source "$CODESPUNK_HOME/bash/libcoreutils/_dirname.sh" || exit 1

source "$CODESPUNK_HOME/build/compilers.sh" || exit 1

## ##

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
   
   read -r compiler_path < "$CODESPUNK_HOME/bash/build/compilers/$1"
   
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
