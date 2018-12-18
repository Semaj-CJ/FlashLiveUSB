#!/bin/bash

set -xe

echo How big is the drive?
read -e DRIVE_SIZE
DRIVE_SIZE=$( expr $DRIVE_SIZE - 15 )
if [ $DRIVE_SIZE -lt 0 ]; then
	DRIVE_SIZE=$( expr -1 \* $DRIVE_SIZE )
fi

echo $DRIVE_SIZE
