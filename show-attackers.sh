#!/bin/bash

# count the number of failed logins by IP address
# if there are any IPs with more than 10 failed logins, display the count, IP, abd location.
LIMIT='10'

# use provided syslog-sample as input
LOG_FILE=$1

# make sure a file was supplied as an argument
if [[ ! -e $LOG_FILE ]]; then
  echo "File $LOG_FILE does not exist" >&2
  exit 1
fi

# display the CSV header
echo 'Count,IP,Location'

# loop through the list of failed attempts and corresponding IPs
grep Failed $LOG_FILE | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP; do

# if the number of failed attemps is greater than the limit, display the count, IP, and location
if [[ $COUNT -gt $LIMIT ]]; then
  LOCATION=$(geoiplookup $IP | awk -F ',' '{print $2}')
  echo "$COUNT, $IP, $LOCATION"
fi
done
exit 0
