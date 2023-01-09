#!/bin/bash

VALOR=$1

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  elif [[ $1 =~ ^[0-9]+$ ]]
  then
  ELEMENT_NUM=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number = $1")
  if [[ -z $ELEMENT_NUM ]]
    then
    echo "I could not find that element in the database."
    else
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
  ELEMENT_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1")
  ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELEMENT_ID")
  ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1")
  ELEMENT_MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1")
  ELEMENT_BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")
   #echo "$($PSQL "")"
   echo "The element with atomic number $ELEMENT_NUM is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELT celsius and a boiling point of $ELEMENT_BOIL celsius."
   fi
   
  elif [[ $1 =~ ^[a-z]+$ || ^[A-Z]+$  ]]
  then
  #CONVERTED_VAR=$(echo $1 | tr '[:upper:]' '[:lower:]')
  #KEY= echo "${CONVERTED_VAR^}"
  #echo $KEY
  
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name ILIKE '$1'")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol ILIKE '$1'")
    if [[ -z $ELEMENT_NAME && -z $ELEMENT_SYMBOL ]]
      then
      echo "I could not find that element in the database."
      exit
      elif [[ ! -z $ELEMENT_NAME ]]
      then
      ELEMENT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME'")
      else
      ELEMENT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ELEMENT_SYMBOL'")
      fi
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT_NUM")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_NUM")
    #
    ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT_SYMBOL'")
    ELEMENT_AN=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ELEMENT_ID")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ELEMENT_AN")
    #
    ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ELEMENT_NUM")
    ELEMENT_MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT_NUM")
    ELEMENT_BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT_NUM")
    echo "The element with atomic number $ELEMENT_NUM is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELT celsius and a boiling point of $ELEMENT_BOIL celsius."
    else
    echo "I could not find that element in the database. XD"
fi
