#!/bin/bash

volumes=$(mount | grep 'subvol=/)' | awk '{print $3}' | sed -r 's/[/]//;/^$/d')
shares=$(btrfs subv list /${volume} | sed -r '/.snapshots|home|\./d' | awk '{print $9}')

for volume in ${volumes}; do

	for share in ${shares}; do

		for snap_number in $(rn_nml -Q snapshot:/${volume}/${share} | grep 'Snapshot_Name' | cut -d '>' -f2 | cut -d '<' -f1); do 

			for type in {1..2}; do	

				rn_nml -d snapshot:/${volume}/${share}@${snap_number}:${type}
			       	sleep 10
		       	done
	       	done
       	done
done
