#!/bin/bash

# Wipe Git directory
rm -rf .git

if [ -f "$1" ]; then
    echo Found file.
    FILE="$1"
    BASENAME="$(basename $1 .html)"
    HTML="$BASENAME.html"
else
    echo ERROR: File not found.
    exit 2
fi

# LOAD VARIABLES

TITLE=$(grep Title: $FILE | cut -d ' ' -f 2)
AUTHOR=$(grep Author: $FILE | cut -d ' ' -f 2)
YEAR=$(grep Year: $FILE | cut -d ' ' -f 2)
CATEGORY=$(grep Category: $FILE | cut -d ' ' -f 2)
TAG=$(grep Tag: $FILE | cut -d ' ' -f 2-)

# DECOMPILE TAGS

mapfile -t TAGS < <( echo $TAG | tr -d '"' | tr -d ',' | tr )
echo TAGS= "${TAGS[0]}"

# MAKE COMMITS

for T in "${TAGS[@]}"; do
    # NB: Next command makes a new branch if needed, otherwise switches
    echo git branch $T
    echo git add $HTML
    echo git commit --name=$AUTHOR --date=$YEAR-01-01 -m $TITLE
done

