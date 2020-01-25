# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_DISPLAY ]] &&
   return
_H_CODESPUNK_BASH_DISPLAY=true

## ##

DISPLAY_COLOR_RESET="\e[39m"
DISPLAY_COLOR_BLACK="\e[30m"
DISPLAY_COLOR_RED="\e[31m"
DISPLAY_COLOR_GREEN="\e[32m"
DISPLAY_COLOR_YELLOW="\e[33m"
DISPLAY_COLOR_BLUE="\e[34m"
DISPLAY_COLOR_MAGENTA="\e[35m"
DISPLAY_COLOR_CYAN="\e[36m"
DISPLAY_COLOR_LIGHT_GRAY="\e[37m"
DISPLAY_COLOR_DARK_GRAY="\e[90m"
DISPLAY_COLOR_LIGHT_RED="\e[91m"
DISPLAY_COLOR_LIGHT_GREEN="\e[92m"
DISPLAY_COLOR_LIGHT_YELLOW="\e[93m"
DISPLAY_COLOR_LIGHT_BLUE="\e[94m"
DISPLAY_COLOR_LIGHT_MAGENTA="\e[95m"
DISPLAY_COLOR_LIGHT_CYAN="\e[96m"
DISPLAY_COLOR_WHITE="\e[97m"

function _display_is_color_name() {
   case $1 in
   BLACK) ;&
   RED) ;&
   GREEN) ;&
   YELLOW) ;&
   BLUE) ;&
   MAGENTA) ;&
   CYAN) ;&
   LIGHT_GRAY) ;&
   DARK_GRAY) ;&
   LIGHT_RED) ;&
   LIGHT_GREEN) ;&
   LIGHT_YELLOW) ;&
   LIGHT_BLUE) ;&
   LIGHT_MAGENTA) ;&
   LIGHT_CYAN) ;&
   WHITE)
      return 0
   ;;
   esac
   
   return 1
}

function _display_set_color() {
   case $1 in
   RESET)
      echo -e -n "\e[39m"
   ;;
   BLACK)
      echo -e -n "\e[30m"
   ;;
   RED)
      echo -e -n "\e[31m"
   ;;
   GREEN)
      echo -e -n "\e[32m"
   ;;
   YELLOW)
      echo -e -n "\e[33m"
   ;;
   BLUE)
      echo -e -n "\e[34m"
   ;;
   MAGENTA)
      echo -e -n "\e[35m"
   ;;
   CYAN)
      echo -e -n "\e[36m"
   ;;
   LIGHT_GRAY)
      echo -e -n "\e[37m"
   ;;
   DARK_GRAY)
      echo -e -n "\e[90m"
   ;;
   LIGHT_RED)
      echo -e -n "\e[91m"
   ;;
   LIGHT_GREEN)
      echo -e -n "\e[92m"
   ;;
   LIGHT_YELLOW)
      echo -e -n "\e[93m"
   ;;
   LIGHT_BLUE)
      echo -e -n "\e[94m"
   ;;
   LIGHT_MAGENTA)
      echo -e -n "\e[95m"
   ;;
   LIGHT_CYAN)
      echo -e -n "\e[96m"
   ;;
   WHITE)
      echo -e -n "\e[97m"
   ;;
   esac
}

function _display_format_text_e() {
   local color
   
   echo -e -n '\033[0m'
   
   while true; do
      case $1 in
      --color=[a-z]*)
         color=$1
         
         _display_set_color ${color#*=}
         
         shift
      ;;
      *)
         break
      esac
   done
   
   echo -e $@'\033[0m'
}
