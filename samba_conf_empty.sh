#!/bin/bash

#Collecting list of volumes and shares:

for volume in = $(mount | grep 'subvol=/)' | awk '{print $3}' | sed -r 's/[/]//;/^$/d' 2>/dev/null) 

do 
	for share in $(btrfs subv list /${volume} | sed -r '/.snapshots|home|\./d' | awk '{print $9}' 2>/dev/null) 

	do 
		echo -n "File /${volume}/._share/${share}/samba.conf: " 2>/dev/null 
	
	if [[ -f "/${volume}/._share/${share}/iscsi.conf" ]]; then 
	
		echo "this is iscsi LUN, ignoring..." 2>/dev/null 
	
	elif [[ -s "/${volume}/._share/${share}/samba.conf" ]]; then 
	
		echo "already good, no action required." 2>/dev/null 
	
	else cat > /${volume}/._share/${share}/samba.conf << EOF
[$share]
 path = /$volume/$share
 comment = "$share folder"
 spotlight = 0
 guest ok = 1
 admin users = +admin
 writeable = 1
 follow symlinks = 1
EOF

	     echo "corrupted, fixed." 
	fi 
        done 

done

echo "Updating Shares.conf now..." 

for volume in $(mount | grep 'subvol=/)' | awk '{print $3}' | sed -r 's/[/]//;/^$/d') 
do 
	for share in $(btrfs subv list /${volume} | sed -r '/.snapshots|home|\./d' | awk '{print $9}')
       	do 
		cat /${volume}/._share/${share}/samba.conf >> /etc/frontview/samba/Shares.conf >/dev/null 2>&1 
	done 
done
