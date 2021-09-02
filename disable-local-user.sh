#!/bin/bash

# This script delete (or disable), remove home directory, create an archive of the home directory in the /archives directory.
readonly ARCHIVE_DIR='/archive'

usage() {
  # display the usage and exit
  echo "Usage: $0 [-dra] USER [USERN]..." >&2
  echo '  -d Deletes accounts' >&2
  echo '  -r Removes the home directory associated with the account(s)' >&2
  echo '  -a Creates an archive of the home directory associated with the account(s)' >&2
  exit 1
}

checkExitCode() {
  local MESSAGE="$@"
  # check the exit code of the last command
  if [ $? -ne 0 ]; then
    echo "An error occurred with the last command: $MESSAGE" >&2
    exit 1
  fi
}

# enforce the script is only executed with root user
if [[ $UID -ne 0 ]]; then
  echo 'Please use root user' >&2
  exit 1
fi

# parse the options
while getopts dra OPTION; do
  case $OPTION in
  d) DELETE_USER='true' ;;
  r) REMOVE_OPTION='-r' ;;
  a) ARCHIVE='true' ;;
  ?) usage ;;
  esac
done

# remove the options while leaving the remaining arguments.
shift "$((OPTIND - 1))"

# user need to supply at least 1 argument
if [[ $# -lt 1 ]]; then
  usage
fi

# loop through all the usernames supplied as arugments
for USER_NAME in $@; do
  echo "Processing user: $USER_NAME"

  # make sure the UID of the account is at least 1000
  USER_ID=$(id -u $USER_NAME)

  if [[ $USER_ID -lt 1000 ]]; then
    echo "you are not allowed to remove the $USER_NAME account with UID $USER_ID" >&2
    exit
  fi

  # create an archive if requested to do so
  if [[ $ARCHIVE = 'true' ]]; then
    # make sure the ARCHIVE_DIR directory exits
    if [[ ! -d $ARCHIVE_DIR ]]; then
      echo "Creating $ARCHIVE_DIR directory"
      mkdir -p $ARCHIVE_DIR
      checkExitCode "Failed to create $ARCHIVE_DIR directory"
    fi

    # archive the user's home dir and move it into the ARCHI_DIR
    HOME_DIR="/home/$USER_NAME"
    ARCHIVE_FILE="$ARCHIVE_DIR/$USER_NAME.tgz"

    if [[ -d $HOME_DIR ]]; then
      echo "Archiving $HOME_DIR to $ARCHIVE_FILE"
      tar -zcf $ARCHIVE_FILE $HOME_DIR &>/dev/null
      checkExitCode "Failed to archive $HOME_DIR to $ARCHIVE_FILE"
    else
      echo "$HOME_DIR does not exist or is not a directory" >&2
      exit 1
    fi
  fi

  if [[ $DELETE_USER = 'true' ]]; then
    # delete the user
    userdel $REMOVE_OPTION $USER_NAME

    # check to see if the userdel command succeeded
    if [[ $? -ne 0 ]]; then
      echo "The account $USER_NAME was NOT delete" >&2
      exit 1
    fi
    echo "The account $USER_NAME was deleted"
  else
    chage -E 0 $USER_NAME
    checkExitCode "Failed to disable $USER_NAME account"
    echo "The account $USER_NAME was disabled"
  fi
done

exit 0
