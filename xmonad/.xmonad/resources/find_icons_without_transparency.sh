#!/usr/bin/env bash

# Look for xpm icons that are missing transparency (technically searches for white)

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 XPM_FILE [ XPM_FILE ... ]"
    exit 1
fi

egrep "(#FFFFFF|#ffffff)" $@

exit 0

# iterate over xpm files
while test ${#} -gt 0
do
    input_file="$1"
    egrep "(#FFFFFF|#ffffff)" $@
    new_filename=$(echo "$input_file" | sed -e "s/_black/_${new_hex_color}/g" | sed -e "s/#//g")
    echo "saving $new_filename"
    cat "$input_file" | sed -e "s/#000000/${new_hex_color}/g" > "$new_filename"
    shift
done

