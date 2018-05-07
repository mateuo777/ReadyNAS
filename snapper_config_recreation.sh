#!/bin/bash

x=0
volumes=$(mount | grep 'subvol=/)' | awk '{print $3}' | sed -r 's/[/]//;/^$/d')

for volume in ${volumes}; do

	shares=$(btrfs subv list /${volume} | sed -r '/.snapshots|home|\./d' | awk '{print $9}')

	for share in ${shares}; do
		snapper -c ${x} create-config /${volume}/${share}
		x=$(($x+1))
	done 
done
