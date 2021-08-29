#!/bin/bash

# This script will create a new local user and redirect errors to STDERR
# suppress output from all other commands

# enforce the script can only be executed with root privileges. if not root, exit 1 and display error msg on STDERR
if [[ "${UID}" -ne 0 ]]
then 
  echo 'use root account' >&2 
  exit 1
fi

# provide a usage statement if there is no account name, and exit 1. send error msg to STDERR
if [[ "${#}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [COMMENT]" >&2
  exit 1
fi

# use first arg as username. remaining arg as comment
USER_NAME="${1}"

shift
COMMENT="${@}"

# auto generate password
PASSWORD=$(date +%s%N | sha256sum | head -c24)

# create an account and redirect all output to /dev/null, so output won't be displayed
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# inform user if create account failed. exit 1. send error msg to STDERR
if [[ "${?}" -ne 0 ]]
then
  echo 'failed to create account' >&2
  exit 1
fi

# set the password and redirect all output to /dev/null
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# check if the passwd command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo 'failed to set password' >&2
  exit 1
fi

# force to change password after first login
passwd -e ${USER_NAME} &> /dev/null

# display username, password, and host
echo "username: ${USER_NAME}"
echo "password: ${PASSWORD}"
echo "hostname: ${HOSTNAME}"
exit 0

