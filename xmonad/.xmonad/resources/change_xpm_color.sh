#!/usr/bin/env bash

# Change color of one or more XPM files
#
# Assumes input files only have one color, black (#000000), and replaces it.

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 NEW_HEX_COLOR XPM_FILE [ XPM_FILE ... ]"
    exit 1
fi

new_hex_color="$1"
if ! echo "$new_hex_color" | egrep "^#[0-9A-Fa-f]{6}$" > /dev/null; then
    echo "Hex color should be in hex format (#000000)"
    exit 1
fi


#ignore first parm
shift

# iterate over xpm files
while test ${#} -gt 0
do
    input_file="$1"
    new_filename=$(echo "$input_file" | sed -e "s/_black/_${new_hex_color}/g" | sed -e "s/#//g")
    echo "saving $new_filename"
    cat "$input_file" | sed -e "s/#000000/${new_hex_color}/g" > "$new_filename"
    shift
done

