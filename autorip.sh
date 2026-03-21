#!/bin/bash

DRIVE=$(ls /dev/sr* 2>/dev/null | head -n1)

start() {
    local OUTDIR="$HOME/rip/$(date +%s)"
    echo "Rip starting!"
    mkdir -p "$OUTDIR"
    OUTPUTDIR="$OUTDIR" abcde -o flac -N -d "$DRIVE"
    echo "rip done!"
}


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
            sleep 2
            start &
        else
            echo "Disc removed from $DRIVE"
        fi
        LAST_STATE="$STATE"
    fi

    sleep 2
done
