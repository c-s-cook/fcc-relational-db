#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


# SCRIPT TO INSERT DATA FROM games.csv INTO worldcup DATABASE TABLES teams AND games

echo $($PSQL "TRUNCATE teams, games")

echo -e '\n ## UNIQUE TEAMS: \n'

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then

    # INSERT TEAM NAMES INTO teams TABLES

    # check for winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert winner
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        echo Inserted into teams: $WINNER_ID - $WINNER
      fi

    fi

    # check for opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert opponent
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        echo Inserted into teams: $OPPONENT_ID - $OPPONENT
      fi

    fi

    # INSERT EACH GAME INTO games TABLE

    INSERT_GAME_RESULT=$($PSQL "
    INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')
    ")

    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
    then
      
      GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year='$YEAR' AND round='$ROUND' AND winner_id='$WINNER_ID'")
      
      if [[ $GAME_ID ]]
      then
        echo Inserted game: $GAME_ID - $YEAR - $ROUND // $WINNER: $WINNER_GOALS -- $OPPONENT: $OPPONENT_GOALS
      else
        echo Successfully inserted the game, but had an issue retreiving it...?
      fi

      

    fi

  fi
  
  
done

echo -e '\n'