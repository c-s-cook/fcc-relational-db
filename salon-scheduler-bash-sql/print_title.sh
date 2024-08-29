#!/bin/bash


# regex notes
# https://linuxsimply.com/bash-scripting-tutorial/string/regex/



#####################
##    VARIABLES    ##
#####################

FILE="./hair-salon-title.txt"

BG="\e[95m"   #light magenta
FACE="\e[33m"  #yellow
SHADE="\e[32m"     #green



#####################
##    FUNCTIONS    ##
#####################

MATCH_BG(){
  
  # double-up the \ to escape each one of them
  TEMP=$(echo $1 | sed -E 's/\\/\\\\/g')

  # insert BG color code between \ and _
  TEMP2=$(echo $TEMP | sed -E 's/\\_/\\\'${BG}'_/g')

  # insert BG color code between / and _
  TEMP2=$(echo $TEMP2 | sed -E 's/\/_/\/\'${BG}'_/g')

  # insert FACE color
  TEMP3="$(MATCH_FACE $TEMP2)"

  # insert SHADE color
  TEMP4="$(MATCH_SHADE $TEMP3)"

  echo "${BG}$TEMP4"
}


MATCH_FACE(){
  
  # insert FACE color code between /\
  COLOR_FACE=$(echo $1 | sed -E 's/\/\\/\\'${SHADE}'\/\\'${FACE}'\\/g')

  echo "$COLOR_FACE"
}


MATCH_SHADE(){

  # insert SHADE color code at the start of each shade \/
  COLOR_SHADE1=$(echo $1 | sed -E 's/\\\//'${SHADE}'\\\//g')

  # insert SHADE color code at the start of each shade _\
  COLOR_SHADE2=$(echo $COLOR_SHADE1 | sed -E 's/_\\/_\'${SHADE}'\\/g')

  echo "$COLOR_SHADE2"
}



#####################
##    PRINT IT!    ##
#####################

while read -r LINE; do
  echo -e $(MATCH_BG "$LINE")
done <$FILE
