#!/bin/bash

# This script creates a new user on the local system.

# enforce the script to be executed with superuser. if not, returns an exit status of 1
if [[ "${UID}" -ne 0 ]]
then
  echo "your UID is ${UID}, you are not root user, exit now. please run with sudo or as root."
  exit 1
fi

# prompt user to enter login username
read -p 'enter your username: ' USER_NAME

# prompt user to enter full name (content for the description field)
read -p 'enter your full name: ' COMMENT

# prompt user to enter password
read -p 'enter your password: ' PASSWORD

# creates a new user on the local system with the inputs
# -m create home dir if it doesn't exits.
useradd -c "${COMMENT}" -m ${USER_NAME}

# inform user if account creation failed and exit 1
# we do not want to tell the user that an account was created when it has not been
if [[ "${?}" -ne 0 ]]
then
  echo "something went wrong, failed to create account, exit now"
  exit 1
fi

# set password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# check status
if [[ "${?}" -ne 0 ]]
then
  echo "something went wrong, failed to create account, exit now"
  exit 1
fi

#  force password change on first login
passwd -e ${USER_NAME}

# display username, password, and host where the account was created
echo "your username is ${USER_NAME}, 
your full name is ${COMMENT},
your password is ${PASSWORD},
your hostname is ${HOSTNAME}"
exit 0
