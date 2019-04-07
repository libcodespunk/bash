# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
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
