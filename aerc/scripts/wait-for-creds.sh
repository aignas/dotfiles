#!/bin/bash

if [[ "$1" == "local" && -f $2 ]]; then
    cat "$2"
    exit 0
fi

secret-tool lookup "$1" "$2"
# wait until the password is available
while [ $? != 0 ]; do
    secret-tool lookup "$1" "$2"
done
