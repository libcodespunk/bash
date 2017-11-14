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

__LIB_CONF_SCRIPT_PATH=$OLDPWD

source "$__LIB_CONF_SCRIPT_PATH/_lib_echo.sh" || exit 1
source "$__LIB_CONF_SCRIPT_PATH/_lib_exception.sh" || exit 1

source "$__LIB_CONF_SCRIPT_PATH/libcoreutils/_dirname.sh" || exit 1

declare -A g_conf

function _p_conf_find_e() {
  local path="$(pwd)"
  local search_parents
  local extension

  # Step backwards along the parent directory tree while attempting to locate
  # the target conf file
  if [[ "$1" = "-p" ]]; then
     search_parents=true
     shift
  fi

  local to_find=$1

  extension=${to_find##*.}

  if [[ -f $to_find && ${extension,,} = "conf" ]]; then
     echo $to_find
     
     return
  fi

  while true; do
     if [[ -f $path/$to_find ]]; then
        echo $path/$to_find
        break
     fi
     
     if ! [[ $search_parents ]] || [[ $path == "/" ]]; then
        break
     fi
     
     r=path _dirname_e "$path"
  done
}

function _conf_load_r() {
   local search_parents
   local name
   local value
   local conf_path
   
   # Step backwards along the parent directory tree while attempting to locate
   # the target conf file
   if [[ "$1" = "-p" ]]; then
      search_parents=true
      shift
   fi
   
   if ! [[ $1 ]]; then
      _print_stacktrace_e "No conf specified"
      
      return 1
   fi
   
   if [[ $search_parents ]]; then
      conf_path=$(_p_conf_find_e -p $1)
   else
      conf_path=$(_p_conf_find_e $1)
   fi
   
   if ! [[ $conf_path ]]; then
      _print_stacktrace_e "Couldn't find $1"
      
      return 1
   fi
   
   conf_path="$(dirname "$conf_path")"
   conf_file="$(basename $1)"
   
   while read a; do
     if [[ $a =~ ^[^#]*= ]]; then
       name=${a%%=*}
       value="${a##*=}"
       value="${value/\$conf/$conf_path}"
       
       # Strip out any trailing carriage returns or newlines
       value=${value%[$'\r\n']}
       
       g_conf[$name]="$value"
     fi
   done < "$conf_path/$conf_file"
   
   g_conf[conf-path]="$conf_path"
}
