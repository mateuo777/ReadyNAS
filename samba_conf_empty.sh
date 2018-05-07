#!/bin/bash

#Collecting list of volumes and shares:

volumes=$(mount | grep 'subvol=/)' | awk '{print $3}' | sed -r 's/[/]//;/^$/d')

for volume in ${volumes}; do 
	
	shares=$(btrfs subv list /${volume} | sed -r '/.snapshots|home|\./d' | awk '{print $9}') 

	for share in ${shares}; do

		echo -n "File /${volume}/._share/${share}/samba.conf: " 2>/dev/null 2>&1
	
                if [[ -f "/${volume}/._share/${share}/iscsi.conf" ]]; then 
			echo "this is iscsi LUN, ignoring..." 2>/dev/null 2>&1
	
                elif [[ -s "/${volume}/._share/${share}/samba.conf" ]]; then 
			echo "already good, no action required." 2>/dev/null 2>&1
	
                else cat > /${volume}/._share/${share}/samba.conf << EOF
[${share}]
 path = /${volume}/${share}
 comment = "${share} folder"
 spotlight = 0
 guest ok = 1
 admin users = +admin
 writeable = 1
 follow symlinks = 1
EOF

                        echo "corrupted, fixed."
                        echo "Updating Shares.conf now..."
		        cat /${volume}/._share/${share}/samba.conf >> /etc/frontview/samba/Shares.conf
		fi	
	done	
done  
