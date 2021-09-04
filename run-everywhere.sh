#!/bin/bash
# This script executes a given command on multiple servers

# Make sure the SERVER_LIST file exists.
SERVER_LIST='/vagrant/servers'

# Options for the ssh command.
SSH_OPTIONS='-o ConnectTimeout=2'

# Display the usage and exit.
usage() {
  echo "Usage: $0 [-nsv] [-f FILE] COMMAND" >&2
  echo "  -f FILE  Use FILE for the list of servers. Default: $SERVER_LIST" >&2
  echo "  -n       Dry run mode.  Display the COMMAND that would have been executed and exit." >&2
  echo "  -s       Execute the COMMAND using sudo on the remote server." >&2
  echo "  -v       Verbose mode. Displays the server name before executing COMMAND." >&2
  exit 1
}

# Make sure the script is not being executed with superuser privileges.
if [[ $UID -eq 0 ]]; then
  echo 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi

# Parse the options.
# f requires an argument, so we need to put a : after it.
while getopts f:nsv opt; do
  case ${opt} in
  f) SERVER_LIST="${OPTARG}" ;;
  n) DRY_RUN='true' ;;
  s) SUDO_MODE='sudo' ;;
  v) VERBOSE='true' ;;
  ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments.
shift "$((OPTIND - 1))"

# If the user doesn't supply at least one argument, give them help.
if [[ $# -lt 1 ]]; then
  usage
fi

# Anything that remains on the command line is to be treated as a single command.
COMMAND="${@}"

# Make sure the SERVER_LIST file exists.
if [[ ! -e $SERVER_LIST ]]; then
  echo "Cannot open $SERVER_LIST" >&2
  exit 1
fi

# Expect the best, prepare for the worst.
EXIT_STATUS='0'

# Loop through the SERVER_LIST
for SERVER in $(cat $SERVER_LIST); do
  # Display the server name
  if [[ $VERBOSE = 'true' ]]; then
    echo "==> $SERVER"
  fi

  SSH_COMMAND="ssh $SSH_OPTIONS $SERVER $SUDO_MODE $COMMAND"

  # If it's a dry run, don't execute anything, just echo it.
  if [[ $DRY_RUN = 'true' ]]; then
    echo "DRY RUN: $SSH_COMMAND"
  else
    # Otherwise, execute the command.
    ${SSH_COMMAND}
    SSH_EXIT_STATUS=$?

    # Capture any errors.
    if [[ $SSH_EXIT_STATUS -ne '0' ]]; then
      EXIT_STATUS=$SSH_EXIT_STATUS
      echo "Execution on $SERVER failed" >&2
    fi
  fi
done

exit $EXIT_STATUS
