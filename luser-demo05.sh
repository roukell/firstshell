#!/bin/bash

# This script generates a list of random passwords.

# a random num as a password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# three random numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# use the current date/time as the basis for the password
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# use nanoseconds to act as randomization
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# create a better password
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}"

# create a even better password
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "${PASSWORD}"

# append a sepcial char to the password
SPECIAL_CHAR=$(echo '!@#$%^&*()_=+' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHAR}"

