# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_STRING_TRIM ]] &&
   return
_H_CODESPUNK_BASH_STRING_TRIM=true

## ##

function _str_field_e() {
   local to_search="$1"
   local index=$2
   local delimiter="$3"
   
   local r
   local use_r
   
   local search_backwards
   local r_field
   local right
   local l_field
   local left
   
   local i
   
   if [[ ${r+x} ]]; then
      use_r=true
   fi
   
   if ! (( $index )); then
      ! [[ $use_r ]] && echo "$to_search" || _r="$to_search"
      
      return 0
   fi
   
   if (( $index < 0 )); then
      search_backwards=true
      (( index *= -1 ))
   fi
   
   # Parameters strings cannot be blank
   if ! [[ $to_search ]] || ! [[ $delimiter ]]; then
      ! [[ $use_r ]] && echo "$to_search" || _r="$to_search"
      
      return 0
   fi
   
   if ! [[ $search_backwards ]]; then
      # If the index is 1 then truncate the left side at the first delimiter
      # match and return the result
      if [[ $index = 1 ]]; then
         ! [[ $use_r ]] && echo "${to_search%%$delimiter*}" ||
            _r="${to_search%%$delimiter*}"
         
         return 0
      fi
      
      # The following search is performed as a truncation of the string to the
      # string and right of the field
      r_field="$to_search"
      
      (( index-- ))
      for (( i=0; i<$index; i++ )); do
         right="${r_field#*$delimiter}"
         
         # If the result of the pattern search matches the previous result then
         # the search has gone out of range
         if [[ "$right" = "$r_field" ]]; then
            ! [[ $use_r ]] && echo "$to_search" || _r="$to_search"
            
            return 0
         fi
         
         r_field="$right"
      done
      
      # The result will be the whole-string of the field to the left of the
      # next delimiter found
      ! [[ $use_r ]] && echo "${r_field%%$delimiter*}" || \
         _r="${r_field%%$delimiter*}"
      
      return 0
   fi
   
   # If the index is 1 then truncate the right side at the first delimiter
   # match and return the result
   if [[ $index = 1 ]]; then
      ! [[ $use_r ]] && echo "${to_search##*$delimiter}" || \
         _r="${to_search##*$delimiter}"
      
      return 0
   fi
   
   # The following search is performed as a truncation of the string to the
   # string and left of the field
   l_field="$to_search"
   
   for (( i=0; i<$index; i++ )); do
      left="${l_field%$delimiter*}"
      
      # If the result of the pattern search matches the input result before the
      # desired index has been reached then the index is out of range
      if [[ "$left" = "$l_field" ]]; then
         if (( $((i+1)) < $index )); then
            ! [[ $use_r ]] && echo "$to_search" || _r="$to_search"
            
            return 1
         fi
      fi
      
      # If $left = $l_field when searching backwards then either the field does
      # not exist or it is the leftmost field in the string. The easiest way to
      # determine which is to call _str_field_e again but return the first
      # positive field instead of the last negative one
      if [[ "$left" = "$l_field" ]]; then
         ! [[ $use_r ]] && _str_field_e "$to_search" 1 "$delimiter" ||
            r= _str_field_e "$to_search" 1 "$delimiter"
         
         return $?
      fi
      
      l_field="$left"
   done
   
   to_search="${to_search:$((${#l_field}+${#delimiter})): \
      $((${#to_search}-$((${#l_field}+${#delimiter}))))}"
   
   # The result will be the whole-string of the field to the left of the next
   # delimiter found
   ! [[ $use_r ]] && echo "${to_search%%$delimiter*}" ||
      _r="${to_search%%$delimiter*}"
   
   return 0
}
