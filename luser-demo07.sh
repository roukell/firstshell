#!/bin/bash

# demo the use of shift and while loops

# display the first three parameters
echo "parameter 1: ${1}"
echo "parameter 1: ${2}"
echo "parameter 1: ${3}"
echo

# loop through all the positional parameters
while [[ "${#}" -gt 0 ]]
do
  echo "number of parameters: ${#}"  
  echo "parameter 1: ${1}"
  echo "parameter 1: ${2}"
  echo "parameter 1: ${3}"
  echo
  shift
done
