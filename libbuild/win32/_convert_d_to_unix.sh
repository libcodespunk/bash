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

function _build_win32_convert_d_to_unix() {
   # Convert crlf to lf
   cat $@ | tr -d '\r' > $@.tmp
   
   # Save the first line
   lineA=`head -n1 $@.tmp`
   
   # Save source target part
   target="`echo $lineA | tr ':' '\n' | head -n1`"
   
   # Move the remainder of the first line which is additional sources to a file
   # with the rest of the dependencies being processed
   i=0
   while read -r a; do
      # Skip the first delimiter index, as this is the target not the dependency
      if ! (( $i )); then
         i=1
         continue
      fi
      
      if [[ $dep ]]; then
         dep=" $dep:"
      fi
      
      dep="$dep$a"
   done <<< "`echo $lineA | tr ":" "\n"`"
   echo $dep > $@
   
   # Get all but first line
   tail -n+2 $@.tmp >> $@
   
   i=0
   rm -f $@.tmp
   while read -r a; do
      # Trim all trailing "\" so that cygpath can parse the file properly
      if [ "${a: -2}" == " \\" ]; then
         a="${a:0:${#a}-2}"
      fi
      
      # Hide escaped spaces with a delimiter $$SPACE$$
      a="${a//\\ /\$\$SPACE\$\$}"
      
      # Convert actual spaces to newlines
      a="${a// /$'\n'}"
      
      echo "$a" >> $@.tmp
      
      if ! (( $i )); then
         i=1
         target_path="`echo "$a" | cut -d$'\n' -f1`"
         target_path="`dirname $target_path`"
      fi
   done <<< "`cat $@`"
   
   # Convert all paths to unix
   cygpath -u -f $@.tmp > $@
   rm -f $@.tmp
   
   # Restore escaped spaces (do this AFTER calling cygpath or it will replace
   # escaped spaces '\ ' with '/ ' when converting to Unix paths
   cat $@ | while read -r a; do
      echo "${a//\$\$SPACE\$\$/\\ }" >> $@.tmp
   done
   
   # Restore trailing line continuation "\" along with first and last lines
   rm -f $@
   echo "$target_path/$target: \\" >> $@
   cat $@.tmp | while read -r a; do
      echo " $a \\" >> $@
   done

   rm -f $@.tmp
}

# Export this function for use in makefile subshells
typeset -fx _build_win32_convert_d_to_unix
