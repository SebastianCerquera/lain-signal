#!/bin/bash

SIGNAL_USERNAME=$1
SIGNAL_CLI="signal-cli"

COMMAND=$(head -n 1 $COMMAND_CONF)

if [ $COMMAND == "register" ]; then
    $SIGNAL_CLI -u $SIGNAL_USERNAME register
elif [ $COMMAND == "verify" ]; then
    CODE=$(cat $COMMAND_CONF | perl -ne 'print $_ if($. == 2)')
    $SIGNAL_CLI -u $SIGNAL_USERNAME verify $CODE
elif [ $COMMAND == "receive" ]; then
    [ -d /small/SMALL/SIGNAL ] || mkdir /small/SMALL/SIGNAL
    COUNTER=0
    while sleep 60; do
        COUNTER=$((($COUNTER + 1)))
        $SIGNAL_CLI -u $SIGNAL_USERNAME receive > $COUNTER
        cat $COUNTER | perl /usr/bin/cli.pl >> /small/SMALL/SIGNAL.org
    done
elif [ $COMMAND == "bash" ]; then
    exec "$@"
else
    echo "Unknown option"
fi
