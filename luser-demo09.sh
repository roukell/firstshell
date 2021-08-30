#!/bin/bash

# this script demo the case statement

# below example uses if statement (not recommended)

#if [[ "${1}" = 'start' ]]
#then
#  echo 'starting'
#elif [[ "${1}" = 'stop' ]]
#then
#  echo 'stop'
#elif [[ "${1}" = 'status' ]]
#then
#  echo 'status:'
#else
#  echo 'supply a valid option' >&2
#  exit 1
#fi

# case statement
# script executes from top to bottom
case "${1}" in

# indent by 2 spaces
  start)
    echo 'starting'
    ;;
  stop)
    echo 'stoping'
    ;;

# | pipe is 'or' here
  status|state|--status|--state)
    echo 'status'
    ;;
  *)
    echo 'supply a valid option' >&2
    exit 1
    ;;
esac

# pattern and command can be written in one line if short enough
case "${1}" in
  start) echo 'starting' ;;
esac
