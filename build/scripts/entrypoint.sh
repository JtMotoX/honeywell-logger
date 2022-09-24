#!/bin/sh

set -e

# CONVERT 1PASSWORD ENVIRONMENT VARIABLES
if env | grep -E '^[^=]*=OP:' >/dev/null; then
	curl -sS -o /tmp/1password-vars.sh "https://raw.githubusercontent.com/JtMotoX/1password-docker/main/1password/op-vars.sh"
	chmod 755 /tmp/1password-vars.sh
	. /tmp/1password-vars.sh || exit 1
	rm -f /tmp/1password-vars.sh
fi

if [ "$1" = "run" ]; then
	# MAKE SURE WE HAVE ACCESS TO LOGS
	LOG_FILE="/var/log/honeywell-logger/honeywell-logger.log"
	touch "${LOG_FILE}" 2>/dev/null || true
	if [ ! -w ${LOG_FILE} ]; then
		echo "ERROR: Getting access denied to log files."
		echo "NOTE: 'chmod -R 777 logs'"
		exit 1
	fi
	tail -f -n0 "${LOG_FILE}" &

	# MAKE SURE WE HAVE ACCESS TO CONFIGS
	if ! cat /configs/honeywell.d/*.conf >/dev/null 2>&1; then
		echo "ERROR: Getting access denied to honeywell.d config files"
		echo "Either you did not create a conf file within your honeywell.d directory, or you need to set the correct file permissions ('chmod -R 777 configs')"
		echo "NOTE: 'chmod -R 755 configs && find configs -type f -exec chmod 644 {} \;"
		exit 1
	fi

	touch /tmp/crond.log
	tail -f /tmp/crond.log &

	supercronic ~/crontab >/tmp/crond.log 2>&1
	exit 1
fi

exec "$@"
