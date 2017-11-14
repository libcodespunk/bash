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

function _echo_error_e() {
   local trailing_newline=true
   
   if [[ "$1" = "-n" ]]; then
      trailing_newline=
      shift
   fi
   
   if [[ "$@" ]]; then
      line="$(caller 0 | cut -d' ' -f1)"
      file="$(caller 0 | cut -d' ' -f3)"
      
      >&2 echo -n "$(basename $file):$line" "$@"
   fi
   
   [[ $trailing_newline ]] && \
      >&2 printf "\n"
}

function _echo_error_ex() {
   _echo_error_e $@
   
   exit 1
}
