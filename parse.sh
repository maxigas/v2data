#!/bin/bash

# First attempt at selecting authors:
# grep -Po 'https://v2.nl/archive/people/.*?/"' *.html
# First attempt at selecting dates:
# grep keywords *html | grep -Po 'content=".*?"' | grep -Po '"[1-2][0-9][0-9][0-9],' | sort -r^C

if [ -f "$1" ]; then
    echo Found file.
    FILE="$1"
    BASENAME="$(basename $1 .html)"
    OUT="$BASENAME.yaml"
else
    echo ERROR: File not found.
    exit 2
fi

# Make sure that the input file is empty
echo > $OUT

# Extract and write out descriptive information

# ---- TITLE ----

FIELD="Title"
VALUE=$BASENAME
echo $FIELD: $VALUE >> $OUT

# State that for now we only have "works" (later implement "authors")
# ---- CATEGORY ----

FIELD="Category"
VALUE="work"
echo $FIELD: $VALUE >> $OUT

# ---- AUTHOR ----

FIELD="Author"
mapfile -t VALUE < <( grep -o '/people/.*/\"' $FILE | sed 's|/people/||' | sed 's|/leadImage_preview/\"||' )
# If not author then let's call them "anonymous"
[ -z "$VALUE" ] && VALUE="anonymous"
# The author name is almost always preceded by the string "by "
# More author names could be filled in by grepping the description?
# But name recognition can be tricky...
echo $FIELD: ${VALUE[@]} >> $OUT

# ---- TAGS ----

# Example:
# <meta content="2015, art, ecology, recycling, sustainability, trash" name="keywords" />
FIELD="Tag"
VALUE=$(grep -Po 'content=.*?\/>' $FILE | grep keywords | grep -Po '\".*?\"' | head -1)
echo $FIELD: $VALUE >> $OUT

# ---- YEAR ----

# Year is usually the first keyword.
# The keywords are still in $VALUE

FIELD="Year"
VALUE=$( echo $VALUE | cut -d ',' -f 1 | tr -d '"')
echo $FIELD: $VALUE >> $OUT

