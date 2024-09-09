#!/bin/bash


##    Text colors
HIGHLIGHT="\e[95m"  # light magenta
ERROR="\e[31m"      # red
NOCOLOR="\e[0m"     # no color



##    Prep DB calls & connections
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"






##########################################
##    Retreive element info, format
##    and then output it.
##########################################

ELEMENT_INFO(){

  ELEMENT_INFO_RESULTS=$($PSQL "
    SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type
    FROM properties
    FULL JOIN types USING(type_id)
    WHERE atomic_number = $1
  ")

  echo "$ELEMENT_INFO_RESULTS" | while read MASS BAR MELT BAR BOIL BAR TYPE
  do
    COLOR=0
    if [[ $COLOR === 1 ]]
    then
      echo -e -n "The element with atomic number ${HIGHLIGHT}$1${NOCOLOR} is ${HIGHLIGHT}$5 ($3)${NOCOLOR}. "
      echo -e -n "It's a ${HIGHLIGHT}$TYPE${NOCOLOR}, with a mass of ${HIGHLIGHT}$MASS amu${NOCOLOR}. "
      echo -e -n "$5 has a melting point of ${HIGHLIGHT}$MELT celsius${NOCOLOR} "
      echo -e -n "and a boiling point of ${HIGHLIGHT}$BOIL celsius${NOCOLOR}.\n"
    else
      echo -e -n "The element with atomic number $1 is $5 ($3). "
      echo -e -n "It's a $TYPE, with a mass of $MASS amu. "
      echo -e -n "$5 has a melting point of $MELT celsius "
      echo -e -n "and a boiling point of $BOIL celsius.\n"
    fi
  done
}


# The element with atomic number 1 is Hydrogen (H). 
# It's a nonmetal, with a mass of 1.008 amu. 
# Hydrogen has a melting point of -259.1 celsius 
# and a boiling point of -252.9 celsius.


# 




##########################################
##    Confirm / request input
##########################################

# check if input was received
if [[ -z $1 ]]
then
  # if no input, print a msg that input is required, then exit.
  echo -e "Please provide an ${ERROR}element${NOCOLOR} as an argument."
else

  # if input is a number...
  if [[ $1 =~ ^[0-9]+$ ]]
  then

    # check if input matches any atomic_number db records
    ELEMENTS_RESULTS=$($PSQL "
      SELECT * FROM elements 
      WHERE atomic_number = $1;    
    " 2>> stderr.txt) 

  # if the input is NOT a number...
  else

    # check if the input matches symbol or name in db
    ELEMENTS_RESULTS=$($PSQL "
      SELECT * FROM elements 
      WHERE symbol = '$1'
      OR name = '$1';    
    " 2>> stderr.txt)
  fi

  # if there are no results...
  if [[ -z $ELEMENTS_RESULTS ]]
  then

    echo -e "I ${ERROR}could not${NOCOLOR} find that ${ERROR}element${NOCOLOR} in the database."
  
  # if there are results
  else
    ELEMENT_INFO $ELEMENTS_RESULTS
  fi
  
fi

