#!/bin/bash

wget -o wget.log -r -np --continue --follow-tags=a -l 1 --adjust-extension --convert-links https://v2.nl/archive/works/
