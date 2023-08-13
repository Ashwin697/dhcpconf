#!/bin/bash

read -p "Enter Subnet ip : " subnet_ip
read -p "Enter Netmask ip : " netmask_ip
read -p "Enter Starting ip : " starting_ip
read -p "Enter Ending ip : " ending_ip
read -p "Enter Gateway ip : " gateway_ip
nameserver1="8.8.8.8"
nameserver2="1.1.1.1"

dhcpconf(){

if dpkg -l | grep -q isc-dhcp-server; then
read -p "Please enter the device mac address: " mac_address
read -p "please enter the ip address(between $starting_ip - $ending_ip) which you want to bind it with mac address $mac_address : " ip_address

hostname_pc="saticip"

dhcpconf="default-lease-time 600;\nmax-lease-time 7200;\nddns-update-style none;\nauthoritative;\n\nsubnet $subnet_ip netmask $netmask_ip \n{\n\trange $starting_ip $ending_ip;\n\toption routers $gateway_ip;\n\toption domain-name-servers $nameserver1, $nameserver2;\n\n}\n\nhost $hostname_pc {\n\thardware ethernet $mac_address;\n\tfixed-address $ip_address;\n}"

cp -f /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
echo -e "$dhcpconf" > /etc/dhcp/dhcpd.conf

systemctl restart isc-dhcp-server
else
	
	echo -e "\e[31m DHCP Service is not installed on this system\e[0m"
fi
}

if dpkg -l | grep -q isc-dhcp-server; then
	dhcpconf

else
	echo -e "\e[31m DHCP Service is not installed on this system\e[0m"
	sudo apt install isc-dhcp-server
	dhcpconf
	exit 0

fi

