#!/bin/bash

# this script creates an account on the local system
# you will be prompted for the account namd and password

# ask for the username
read -p 'enter the username to create: ' USER_NAME

# ask for the real name
read -p 'enter your full name: ' COMMENT

# ask for the password
read -p 'enter password: ' PASSWORD

# create the user
useradd -c "${COMMENT}" -m ${USER_NAME}

# set the password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# force password change on first login
passwd -e ${USER-NAME}

