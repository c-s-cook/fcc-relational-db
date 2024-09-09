#!/bin/bash


##    Text colors
##    ...that end up not being used because
##    including the "${HIGHLIGHT}" in the echo
##    messes up CodeRoad's acceptance of the output :(
HIGHLIGHT="\e[95m"  # light magenta
ERROR="\e[31m"      # red
NOCOLOR="\e[0m"     # no color



##    Prep for DB calls & connections
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
    echo -e -n "The element with atomic number $1 is $5 ($3). "
    echo -e -n "It's a $TYPE, with a mass of $MASS amu. "
    echo -e -n "$5 has a melting point of $MELT celsius "
    echo -e -n "and a boiling point of $BOIL celsius.\n"
  done
}




##########################################
##    Confirm / request input
##########################################

# check if input was received
if [[ -z $1 ]]
then
  # if no input, print a msg that input is required, then exit.
  echo -e "Please provide an element as an argument."
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

    echo -e "I could not find that element in the database."
  
  # if there are results
  else
    ELEMENT_INFO $ELEMENTS_RESULTS
  fi
  
fi

