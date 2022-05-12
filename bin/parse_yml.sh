#!/bin/bash

# https://gist.github.com/masukomi/e587aa6fd4f042496871

# ==============================================================================
# Parses definitions in a yaml file to bash variables
# ==============================================================================
#
# Accept a prefix as argument:
# parse_yaml file.yml "PREF_" will result in variables names prefixed by "PREF_"
#
# ==============================================================================
# Usage
# ==============================================================================
# 
# ==============================================================================
# Example
# ==============================================================================
# A yaml file with the following contents:
#
# global:
#   debug: yes
#   verbose: no
#   debugging:
#     detailed: no
#
# would be parsed to:
#
# global_debug="yes"
# global_verbose="no"
# global_debugging_detailed="no"
#
# ==============================================================================
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}