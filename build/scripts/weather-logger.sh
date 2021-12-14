#!/bin/sh

cd "$(dirname "$0")"

# LOOP THROUGH EACH CONFIG FILE
for filename in /configs/weather.d/*.conf; do
	# LOAD CONFIG FILE
	. "$filename"

	echo "Getting weather data for "$(basename "$filename" | cut -d. -f1)

	# GET CURRENT WEATHER
	CURRENT_WEATHER=`curl -s "http://api.openweathermap.org/data/2.5/weather?lat=$LAT&lon=$LON&appid=$WEATHER_API_KEY"`

	# LOG WEATHER TO SPLUNK
	JSON='{"event":'$CURRENT_WEATHER'}'
	curl -s -k https://$SPLUNK_HOSTNAME:8088/services/collector -H 'Authorization: Splunk '$SPLUNK_TOKEN -d "$JSON"
	echo
done
