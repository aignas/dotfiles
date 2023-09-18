#!/bin/bash

if [[ $1 == "local" && -f $2 ]]; then
    cat "$2"
    exit 0
fi

# wait until the password is available
echo "Waiting for credentials for '$*'..." >/tmp/wait-for-creds.log
while ! secret-tool lookup "$1" "$2"; do
    echo "Waiting for credentials for '$*'..." >>/tmp/wait-for-creds.log
    sleep 5
done
