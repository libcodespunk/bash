# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

k_yaml_KEY=__YAMLKEY
k_yaml_KEY_TYPE=__YAMLKEY_TYPE
k_yaml_KEY_TYPE_SECTION=__YAMLKEY_SECTION

function p_yaml_parse_file() {
   local _1=$1; shift # Yaml file to parse
   local _2=$1; shift # Output array name
   
   if ! [ -s $_1 ] || ! [[ $_2 ]]; then
      exit 1
   fi
   
   echo "declare -g -A $_2;"

   local s='[[:space:]]*'
   local w='[a-zA-Z0-9_]*'
   local fs=$(echo @|tr @ '\034')
   
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $_1 | \
   \
   awk -F$fs '{
      key_short=$2
      value=$3
      
      indent = length($1)/2;
      key_name[indent]=key_short
      
      for (i in key_name)
         if (i > indent)
            delete key_name[i]
      
         key=""
         
         for (i=0; i<indent; i++) {
            if (length(key) != 0)
               key=(key)(".")
            
            key=(key)(key_name[i])
         }
         
         if (length(key) == 0) {
            printf("[[ \"${'$_2'['$k_yaml_KEY']}\" ]] && '$_2'['$k_yaml_KEY']+=\" \";\n");
            printf("'$_2'['$k_yaml_KEY']+=\"%s\";\n", key_short)
         }
         else {
            printf("[[ \"${'$_2'[%s'$k_yaml_KEY']}\" ]] && '$_2'[%s'$k_yaml_KEY']+=\" \";\n", key, key);
            printf("'$_2'[%s'$k_yaml_KEY']+=\"%s\";\n", key, key_short)
         }
         
         if (length(value) > 0)
            printf("'$_2'[%s%s'$k_yaml_KEY_TYPE']+='$k_yaml_KEY_TYPE_SECTION';\n", key, key_short)
         
         if (length(value) > 0) {
            if (length(key) != 0)
               key=(key)(".")(key_short)
            else
               key=key_short
            
            printf("'$_2'[%s]=\"%s\";\n", key, value)
         }
   }'
}

function _yaml_as_array() {
   local _1=$1; shift # Yaml file to parse
   local _2=$1; shift # Output array name
   
   eval $(p_yaml_parse_file $_1 $_2);
}

function _yaml_get_key_type() {
   local _1=$1; shift # Yaml array
   local _2=$1; shift # Section
}

function _yaml_get_keys_e() {
   local _1=$1; shift # Yaml array
   local _2=$1; shift # Section
   local keys
   
   _array_copy $_1 g_yaml_1
   
   for k in ${g_yaml_1[$_2$k_yaml_KEY]}; do
      [[ $keys ]] && keys+=" "
      keys+=$k
   done
   
   # This variable is global
   unset g_yaml_1
   
   echo $keys
}

# _yaml_as_array $1 yaml

# #627b3ef4-478a-486b-bda2-5ce5c5fe178e.yml

# echo "homes:"
# for a in $(_yaml_get_keys_e yaml homes); do
#    if [[ $a = home ]]; then
#       echo "- name: _global"
#    else
#       echo "- name: $a"
#    fi
   
#    echo "  location: ${yaml[homes.$a.x]}, ${yaml[homes.$a.y]}, ${yaml[homes.$a.z]}, ${yaml[homes.$a.yaw]}, ${yaml[homes.$a.pitch]}"
#    echo "  world: ${yaml[homes.$a.world]}"
# done
