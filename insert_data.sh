#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
  #find out if winner is entered
    WINNER_ENTERED=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    if [[ -z $WINNER_ENTERED ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $INSERT_WINNER
    fi
  #find out if opponent is entered
    OPPONENT_ENTERED=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
  #if not enter the team
    if [[ -z $OPPONENT_ENTERED ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $INSERT_OPPONENT
    fi

  #grab some ID variables. This could probably be done in a select subquery but this should look cleaner. Not sure about performance though...
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  #insert into games
    GAME_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo $GAME_INSERT
fi
done
