#!/bin/bash -xv

# this script demo function - log

log() {
  local VERBOSE="${1}"
  shift
  # local command can only be used inside a function
  # best practice to use local
  local MESSAGE="${@}"

  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}

function log1 {
  echo 'this will do too'
}

log2() {
  # this function sends a message to syslog and to standard output if HELLO is true
  local MESSAGE="${@}"
  if [[ "${HELLO}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi

  # log MESSAGE to system log with tag: luser-demo10.sh
  logger -t luser-demo10.sh "${MESSAGE}"
}

backup_file() {
  # this function creates a backup of a file. returns non-zero status on error.
  local FILE="${1}"

  # make sure the file exists
  if [[ -f "${FILE}" ]]
  then
    # files in /var/tmp are not guaranteed to survive a reboot.
    # %F represents full date (year, month, date)
    # %N represents nano seconds
    local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
    log "backing up ${FILE} to ${BACKUP_FILE}"

    # the exit status of the function will be the exit status of the cp command
    # -p short for preserve - it preserves ownership, mode, and timestamp
    # if -p is not used, the copied file will have the current timestamp
    cp -p ${FILE} ${BACKUP_FILE}
  else
    # the file does not exist, so return a non-zero exit status
    return 1 
  fi
}

# place the name of function to execute it
VERBOSITY='true'
log ${VERBOSITY} 'hello!'
log ${VERBOSITY} 'hello world!'

log1

# readonly represents constant variable, cannot be changed
readonly HELLO='true'
log2 'hello!'
log2 'this is fun!'

backup_file '/etc/passwd'
