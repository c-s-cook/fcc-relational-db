#!/bin/bash
cat $1 | sed -E 's/catnip/dogchow/g; s/cat/dog/g; s/meow|meowzer/woof/g'

## testing with...
## ./translate.sh kitty_ipsum_1.txt  | grep -E --color 'dog[a-z]*|woof[a-z]*'

## THIS PROJECT FOCUSED ON....
##    wc; wc -l; wc -w; wc -m
##    grep --color -o -n
##    sed
##    redirection, overwriting stdout >
##    redirection, appending stdout >>
##    redirection of stdin <
##    redirection of stderr 2>
##    piping output of one | to another
##    touch <filename>
##    chmod +x <filename>
