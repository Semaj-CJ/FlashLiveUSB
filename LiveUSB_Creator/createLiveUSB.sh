#!/bin/bash

# Written by Semaj-CJ

# Creates LiveUSB on the device
create_live (){

# Displays all connected drives/partitions before connecting the USB
echo If the device you would like to create a LiveUSB is plugged in, unplug it and press enter:
read -s
sudo fdisk -l> fdisk1
echo

# Displays all connected drives/partitions after connecting the USB and compares them
echo Please connect your device and press enter:
read -s
sudo fdisk -l> fdisk2
echo
diff fdisk1 fdisk2

# Stores the path for the drive into a variable
	echo Input the path for the desired drive:
	read -e DRIVE 
	echo

# Shows the user all available ISO options
	echo Here is a list of available ISOs:
	ls | grep *.iso
	echo

# Stores the name of the iso file in a variable
	echo Input the path of the ISO:
	read -e ISONAME 
	echo

	sudo dd if=$ISONAME of=$DRIVE bs=512k
}

# Creates Persistence on the device
live_persistence (){

# Finds the path of the new partion
	sudo fdisk -l>fdisk3
	diff fdisk1 fdisk3
	echo Input the path for the persistence drive:
	read -e PDRIVE

# Creates first partition size of 7gb
	end=$DRIVE_SIZEgb
	read start _ < <(du -bcm $ISONAME | tail -1); echo $start 
	sudo parted $DRIVE mkpart primary $start $end

# Creates an ext3 file system within the partition
	sudo mkfs.ext3 -L persistence $PDRIVE
	sudo e2label $PDRIVE persistence

# Mounts new partition and creates persistence.conf within
	sudo mkdir -p /mnt/my_usb
	sudo mount $PDRIVE /mnt/my_usb
	sudo echo "/ union">/mnt/my_usb/persistence.conf
	sudo umount $PDRIVE 
}

echo How big is the drive?
read -e DRIVE_SIZE
DRIVE_SIZE=$( expr $DRIVE_SIZE - 15 )
if [ $DRIVE_SIZE -lt 0 ]; then
        DRIVE_SIZE=$( expr -1 \* $DRIVE_SIZE )
fi

echo Would you like the LiveUSB to have persistence? (y/n)
read -e RE1
echo Would you like the LiveUSB to be encrypted? (y/n)
read -e RE2

create_live

if [ $RE1 = 'y' ]; then
	live_persistence
fi

if [ $RE2 = 'y']; then
	echo This feature is not yet available. Get to work!
fi
