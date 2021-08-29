#!/bin/bash

# This script creates a local user and auto generate password for the account.

# only root user can execute this script. if not using root, exit with status 1
if [[ "${UID}" -ne 0 ]]
then 
  echo 'use root user account to execute this script'
  exit 1
fi

# ask for an account name. need to have at least 1 argument, if not, return exit status 1
NUM_OF_PARAM="${#}"

if [[ "${NUM_OF_PARAM}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [COMMENT]"
  exit 1
fi

# use first argument as the username, anything after first arg will be treated as comment
USER_NAME="${1}"

# the rest of the parameters are for the account comments
shift
COMMENT="${@}"

# auto generate a password for the new account
PASSWORD=$(date +%s%N | sha256sum | head -c24)

# create the user with the password
useradd -c "${COMMENT}" -m ${USER_NAME}

# if create account failed, inform the user and return exit status 1
if [[ "${?}" -ne 0 ]]
then
  echo 'failed to creat account'
  exit 1
fi

# set the password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# check if the passwd command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo 'failed to set password'
  exit 1
fi

# force password change on first login
passwd -e ${USER_NAME}


# display username, password, and hostname where the account was created. 
echo
echo "username: ${USER_NAME}"
echo "password: ${PASSWORD}"
echo "hostname: ${HOSTNAME}"
