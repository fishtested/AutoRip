#!/bin/bash

DRIVE=$(ls /dev/sr* 2>/dev/null | head -n1)

if [ -z "$DRIVE" ]; then
    echo "No optical drives found."
    exit 1
fi

echo "Watching $DRIVE..."
LAST_STATE="unknown"


while true; do
    if cd-info "$DRIVE" >/tmp/cdinfo 2>&1; then
        STATE="inserted"
    else
        STATE="empty"
    fi

    if [[ "$STATE" != "$LAST_STATE" ]]; then
        if [[ "$STATE" == "inserted" ]]; then
            echo "Disc inserted in $DRIVE"
        else
            echo "Disc removed from $DRIVE"
        fi
        LAST_STATE="$STATE"
    fi

    sleep 2
done
