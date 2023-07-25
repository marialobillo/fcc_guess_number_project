#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -c"

RANDOM_NUMBER = $(( $RANDOM % 1000 + 1 ))
COUNT_GUESSES=0
GUESS_NUMBER=-1

echo "Enter your username:"
read USERNAME

# check if the name is in users table
USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  echo "Welcome, '$USERNAME'! It looks like this is your first time here."
  # the user is NOT in db, so insert username
  INSERT_USER=$($PSQL "insert into users (username) values ('$USERNAME')")
  
else
  # the user is already in db
  GAMES_PLAYED=$($PSQL "select count(*) from games where user_id='$USER_ID'")
  BEST_GAME=$($PSQL "select min(guesses) from games where user_id='$USER_ID'")
  echo "Welcome back, '$USERNAME'! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"

until [[ $GUESS_NUMBER == $RANDOM_NUMBER ]]
do
  ((COUNT_GUESSES++))
  read GUESS_NUMBER 

  # check if guess number is a number
  if [[ ! $GUESS_NUMBER =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS_NUMBER -gt $RANDOM_NUMBER ]]
  then 
    echo "It's lower than that, guess again:"
  elif [[ $GUESS_NUMBER -lt $RANDOM_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  fi
done

USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")
RESULT=$($PSQL "insert into games (user_id, guesses) values ($USER_ID, $COUNT_GUESSES)")
echo "You guessed it in $COUNT_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"







