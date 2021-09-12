#!/usr/bin/env bash

# args to 7za:
# -p: ask for a password to use
# -an: don't use an archive name
# -tbzip2: use compression bz2 (mandatory parameter when no archive name)
# -si: read data from stdin
# -so: write data out to stidn


if [ $# -eq 0 ]
then
    # no arguments, use stdin
    cat | 7za a -an -tbzip2 -p -si -so | base64 | pastebinit
else
    # use arg 1 as a filename
    #7za a -an -tbzip2 -p -so "$1" | base64 | pastebinit
    7za a -p "/tmp/$USER/pastebin_upload_tempfile.7z" "$1"
    cat "/tmp/$USER/pastebin_upload_tempfile.7z" | base64 | pastebinit
fi



