# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_CONF ]] &&
   return
_H_CODESPUNK_BASH_CONF=true

[[ ! $CODESPUNK_HOME && -d "/usr/local/lib/codespunk/bash" ]] &&
   export CODESPUNK_HOME="/usr/local/lib/codespunk"

[[ $CODESPUNK_HOME ]] || {
>&2 cat << EOF
 A required environment variable is set to an invalid directory:
    CODESPUNK_HOME = "$CODESPUNK_HOME"
 
 Please configure your environment to include the location of your libcodespunk
 installation.
 
 If the required dependencies are not available from the package manager, they
 can be downloaded and installed directly from the following repository:
 
 $ git clone https://github.com/zhro/libcodespunk_bash.git
 $ cd libcodespunk_bash
 $ sudo make install
EOF
   
   exit 1
}

source "$CODESPUNK_HOME/bash/_lib_echo.sh" || exit 1
source "$CODESPUNK_HOME/bash/_lib_exception.sh" || exit 1
source "$CODESPUNK_HOME/bash/libcoreutils/_dirname.sh" || exit 1

## ##

declare -A g_conf # Deprecated
declare -A _G_conf

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
       value="${a#*=}"
       value="${value/\$conf/$conf_path}"
       
       # Strip out any trailing carriage returns or newlines
       value=${value%[$'\r\n']}
       
       g_conf[$name]="$value"
       _G_conf[$name]="$value"
     fi
   done < "$conf_path/$conf_file"
   
   g_conf[conf-path]="$conf_path"
   _G_conf[conf-path]="$conf_path"
}
