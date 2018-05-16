#!/bin/bash

#Variable definitions:
output=$(cat /proc/partitions | grep -w sd[a-z] | awk '{print $4}' | tr '\n' ' ' | uniq)
output2=$(cat /proc/partitions | grep -w sd[a-z] | awk '{print $4}' | tr '\n' ' ' | uniq | sed -r 's/(.{2}).*/\1/')

#Beginning of the program:
printf "\n\n##########Hello $(whoami), welcome to the smartctl utility!##########\n\n"

#Main loop:
while true; do

	printf "\n\n"
	read -p "Please define the disk label (sda or sdb, etc.) or type exit to quit: " -n 4 -t 10 -e disk

        if [[ $disk == "EXIT" ]] || [[ $disk == "exit" ]]; then
		printf "\n\nGoodbye!\n\n\n"
        break

        elif [[ -z $disk ]]; then
        continue

        elif [[ $disk == "sd" ]] || [[ $disk == "SD" ]] || [[ $disk == "hd" ]] || [[ $disk == "HD" ]]; then 
		printf "\n\nSuch label doesn't exist here, try again\n"
        continue

        elif [[ $output =~ $disk ]] && [[ $disk =~ ^$output2 ]]; then 
		printf "\n\n\n==========/dev/$disk==========\n\n\n\n"
                sudo smartctl --all /dev/$disk | egrep -i 'serial|model|sector|error|hour'
        continue   

        else
		printf "\n\nSuch label doesn't exist here, try again\n"
        continue

        fi
done
