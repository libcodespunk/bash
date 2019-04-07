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

__LIB_ENVIRONMENT_SCRIPT_PATH=$OLDPWD

source "$__LIB_ENVIRONMENT_SCRIPT_PATH/libstring/_str_field.sh" || exit 1

declare g_env_size
declare -A g_env_val
declare -A g_env_opt

function _environment_push() {
   local __env_a
   local __env_opt
   local __env_key
   local __env_val
   local _r
   local r
   
   [[ $g_env_size ]] ||
      g_env_size=0
   
   while read __env_a; do
      r= _str_field_e "$__env_a" 2 " "
      __env_opt=$_r
      
      # Invalid options field
      [[ "$__env_opt" =~ [^aAfFgilnrtux-] ]] &&
         continue
      
      # Trim the length of "declare " + length of opt + trailing space
      __env_a=${__env_a:$((${#__env_opt}+9))}
      
      r= _str_field_e "$__env_a" 1 "="
      __env_key=$_r
      
      # Library globals
      [[ $__env_key = g_env_opt ]] && continue
      [[ $__env_key = g_env_size ]] && continue
      [[ $__env_key = g_env_val ]] && continue
      
      # Library local variables
      [[ $__env_key = __env_a ]] && continue
      [[ $__env_key = __env_key ]] && continue
      [[ $__env_key = __env_opt ]] && continue
      [[ $__env_key = __env_val ]] && continue
      [[ $__env_key = _r ]] && continue
      [[ $__env_key = r ]] && continue
      
      # Environment variables to remain unchanged by push/pop
      [[ $__env_key = BASHOPTS ]] && continue
      [[ $__env_key = BASHPID ]] && continue
      [[ $__env_key = BASH_ARGC ]] && continue
      [[ $__env_key = BASH_ARGV ]] && continue
      [[ $__env_key = BASH_LINENO ]] && continue
      [[ $__env_key = BASH_LOADABLE_PATHS ]] && continue
      [[ $__env_key = BASH_REMATCH ]] && continue
      [[ $__env_key = BASH_SOURCE ]] && continue
      [[ $__env_key = BASH_VERSINFO ]] && continue
      [[ $__env_key = EUID ]] && continue
      [[ $__env_key = HISTCMD ]] && continue
      [[ $__env_key = IFS ]] && continue
      [[ $__env_key = PPID ]] && continue
      [[ $__env_key = RANDOM ]] && continue
      [[ $__env_key = SHELLOPTS ]] && continue
      [[ $__env_key = EXECIGNORE ]] && continue
      [[ $__env_key = UID ]] && continue
      [[ $__env_key = !:: ]] && continue
      [[ $__env_key = _ ]] && continue
      
      # Key must start with [a-zA-Z_]
      [[ ${__env_key:0:1} =~ [^a-zA-Z_] ]] && continue
      
      # Key contains an invalid or unsupported character
      [[ $__env_key =~ [^a-zA-Z0-9_] ]] && continue
      
      __env_val=${__env_a:$((${#__env_key}+1))}
      
      # NOTE: Bash built-in declare output changed from 4.3 to 4.4:
      # https://lists.gnu.org/archive/html/info-gnu/2016-09/msg00008.html
      # -- This causes output from declare -p to change.
      # 
      # Exammple:
      #    declare -A list
      #    list[a]=1
      #    list[b]=2
      #    list[c]=3
      #    declare -p | grep list=
      #
      #  4.3 output: declare -A list='([a]="1" [b]="2" [c]="3" )'
      #  4.4 output: declare -A list=([a]="1" [b]="2" [c]="3" )
      #
      # The following is a fix for this behavior while preserving backwards
      # compatibility for older versions
      
      # If string size > 1
      [[ ${#__env_val} > 1 ]] && {
         local _env_fchar=${__env_val:0:1}
         
         # If first char is a single or double quote
         [[ $_env_fchar = "'" || $_env_fchar = '"' ]] && {
            local _env_lchar=${__env_val:$((${#__env_val}-1)):1}
            
            # If first char is equal to last char
            [[ $_env_lchar = $_env_lchar ]] && {
               # Trim quotes
               __env_val=${__env_val:1:$((${#__env_val}-2))}
            }
         }
      }
      
      g_env_val[$g_env_size.$__env_key]=$__env_val
      g_env_opt[$g_env_size.$__env_key]=$__env_opt
   done <<< "$(declare -p)"
   
   g_env_val[$g_env_size]=$((++g_env_size))
}

function _environment_pop_r() {
   local __env_a
   local __env_prefix
   local __env_key
   local _r
   local r
   
   (( $g_env_size )) ||
      return 0
   
   while read __env_a; do
      # Library globals
      [[ $__env_a = g_env_opt ]] && continue
      [[ $__env_a = g_env_size ]] && continue
      [[ $__env_a = g_env_val ]] && continue
      
      # Library local variables
      [[ $__env_a = __env_a ]] && continue
      [[ $__env_a = __env_key ]] && continue
      [[ $__env_a = __env_opt ]] && continue
      [[ $__env_a = __env_val ]] && continue
      [[ $__env_a = _r ]] && continue
      [[ $__env_a = r ]] && continue
      
      # Environment variables to remain unchanged by push/pop
      [[ $__env_a = BASHOPTS ]] && continue
      [[ $__env_a = BASHPID ]] && continue
      [[ $__env_a = BASH_ARGC ]] && continue
      [[ $__env_a = BASH_ARGV ]] && continue
      [[ $__env_a = BASH_LINENO ]] && continue
      [[ $__env_a = BASH_LOADABLE_PATHS ]] && continue
      [[ $__env_a = BASH_REMATCH ]] && continue
      [[ $__env_a = BASH_SOURCE ]] && continue
      [[ $__env_a = BASH_VERSINFO ]] && continue
      [[ $__env_a = EUID ]] && continue
      [[ $__env_a = HISTCMD ]] && continue
      [[ $__env_a = IFS ]] && continue
      [[ $__env_a = PPID ]] && continue
      [[ $__env_a = RANDOM ]] && continue
      [[ $__env_a = SHELLOPTS ]] && continue
      [[ $__env_a = EXECIGNORE ]] && continue
      [[ $__env_a = UID ]] && continue
      [[ $__env_a = !:: ]] && continue
      [[ $__env_a = _ ]] && continue
      
      unset $__env_a
   done <<< "$(compgen -v)"
   
   __env_prefix=$(($g_env_size-1)).
   
   for __env_a in ${!g_env_val[@]}; do
      [[ ${__env_a:0:${#__env_prefix}} = $__env_prefix ]] && {
         r= _str_field_e "$__env_a" 2 .
         __env_key=$_r
         
         declare -g ${g_env_opt[$__env_prefix$__env_key]} \
            $__env_key="${g_env_val[$__env_prefix$__env_key]}"
         
         unset g_env_opt[$__env_prefix$__env_key]
         unset g_env_val[$__env_prefix$__env_key]
      }
   done
   
   ((--g_env_size))
}
