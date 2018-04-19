#!/bin/bash

x=0
for volume in $(mount | grep 'subvol=/)' | awk '{print $3}' | sed -r 's/[/]//;/^$/d')
do       	
	for share in $(btrfs subv list /${volume} | sed -r '/.snapshots|home|\./d' | awk '{print $9}') 
	do 
		snapper -c ${x} create-config /${volume}/${share}
		x=$(($x+1))
	done 
done
