#!/bin/sh

# CONVERT 1PASSWORD ENVIRONMENT VARIABLES
if env | grep -E '^[^=]*=OP:' >/dev/null; then
	curl -s -o /tmp/1password-vars.sh "https://raw.githubusercontent.com/JtMotoX/1password-docker/main/1password/op-vars.sh"
	chmod 755 /tmp/1password-vars.sh
	. /tmp/1password-vars.sh
	rm -f /tmp/1password-vars.sh
fi

touch /var/log/honeywell-logger/honeywell-logger.log
tail -f -n0 /var/log/honeywell-logger/honeywell-logger.log &

touch /tmp/crond.log
tail -f /tmp/crond.log &

crond -f -l 8 -L /tmp/crond.log
