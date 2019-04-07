# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_COMMON ]] &&
   return
_H_CODESPUNK_BASH_COMMON=true

## ##

function _source_r() {
   local path=$1
   local file=$2
   
   if [[ "$__g_lib_common_require_last_path" = "$path" ]]; then
      source "$g_require_last_rpath/$2" ||
         return 1
      
      return 0
   fi
   
   __g_lib_common_require_last_path="$path"
   
   path="$(cd "$script_path/.."; pwd)"
   
   source "$path/$2" ||
      return 1
   
   g_require_last_rpath="$path"
}

function _source_path_r() {
   local path="$1"
   
   while read a; do
      if [[ -f "$path/$a" ]]; then
         source "$path/$a" ||
            return 1
      fi
   done <<< "$(ls -1 "$path")"
}

function _script_path_e() {
   echo "$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
}

function _not_defined() {
   [ -z "$1" ] && return 0
   
   return 1
}

function _defined_or() {
   local arg1=$1
   shift
   
   eval "[[ -z \$$arg1 ]] && $arg1=\"$@\""
}

function _defined_and() {
   local arg1=$1
   shift
   
   eval "[[ -n \$$arg1 ]] && $arg1=\"\$$arg1 $@\""
}

function _concat() {
   local arg1=$1
   shift
   
   eval "if [[ -n \$$arg1 ]]; then $arg1=\"\$$arg1 $@\"; else $arg1=\"$@\"; fi"
}
