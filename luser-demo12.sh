#!/bin/bash

# this script deletes a usesr

# run as root
if [[ "${UID}" -ne 0 ]]
then 
  echo 'please run with sudo or root' >&2
  exit
fi

# assume the first argument is the user to delete
USER="${1}"

# delete the user
userdel ${USER}

# make sure the user got deleted
if [[ "${?}" -ne 0 ]]
then
  echo "the account ${USER} was NOT deleted" >&2
  exit 1
fi

# tell the user thie account was deleted
echo "the account ${USER} was deleted"

exit 0
