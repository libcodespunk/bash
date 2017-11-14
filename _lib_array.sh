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

function _array_copy {
   local _1="$1" # Name of source array
   local _2="$2" # Name of destination array
   
   local declare_p=$(declare -p $_1);
   local a_type=${declare_p:9:1}
   
   # Note that this variable is global
   eval declare -g -$a_type $_2="${declare_p:$(expr index "${declare_p}" =)}";
   
   # Fix syntax coloring bug in sublime text
   #"
}

#declare -g -A a

#a[1]=a
#a[2]=b
#a[3]=c

#_array_copy a b

#echo ${b[1]}
#echo ${b[2]}
#echo ${b[3]}

#echo

#declare -a c

#c[0]=1
#c[4]=2
#c[9]=3

#_array_copy c d

#echo ${d[@]}
#echo ${d[0]}
#echo ${d[4]}
#echo ${d[9]}
