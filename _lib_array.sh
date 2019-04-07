# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
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
