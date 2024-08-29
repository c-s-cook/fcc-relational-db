#!/bin/bash

# Dump / export Postgres DB:
# pg_dump -U freecodecamp -h localhost <database> >> <filename.sql>

# Extract / Import Postgres DB:
# psql -U username -W -d <database> -f <filename.sql>
# psql -U postgres <database> < <filename.sql>


##########################################
##    Text colors
##########################################
HIGHLIGHT="\e[95m"  # light magenta
NOCOLOR="\e[0m"     # no color


##########################################
##    Prep DB calls & connections
##########################################
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# get the total count of services, and strip spaces off front
TOTAL_SERVICES=$($PSQL "SELECT COUNT(*) FROM services" | sed -E 's/^ *| *$//g')


##########################################
##    If user inputs a number that is
##    out of the menu's range...but 
##    not TOO FAR out of range, give
##    them a message about a serivce that
##    has been "removed"
##########################################
OLD_SERVICES="./failed-services.txt"
OLD_SERVICES_LGTH=$(wc -l < $OLD_SERVICES)

GET_FAILED_SERVICE(){
  i=0
  while read LINE; do
    i=$(( i + 1 ))
    test $i = $1 && echo "$LINE";
  done < "$OLD_SERVICES"
}


##########################################
##    If user inputs a number that's WAY
##    out of range, iterate through a
##    list of changing responses.
##########################################
ERRORMSG="./error-messages.txt"
ERRMSG_LGTH=$(wc -l < $ERRORMSG)
ERRMSG=0

GET_ERROR_MSG(){
  i=0
  while read LINE; do
    i=$(( i + 1 ))
    test $i = $ERRMSG && echo "$LINE";
  done < "$ERRORMSG"
}


##########################################
##    For cleaning spaces off of the
##    head or tail of PSQL results
##########################################
REMOVE_SPACES(){
  echo $1 | sed -E 's/^ *| *$//g'
}






##########################################
##    Print welcome screen
##########################################

test -e ./print_title.sh && ./print_title.sh

echo -e "${NOCOLOR}\n\nThank you for choosing Hairy Gary's Very Airy Hair Salon!\n"
echo -e "${HIGHLIGHT}We offer the following services${NOCOLOR}:\n "




##########################################
##    DO IT!
##########################################

MAIN_MENU() {
  if [[ $1 ]]
  then
   echo -e '\n'$1 '\n'
  fi
  
  
  # get list of services & display it
  SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR NAME
    do
      ### The FCC tests didn't like me adding color... :(
      # echo -e "$SERVICE_ID${HIGHLIGHT})${NOCOLOR} $NAME"
      echo -e "$SERVICE_ID) $NAME"
    done

  # receive user input
  echo -e -n "\nWhich would you like?${HIGHLIGHT} "
  read SERVICE_ID_SELECTED
  SELECTED_SERVICE $SERVICE_ID_SELECTED

}


SELECTED_SERVICE(){
  
  # if input is not a number...
  if [[ ! $1 =~ ^[0-9]+$ ]]
    then
      #send to main menu
       MAIN_MENU "That is not a number."
  
  # if input is out of range...
  elif [[ $1 -gt $TOTAL_SERVICES ]]
    then
      if [[ $1 -gt $TOTAL_SERVICES+$OLD_SERVICES_LGTH ]]
        then
        if [[ $ERRMSG -lt $ERRMSG_LGTH ]]
        then
          ERRMSG=$(($ERRMSG + 1))
        fi
        MAIN_MENU "$(GET_ERROR_MSG)"
      else
        FAILED=$(($1 - $TOTAL_SERVICES))
        MAIN_MENU "${NOCOLOR}Sorry, ${HIGHLIGHT}we no longer offer $(GET_FAILED_SERVICE $FAILED)${NOCOLOR}."
      fi
  else
    SERVICE_TYPE=$(REMOVE_SPACES "$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")")
    echo -e "${NOCOLOR}A ${HIGHLIGHT}$SERVICE_TYPE${NOCOLOR}, excellent choice!"
    GET_CUSTOMER_INFO
  fi
}


GET_CUSTOMER_INFO(){
  if [[ $1 ]]
  then
    echo -e '\n' $1 '\n'
  fi

  # ask for their phone number
  echo -n -e "\nPlease enter your phone number, including area code: ${HIGHLIGHT}"
  read CUSTOMER_PHONE

  #remove spaces, parentheses periods, and hyphens
  #####   Works, but not passing FCC's tests
  #PHONE_FORMATTED=$(echo $CUSTOMER_PHONE | sed -E 's/[ ().-]//g')
  PHONE_FORMATTED=$CUSTOMER_PHONE

  # check against anything other than numbers (adding: - . )
  if [[ ! $PHONE_FORMATTED =~ ^[0-9.-]+$ ]]
  then
    GET_CUSTOMER_INFO "${NOCOLOR}Sorry, didn't catch that."

  # if it's not a 10-digit number
  #####   This extra stuff seems to be messing with the tests...
  #elif [[ ${#PHONE_FORMATTED} -ne 10 ]]
  elif [[ ${#PHONE_FORMATTED} -gt 20 ]] #just cranking it up to keep the code format for the moment
  then
    GET_CUSTOMER_INFO "${NOCOLOR}Try again. Please enter a 10 digit phone number."
  

  else
        
    # look up customer in db
    CUSTOMER_NAME=$(REMOVE_SPACES "$($PSQL "SELECT name FROM customers WHERE phone = '$PHONE_FORMATTED'")")
  
    
    # if customer's record wasn't found...
    if [[ -z $CUSTOMER_NAME ]]
    then
      # get their name
      echo -e -n "\n${NOCOLOR}Could I have your name, please? "
      read CUSTOMER_NAME
      CUSTOMER_NAME_CLEANED=$(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')
      CUSTOMER_NAME=$CUSTOMER_NAME_CLEANED

      #insert new customer info
      INSERT_NEW_RESULTS=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$PHONE_FORMATTED')")
      
      # check again errors
      if [[ -z $INSERT_NEW_RESULTS ]]
      then
        GET_CUSTOMER_INFO "Had an issue adding you to our system."
      fi
    fi
    
    CUSTOMER_ID=$(REMOVE_SPACES "$($PSQL "SELECT customer_id FROM customers WHERE phone = '$PHONE_FORMATTED' AND name = '$CUSTOMER_NAME'")")
    
    
    
    if [[ -z CUSTOMER_ID ]]
    then
      GET_CUSTOMER_INFO "Had an issue matching $CUSTOMER_NAME and $PHONE_FORMATTED in our records for some reason..."
    fi
    
    #echo "$CUSTOMER_ID) $CUSTOMER_NAME -- $PHONE_FORMATTED"
    
    SCHEDULE_APPT

  fi
}




SCHEDULE_APPT(){
  # ask for appt time
  echo -n -e "\n${NOCOLOR}What time would you like to come in? ${HIGHLIGHT}"
  read SERVICE_TIME

  SET_APPT_RESULTS=$($PSQL "
    INSERT INTO appointments(service_id, customer_id, time) 
    VALUES('$SERVICE_ID_SELECTED', '$CUSTOMER_ID', '$SERVICE_TIME') 
  ")

  if [[ -z $SET_APPT_RESULTS ]]
  then
    echo "${NOCOLOR}Couldn't add the appt to our scheduler system."
  else
    ###   The FCC tests didn't like me adding color  :(
    #echo -e "\n${NOCOLOR}I have put you down for a ${HIGHLIGHT}$SERVICE_TYPE at $SERVICE_TIME${NOCOLOR}, $CUSTOMER_NAME.\n\n"
    echo -e "\nI have put you down for a $SERVICE_TYPE at $SERVICE_TIME, $CUSTOMER_NAME.\n\n"
  fi
}







MAIN_MENU