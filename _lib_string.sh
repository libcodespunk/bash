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

pushd $__script_path 1>/dev/null
popd 1>/dev/null

__LIB_STRING_SCRIPT_PATH=$OLDPWD

source "$__LIB_STRING_SCRIPT_PATH/libstring/_str_field.sh" || exit 1
source "$__LIB_STRING_SCRIPT_PATH/libstring/_str_trim.sh" || exit 1
source "$__LIB_STRING_SCRIPT_PATH/libstring/_str_type_int.sh" || exit 1
