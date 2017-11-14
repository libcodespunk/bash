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

# COMMAND
#   _md5 - wraps environment binary or busybox equivalent if available
#   
# USAGE
#   _md5 ...
#   _md5 --available
#   
function function _md5() {
   if builtin command -v md5 >/dev/null; then
      [[ $1 = --available ]] &&
         return 0
      
      md5 "$@" | awk '{print $1}'
   elif builtin command -v md5sum  >/dev/null; then
      [[ $1 = --available ]] &&
         return 0
      
      md5sum "$@" | awk '{print $1}'
   elif echo | busybox md5sum &>/dev/null; then
      [[ $1 = --available ]] &&
         return 0
      
      busybox md5sum "$@" | awk '{print $1}'
   elif builtin command -v openssl >/dev/null; then
      [[ $1 = --available ]] &&
         return 0
      
      openssl md5 "$@" | awk '{print $2}'
   else
      return 1
   fi
   
   return 0
}
