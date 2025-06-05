#!/bin/bash


# PSQL Connection
# PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"
PSQL="psql --username=freecodecamp --dbname=number_guessing_game --tuples-only -c"

# Generate Random Number: 1 - 1,000
NUMBER=$(( RANDOM % 1000 +1 ))

# GLOBAL VARIABLES
GUESS_COUNT=0
NEW_USER=''
USER_ID=''
GAMES_PLAYED=0
BEST_GAME=''
GUESSES=()
CONTINUING_FROM=()


# RECORDING FUCNTIONS, BUT MESSES UP 
# CODE ROAD'S VALIDATION
# UNCOMMENT BELOW TO RECORD THE GAME
# RECORD_THE_GAME=true

SET_GAME_STATS(){
  GAMES_PLAYED=$1
  BEST_GAME=$2
}




ASK_PLAY_ACTIVE(){

    echo -e -n "\nWould you like to pick up where you left off? (Y/N): "
    read CONTINUE_ACTIVE_GAME

    # IF Yes...
    if [[ $CONTINUE_ACTIVE_GAME =~ ^[yY] ]]
    then
      # Set the NUMBER...
      NUMBER=$((HAS_ACTIVE_GAME))
      
      # Set the GUESSES...
      GUESSES_RESULTS=$($PSQL "SELECT guesses FROM active_games WHERE user_id = '$USER_ID'")
      GUESSES=($(echo $GUESSES_RESULTS))
      CONTINUING_FROM=($(echo $GUESSES_RESULTS))


      echo -e "\nOkay, we'll continue! Here's how it looked when you left off..."
      sleep 1

    elif [[ $CONTINUE_ACTIVE_GAME =~ ^[nN] ]]
    then
      echo "Okay, we'll start a new game!"
      # ELIF No, DELETE the record from the DB...
      DELETE_GAME_RESULT=$($PSQL "DELETE FROM active_games WHERE user_id = '$USER_ID'")

    else
      echo "Not a Y/N..."
      ASK_PLAY_ACTIVE
    fi
}




MAIN_MENU(){
  echo -e "\n#?#?#?#?# Number Guessing Game #?#?#?#?#\n"

  # Request <USERNAME> Input...
  echo -e -n "\nEnter your username: "
  read USERNAME

  # Check DB for username...
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
  

  # IF username is not found...
  if [[ -z $USER_ID ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."


    # Insert new username into DB...
    NEW_USER='true'
    NEW_USER_ID=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME') RETURNING user_id")
    if [[ -z $NEW_USER_ID ]]
    then
      echo 'Error adding new username to database...'
      exit
    else
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
    fi


  # ELSE is username is found...
  else
    

    # Query DB for player stats
    GAME_STATS=$($PSQL "SELECT games_played, best_game FROM games WHERE user_id = '$USER_ID'")
    
    # and Set the global GAME STATS variables...
    SET_GAME_STATS $(echo "$GAME_STATS" | while read PLAYED BAR BEST
      do
        echo "$PLAYED $BEST"
      done
    )


    # Display welcome msg...
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.\n"

    if [[ $RECORD_THE_GAME ]]
    then
      # QUERY DB to see if user has any active, unfinished games...
      HAS_ACTIVE_GAME=$($PSQL "SELECT number FROM active_games WHERE user_id = '$USER_ID'")

      # IF they do have an active, unfinished game...
      if [[ $HAS_ACTIVE_GAME ]]
      then
        # ask if they'd like to continue that game...
        echo -e -n "\nLooks like you have an active game you didn't finish."
        ASK_PLAY_ACTIVE
      fi
    else
      DELETE_GAME_RESULT=$($PSQL "DELETE FROM active_games WHERE user_id = '$USER_ID'")
    fi

  fi
  GET_GUESS
}


RECORD_ACTIVE_GAME(){
  # echo "Recording active game..."
  
  if [[ -z $RECORD_THE_GAME ]]
  then
    return
  fi
  
  # IF this is the very first guess, INSERT a new record...
  if [[ -z ${GUESSES[1]} ]]
  then
    RECORD_RESULTS=$($PSQL "
      INSERT INTO 
      active_games(user_id, number, guesses)
      VALUES('$USER_ID', '$NUMBER', '${GUESSES[0]}')
    ")
  else
    # ELSE, UPDATE the record with new guesses...
    RECORD_RESULTS=$($PSQL "
      UPDATE active_games
      SET guesses = '$(echo ${GUESSES[*]})'
      WHERE user_id = '$USER_ID'
    ")
  fi

  if [[ -z $RECORD_RESULTS ]]
  then
    echo "Error recording active game..."
  fi
}



GET_GUESS(){
  if [[ $1 ]]
  then
    echo -e -n "\n$1"
  else
    # Request a number GUESS
    echo -e -n "\nGuess the secret number between 1 and 1000: "
  fi

  if [[ ${CONTINUING_FROM[0]} ]]
  then
    GUESS=${CONTINUING_FROM[0]}
    echo "$GUESS"
    ((GUESS_COUNT++))
    unset CONTINUING_FROM[0]
    CONTINUING_FROM=($(echo ${CONTINUING_FROM[*]}))
  else
    read GUESS
    ((GUESS_COUNT++))
    GUESSES+=($GUESS)
    RECORD_ACTIVE_GAME
  fi



  # IF GUESS is not an integer...
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then

    # Display Error msg & request new guess
    GET_GUESS "That is not an integer, guess again: "

  # ELSE check GUESS against NUMBER...
  # IF too big...
  elif [[ $GUESS -gt $NUMBER ]]
  then
    GET_GUESS "It's lower than that, guess again:  "
  
  # ELIF too small...
  elif [[ $GUESS -lt $NUMBER ]]
  then
    GET_GUESS "It's higher than that, guess again: "

  # ELSE it's right! 
  elif [[ $GUESS -eq $NUMBER ]]
  then
    # Assess best_game info...
    if [[ -z $BEST_GAME || $BEST_GAME -gt $GUESS_COUNT ]]
    then
      BEST_GAME=$GUESS_COUNT
    fi

    # Increment the games_played
    ((GAMES_PLAYED++))

    # INSERT Game info into DB...
    if [[ -z $NEW_USER ]]
    then
      RECORD_GAME_STATS=$($PSQL "
        UPDATE games
        SET 
        games_played = '$GAMES_PLAYED', 
        best_game = '$BEST_GAME' 
        WHERE user_id = '$USER_ID'
      ")
    else
      RECORD_GAME_STATS=$($PSQL "
        INSERT INTO games(user_id, games_played, best_game) 
        VALUES('$((USER_ID))', '$GAMES_PLAYED', '$BEST_GAME')
      ")
    fi

    if [[ $RECORD_THE_GAME ]]
    then
      # Delete the active_game record...
      DELETE_GAME_RESULT=$($PSQL "DELETE FROM active_games WHERE user_id = '$USER_ID'")
    fi

    # Dispaly Congrats Msg...
    echo -e "\nYou guessed it in $GUESS_COUNT tries. The secret number was $NUMBER. Nice job!"
  fi
} # END GUESS()


#Run it!
MAIN_MENU







