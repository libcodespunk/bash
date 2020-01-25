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

source "$CODESPUNK_HOME/bash/_lib_display.sh" || exit 1
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
  [[ "$1" = "-p" ]] && {
     search_parents=true
     shift
  }

  local to_find=$1

  extension=${to_find##*.}

  [[ -f $to_find && ${extension,,} = "conf" ]] && {
     echo $to_find
     
     return
  }

  while true; do
     [[ -f $path/$to_find ]] && {
        echo $path/$to_find
        break
     }
     
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
   [[ "$1" = "-p" ]] && {
      search_parents=true
      shift
   }
   
   [[ $1 ]] || {
      _print_stacktrace_e --color RED "No config file specified."
      
      return 1
   }
   
   [[ $search_parents ]] &&
      conf_path=$(_p_conf_find_e -p $1) \
   ||
      conf_path=$(_p_conf_find_e $1)
   
   [[ $conf_path ]] || {
      m=$(_display_format_text_e RED \
         "Invalid config file specified or no access: $1.")
      
      _print_stacktrace_e $m
      
      return 1
   }
   
   conf_path="$(dirname "$conf_path")"
   conf_file="$(basename $1)"
   
   while read a; do
     [[ $a =~ ^[^#]*= ]] && {
       name=${a%%=*}
       value="${a#*=}"
       value="${value/\$conf/$conf_path}"
       
       # Strip out any trailing carriage returns or newlines
       value=${value%[$'\r\n']}
       
       g_conf[$name]="$value"
       _G_conf[$name]="$value"
     }
   done < "$conf_path/$conf_file"
   
   g_conf[conf-path]="$conf_path" # Deprecated
   _G_conf[conf-path]="$conf_path"
}
