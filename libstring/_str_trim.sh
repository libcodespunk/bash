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

function _str_trim_e() {
   local to_trim="$1"
   
   local o_chars
   local o_where
   
   local r
   local use_r
   
   local offset=0
   local char_list=" "$'\t'$'\n'$'\r'
   local last_offset
   local where
   
   local i
   local n
   
   if [[ "$o_chars" ]]; then
      char_list="$o_chars"
   fi
   
   if [[ $o_where ]]; then
      where=$o_where
   else
      where="both"
   fi
   
   if [[ ${r+x} ]]; then
      use_r=true
   fi
   
   if ! (( ${#char_list} )); then
      ! [[ $use_r ]] && echo "$to_trim" || _r="$to_trim"
      return 1
   fi
   
   case $where in
   "both" )
      ;&
   "l" )
      ;&
   "left" )
      for (( i=0; i<${#to_trim}; i++ )); do
         last_offset=$offset;
         
         # Loop through each character in char_list and compare it to the
         # currently examined string index of the string to trim
         for (( n=0; n<${#char_list}; n++ )); do
            # Increase the substring offset on a match
            if [[ ${to_trim:$i:1} = ${char_list:$n:1} ]]; then
               (( offset++ ))
               break
            fi
         done
         
         # Break when no further matching delimiters can be found
         [[ $offset = $last_offset ]] &&
            break
      done
      
      to_trim=${to_trim:$offset}
      
      # Do not break if character trimming is occuring on both sides of the
      # string
      if [[ $where = "l" ]] || [[ $where = "left" ]]; then
         ! [[ $use_r ]] && echo "$to_trim" || _r="$to_trim"
         return 0
      fi
      ;&
   "r" )
      ;&
   "right" )
      # Reset offset for left-to-right fallthrough
      offset=0
      
      for (( i=${#to_trim}-1; i>0; i-- )); do
         last_offset=$offset
         
         for (( n=0; n<${#char_list}; n++ )); do
            if [[ ${to_trim:$i:1} = ${char_list:$n:1} ]]; then
               (( offset++ ))
               break
            fi
         done
         
         [[ $offset = $last_offset ]] &&
            break
      done
      
      to_trim=${to_trim:0:$((${#to_trim}-$offset))}
      ;;
   * )
      ;;
   esac
   
   ! [[ $use_r ]] && echo "$to_trim" || _r="$to_trim"
   
   return 0
}

function _str_trim_left_e() {
   local r
   local use_r
   
   if [[ ${r+x} ]]; then
      use_r=true
   fi
   
   if [[ $use_r ]]; then
      r= o_chars="$o_chars" o_where=l _str_trim_e "$@"
      return $?
   fi
   
   o_chars="$o_chars" o_where=l _str_trim_e "$@"
   
   return $?
}

function _str_trim_right_e() {
   local r
   local use_r
   
   if [[ ${r+x} ]]; then
      use_r=true
   fi
   
   if [[ $use_r ]]; then
      r= o_chars="$o_chars" o_where=r _str_trim_e "$@"
      return $?
   fi
   
   o_chars="$o_chars" o_where=r _str_trim_e "$@"
   
   return $?
}
