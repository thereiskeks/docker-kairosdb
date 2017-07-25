#!/bin/sh

clear
printf "Wait until database $DB_HOST:$DB_PORT_NUMBER is ready "
until nc -z $WAITFOR_HOST 9160
do
	printf "."
    sleep 1
done

exec "/usr/bin/config-kairos.sh"