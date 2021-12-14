#!/bin/sh

cd "$(dirname "$0")"

# LOOP THROUGH EACH CONFIG FILE
for filename in /configs/honeywell.d/*.conf; do
	# LOAD CONFIG FILE
	. "$filename"

	echo "Getting honeywell data for $HONEYWELL_EMAIL"

	# LOG INTO HONEYWELL
	curl -s -c /tmp/honeywell_cookie.dat https://mytotalconnectcomfort.com/portal/ -d UserName="$HONEYWELL_EMAIL" -d Password="$HONEYWELL_PASSWORD" -d timeOffset=0 > /dev/null

	# GET HONEYWELL STATUS
	CURRENT_STATUS=`curl -s -b /tmp/honeywell_cookie.dat https://mytotalconnectcomfort.com/portal/Device/CheckDataSession/"$HONEYWELL_DEVICE_ID" -H X-Requested-With:XMLHttpRequest`

	# LOG HONEYWELL TO SPLUNK
	JSON='{"event":'$CURRENT_STATUS'}'
	RESPONSE=$(curl -k https://$SPLUNK_HOSTNAME:$SPLUNK_PORT/services/collector -H 'Authorization: Splunk '$SPLUNK_TOKEN -d "$JSON" 2>&1)
	[[ "$?" -ne "0" ]] && echo -e "${RESPONSE}" && echo "Failed to send data"

	# REMOVE HONEYWELL LOGIN COOKIE
	rm -f /tmp/honeywell_cookie.dat
done
