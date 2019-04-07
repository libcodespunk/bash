# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_ENUM ]] &&
   return
_H_CODESPUNK_BASH_ENUM=true

## ##

## ----------------------------------------------------------------------------

## -- FUNCTIONS // BEGIN //

## -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

function \
   _enum()
{
   ## void
   ## (
   ##    _IN $@ : [ array<string> ] list
   ## )
   
   local list=("$@")
   local len=${#list[@]}
   
   for (( i=0; i < $len; i++ )); do
      eval "${list[i]}=$i"
   done
}

## -- -     - --     -- -      - --     -- -      - --     -- -      - --     - 

function \
   _enum_set()
{
   ## void
   ## (
   ##    _IN  $1 : [ string ] prefix
   ##    _IN ... : [ array<string> ] list
   ## )

   local prefix=$1
   local list=("$@")
   local len=${#list[@]}

   declare -g -A $prefix

   for (( i=0; i < $len; i++ )); do
      # Skip the first argument
      [[ $i = 0 ]] &&
         continue
      
      eval "$prefix[${list[$i]}]=$(( $i - 1 ))"
   done
}

## ----------------------------------------------------------------------------

## -- FUNCTIONS // END //

## -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
