#!/bin/bash
cd ~/FTP
sudo groupadd adminftp
#####récupération liste utilisateurs
cat ftp_Userlist.csv | while read varligne
do
	password=`echo $varligne |cut -d ',' -f4`
	username=`echo $varligne |cut -d ',' -f2`
	username=`echo ${username,,}`
	role=`echo $varligne |cut -d ',' -f5`
	echo $role
	if [ ${role:0:5} = "Admin" ]
	then
		echo "creation de l'utilisateur : $username"
		###### création utilisateur
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		sudo useradd -m -p "$pass" "$username"
		####### changement de groupe
		sudo adduser $username adminftp
		echo "changement du role de : $username"
		sudo usermod -aG sudo $username
		
	else 
		echo "creation de l'utilisateur : $username"
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		sudo useradd -m -p "$pass" "$username"
		#################### création du groupe adminftp 
		
	fi
done < <(tail -n +2 ftp_Userlist.csv)

