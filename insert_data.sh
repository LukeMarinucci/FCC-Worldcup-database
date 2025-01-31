#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS

do

  if [[ $WINNER = 'winner' ]]
  then
    continue
  fi

test1="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")"
test2="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")"
  
  if [[ -z $test1 ]]
  then
    echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
  else 
    echo "$WINNER already in teams table"
  fi

  if [[ -z $test2 ]]
  then
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
  else
    echo "$OPPONENT already in teams table"
  fi

  winnerid="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  opponentid="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

  echo -e "$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  echo -e "$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $winnerid, $opponentid, $WINNERGOALS, $OPPONENTGOALS)")"

done
