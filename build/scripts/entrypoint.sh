#!/bin/sh

touch /var/log/honeywell-logger/honeywell-logger.log
tail -f -n0 /var/log/honeywell-logger/honeywell-logger.log &

touch /tmp/crond.log
tail -f /tmp/crond.log &

crond -f -l 8 -L /tmp/crond.log
