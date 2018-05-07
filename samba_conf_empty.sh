#!/bin/bash

#Collecting list of volumes and shares:

volume=$(mount | grep 'subvol=/)' | awk '{print $3}' | sed -r 's/[/]//;/^$/d')
share=$(btrfs subv list /${volume} | sed -r '/.snapshots|home|\./d' | awk '{print $9}') 

for i in ${volume}; do
	for j in ${share}; do
		echo -n "File /${i}/._share/${j}/samba.conf: " 2>/dev/null 2>&1
	
                if [[ -f "/${i}/._share/${j}/iscsi.conf" ]]; then 
			echo "this is iscsi LUN, ignoring..." 2>/dev/null 2>&1
	
                elif [[ -s "/${i}/._share/${j}/samba.conf" ]]; then 
			echo "already good, no action required." 2>/dev/null 2>&1
	
                else cat > /${i}/._share/${j}/samba.conf << EOF
[${j}]
 path = /${i}/${j}
 comment = "${j} folder"
 spotlight = 0
 guest ok = 1
 admin users = +admin
 writeable = 1
 follow symlinks = 1
EOF

                        echo "corrupted, fixed."
                        echo "Updating Shares.conf now..."
		        cat /${i}/._share/${j}/samba.conf >> /etc/frontview/samba/Shares.conf
		fi	
	done	
done  


