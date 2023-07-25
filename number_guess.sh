#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -c"

echo $(( $RANDOM % 1000 + 1 ))

echo "Enter your username:"
read name

# check if the name is in users table
IS_USER_EXIST = echo $($PSQL "select * from users where name='$name'")

if [[ -z $IS_USER_EXIST ]]
then
  # the user is not in db, so insert user name
  INSERT_USER=$($PSQL "insert into users (name) values ('$name')")
  echo "Welcome, '$name'! It looks like this is your first time here."
  
else
  # the user is already in db
  
  echo "$IS_USER_EXIST" | while read user_id bar name
  do 
    GAMES_PLAYED=$($PSQL "select count(*) from games where user_id='$user_id'")
    BEST_GAME=$($PSQL "select min(guesses) from games where user_id='$user_id'")
    echo "Welcome back, '$name'! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done



