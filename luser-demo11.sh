#!/bin/bash

# this script generates a random password
# this user can set the password length with -l and add a special character with -s
# verbose mode can be enabled with -v

usage() {
  echo "Usage: ${0} [-vs][-l LENGTH]">&2
  echo 'Generate a random password'
  echo '  -l LENGTH Specify the password length'
  echo '  -s        Append a special character to the password'
  echo '  -v        Increase verbosity'
  exit 1
}

log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}

# set a default password length
LENGTH=48

while getopts vl:s OPTION
do
  case ${OPTION} in
    v)
      VERBOSE='true'
      log 'Verbose mode on'
      ;;
    l)
      LENGTH="${OPTARG}"
      ;;
    s) 
      USE_SPECIAL_CHARACTER='true'
      ;;
    ?)
      usage
      ;;
  esac
done

echo "Number of args: ${#}"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

# inspect OPTIND - OPTIND stores the position of the next command line arguemnt folling the options in that variable
echo "OPTIND: ${OPTIND}"

# remove the option while leaving the remaining arguments
shift "$(( OPTIND - 1 ))"

echo 'After the shift:'
echo "Number of args: ${#}"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

if [[ "${#}" -gt 0 ]]
then
  usage
fi

log 'Generating a password'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# append a special character if requested to do so
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
  log 'selecting a random special character'
  SPECIAL_CHARACTER=$(echo '!@#$%^&*()-+=' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done'
log 'Here is the password:'

# display the password
echo "${PASSWORD}"

exit 0
