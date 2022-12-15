#!/bin/bash

# Hint: run like this on multiple files
# parallel -t -lb -k -j 1 ./commit.sh {} debug ::: *.yaml

# CONFIGURATION

CODE_AUTHOR="Maxigas"
CODE_AUTHOR_EMAIL="maxigas@criticalinfralab.net"
DOMAIN="v2.nl"
SLEEP=0

if [ $1 == purge ]; then
    echo "INIT = Purging repo."
    rm -rf .git
    exit 0
else
    echo "INIT = Initialising repo."
    git init
    git add commit.sh
    git commit --author="$CODE_AUTHOR <$CODE_AUTHOR_EMAIL>" -m "The script that generated this repository."
fi

if [ -f "$1" ]; then
    echo Found file.
    FILE="$1"
    BASENAME="$(basename $1 .yaml)"
    HTML="$BASENAME.html"
else
    echo ERROR: File not found.
    exit 2
fi

if [ "$2" == "debug" ]; then
    DEBUG=true
else
    DEBUG=false
fi

# HELPER FUNCTIONS

debug () {
    local NAME="$1"
    local VALUE="$2"
    if [ $DEBUG = true ]; then echo "$1" = "$2"; fi
    }

debug FILE $FILE
debug BASENAME $BASENAME
debug HTML $HTML
debug "======"

# INITALISATION

if [ -f .git/config ]; then
    echo "INIT = Found repo."
else
    echo "INIT = Initialising repo."
    git init
    git add commit.sh
    git commit --author="$CODE_AUTHOR <$CODE_AUTHOR_EMAIL>" -m "The script that generated this repository."
fi

# LOAD VARIABLES

TITLE=$(grep Title: $FILE | cut -d ' ' -f 2)
debug TITLE "$TITLE"
# if [ $DEBUG = true ]; then echo TITLE = $TITLE; fi
AUTHOR="$(grep Author: $FILE | cut -d ' ' -f 2)"
debug AUTHOR "$AUTHOR"
read -r -a AUTHOR_FIRST_NAME <<< "$AUTHOR"
debug AUTHOR_FIRST_NAME "$AUTHOR_FIRST_NAME"
EMAIL="$AUTHOR <$AUTHOR_FIRST_NAME@${DOMAIN}>"
debug EMAIL $EMAIL
# if [ $DEBUG = true ]; then echo AUTHOR = $AUTHOR; fi 
YEAR=$(grep Year: $FILE | cut -d ' ' -f 2)
debug YEAR "$YEAR"
# if [ $DEBUG = true ]; then echo YEAR = $YEAR; fi
CATEGORY=$(grep Category: $FILE | cut -d ' ' -f 2)
debug CATEGORY "$CATEGORY"
# if [ $DEBUG = true ]; then echo CATEGORY = $CATEGORY; fi
TAG=$(grep Tag: $FILE | cut -d ' ' -f 2- | tr -d '"')
debug TAG "$TAG"
# if [ $DEBUG = true ]; then echo TAG = $TAG; fi

# DECOMPILE TAGS

# mapfile -t TAGS < <( echo $TAG | tr -d '"' | tr -d ',')
IFS=', ' read -r -a TAGS <<< "$TAG"
debug FIRST_TAG "${TAGS[0]}"
# if [ $DEBUG = true ]; then echo FIRST TAG = "${TAGS[0]}"; fi
if [ "${TAGS[0]}" = $YEAR ]; then TAGS=("${TAGS[@]:1}"); debug "WORKAROUND" "slice" ; fi
debug FIRST_TAG "${TAGS[0]}"

# MAKE COMMITS

git checkout main
git add $HTML
debug GIT "git commit --author=\"$EMAIL\" --date=$YEAR-01-01 -m \"$TITLE\""
git commit --author="$EMAIL" --date=$YEAR-01-01 -m "$TITLE"

for T in "${TAGS[@]}"; do
    # NB: Next command makes a new branch if needed, otherwise switches
    debug GIT "git branch $T"
    git branch $T
    sleep $SLEEP
    debug GIT "git checkout $T"
    git checkout $T
    sleep $SLEEP
    debug ECHO "echo >> $HTML"
    echo >> $HTML
    debug GIT "git add $HTML"
    git add $HTML
    sleep $SLEEP
    debug GIT "git commit --author=\"$EMAIL\" --date=$YEAR-01-01 -m \"$TITLE\""
    git commit --author="$EMAIL" --date=$YEAR-01-01 -m "$TITLE"
done

# WRAP UP

git checkout main

