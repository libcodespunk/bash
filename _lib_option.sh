# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

__script_path=${BASH_SOURCE[0]%/*}

! [[ -f $__script_path ]] ||
   [[ $__script_path = */* ]] ||
      __script_path=.

pushd "$__script_path" 1>/dev/null
popd 1>/dev/null

__LIB_OPTION_SCRIPT_PATH=$OLDPWD

source "$__LIB_OPTION_SCRIPT_PATH/libstring/_str_field.sh" || exit 1
source "$__LIB_OPTION_SCRIPT_PATH/libstring/_type_int.sh" || exit 1
source "$__LIB_OPTION_SCRIPT_PATH/libstring/_str_trim.sh" || exit 1

function _type_int_r() {
  [[ "$1" =~ ^-?[0-9]+$ ]] ||
    return 1
}

# Key.s, Prefix.s, KeyDelim.s="", ListDelim.s="", MaxList=0, AllowStacking=#False, AllowEmptyList=#False

k_option_error_ok=0
k_option_error_no_match=1

declare -A g_option

#Key.s, Prefix.s, KeyDelim.s="", ListDelim.s="", MaxList=0, AllowStacking=#False, AllowEmptyList=#False
function _option_add_rule_r() {
   local option="$1"
   local key="$2"
   local prefix="$3"
   
   local key_delim
   local max_list=0
   local allow_stacking
   local allow_empty_lists
   
   if ! [[ $max_list ]]; then
      max_list=0
   fi
   
   _type_int_r "$max_list" ||
      return 1
   
   # Both the key and prefix are required
   r= _str_trim_e $key; \
   if ! [[ $_r ]]; then
      return 1
   fi
   
   r= _str_trim_e $prefix; \
   if ! [[ $_r ]]; then
      return 1
   fi
   
   g_option[$option._key]=$key;
   g_option[$option._prefix]=$prefix;
   g_option[$option._key_delim]=$o_key_delim;
   g_option[$option._list_delim]=$o_list_delim;
   g_option[$option._max_list]=$o_max_list;
   g_option[$option._allow_stacking]=$o_allow_stacking;
   g_option[$option._allow_empty_list]=$o_allow_empty_lists;
}

function _option_create_e() {
   local uuid=$(uuidgen);
   
   echo $uuid
}

function _option_parse_e() {
   local option=$1
   declare -a argv=("${!2}")
   local OUT_map=$3
   
   local param
   local error
   local prefix
   local key
   local key_delim
   local key_part
   local key_delim_part
   local key_match
   local field
   local n_fields
   local keyDelim_field_part
   local fields
   local unknown_field
   local l
   local i
   #local Rule.OptionParser_Rules
   
   declare -A matching_rules
   declare -a matching_fields
   
   g_option[$option._case_sensitive]=$o_case_sensitive
   g_option[$option._allow_default]=$o_allow_default
   g_option[$option._ignore_unknown_fields]=$o_ignore_unknown_fields
   g_option[$option._skip_arg0]=$o_skip_arg0
   
   #if [[ $o_skip_arg0 ]] && [[ ListSize(*OptionParser\ArgV.s()) ]]
   #   DeleteElement(*OptionParser\ArgV.s())
   #EndIf
   
   for i in ${!argv[*]}; do
      param=${argv[i]}
      unset argv[i]
      
   _lib_option_rules_contains_prefix_for $option $param matching_rules
   
   if [[ ?! = $k_option_error_no_match ]]; then
      if [[ $o_allow_default ]]; then
         AddElement(*OptionParser\MapOut("default")\ValueList.s())
         *OptionParser\MapOut("default")\ValueList.s()=Param.s
         
         
         eval $OUT_map[$option."default"]=a
         
         #debug "Default: "+Param.s
         
         continue
      else
         fi ! [[ $o_ignore_unknown_fields ]]; then
            echo "Unknown or unexpected field: $param"
         fi
      fi
   fi
      
   done
   
}

declare -a argv

for (( i=1; i<=$#; i++ )); do
   eval argv[${#argv[@]}]='$'$i
done

option=$(_option_create_e)

_option_add_rule_r $option "t" "-"

declare -A map

_option_parse_e $option argv[@] map

# OptionParser, _OUT Map Options.OptionParser_MapList(), CaseSensitive=#False, AllowDefault=#False, IgnoreUnknownFields=#False, SkipArg0=#False)

# *OptionParser.OptionParser, Key.s, Prefix.s, KeyDelim.s="", ListDelim.s="", MaxList=0, AllowStacking=#False, AllowEmptyList=#False)
#   Protected NewMap StackedPrefixes.i()
  
#   ;/ Both the key and prefix are required
#   If Trim(Key.s)="" Or Trim(Prefix.s)=""
#     ProcedureReturn #False
#   EndIf
  
#   If AllowStacking
#     ;/ Stacked options cannot be wider than a single character
#     If Len(Key.s)>1
#       ProcedureReturn #False
#     EndIf
    
#     ;/ Add prefix to cache
#     StackedPrefixes(Prefix.s)
#   Else
#     ;/ Cannot mix keys of length greater than a single character with a prefix that has
#     ;/ been assigned as a stacked-prefix
#     If FindMapElement(StackedPrefixes(),Prefix.s) And Len(Key.s)>1
#       ProcedureReturn #False
#     EndIf
#   EndIf
  
#   AddElement(*OptionParser\Rules())
#   *OptionParser\Rules()\Key.s=Key.s
#   *OptionParser\Rules()\Prefix.s=Prefix.s
#   *OptionParser\Rules()\KeyDelim.s=KeyDelim.s
#   *OptionParser\Rules()\ListDelim.s=ListDelim.s
#   *OptionParser\Rules()\MaxList=MaxList
#   *OptionParser\Rules()\Stacked=AllowStacking
#   *OptionParser\Rules()\AllowEmptyList=AllowEmptyList
  
#   ProcedureReturn #True
# EndProcedure



# # o_allow_stacking
# # o_max_list
# # o_allow_empty_list
# function _option_add_rule_r() {
#   local o_allow_stacking
#   local o_max_list
#   local o_allow_empty_list
  
#   [[ $o_allow_stacking ]] || o_allow_stacking=
#   [[ $o_max_list ]] || o_max_list=0
#   [[ $o_allow_empty_list ]] || o_allow_empty_list=
  
#   _type_int_r $o_max_list || {
#     echo "Not int"
#     exit 1
#   }
  
#   # Both the key and prefix are required
#   if Trim(Key.s)="" Or Trim(Prefix.s)=""; then
#     ProcedureReturn #False
#   fi
  
#   if AllowStacking; then
#     # Stacked options cannot be wider than a single character
#     if Len(Key.s)>1; then
#       ProcedureReturn #False
#     fi
    
#     # Add prefix to cache
#     Glob_OptionParser\StackedPrefixes(Prefix.s)
#   else
#     # Cannot mix keys of length greater than a single character with a prefix that has
#     # been assigned as a stacked-prefix
#     if FindMapElement(Glob_OptionParser\StackedPrefixes(),Prefix.s) And Len(Key.s)>1; then
#       ProcedureReturn #False
#     fi
#   fi
  
#   AddElement(Glob_OptionParser\Rules())
#   Glob_OptionParser\Rules()\Key.s=Key.s
#   Glob_OptionParser\Rules()\Prefix.s=Prefix.s
#   Glob_OptionParser\Rules()\KeyDelim.s=KeyDelim.s
#   Glob_OptionParser\Rules()\ListDelim.s=ListDelim.s
#   Glob_OptionParser\Rules()\MaxList=MaxList
#   Glob_OptionParser\Rules()\Stacked=AllowStacking
#   Glob_OptionParser\Rules()\AllowEmptyList=AllowEmptyList
  
#   ProcedureReturn #True
# }
