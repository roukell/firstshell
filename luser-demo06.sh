#!/bin/bash

# this script generates a random password for each user specified on the command line.

# display what the user typed on the command line.
echo "you executed this command: ${0}"

# display the path and filename of the script
echo "you used $(dirname ${0}) as the path to the $(basename ${0}) script"

# tell the user how many arguments they passed in
# (inside the script they are parameters, outside they are arguments)
NUM_OF_PARAM="${#}"
echo "you supplied ${NUM_OF_PARAM} argument(s) on the command line"

# make sure they at least supply one argument
if [[ "${NUM_OF_PARAM}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [USER_NAME]..."
  exit 1
fi

# generate and display a password for each parameter
for USER_NAME in "${@}"
do
  PASSWORD=$(date +%s%N | sha256sum | head -c48)
  echo "${USER_NAME}: ${PASSWORD}"
done
