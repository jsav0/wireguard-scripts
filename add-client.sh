#!/bin/bash
# n0
# File: add_client.sh
# Description: generates a config for a wireguard client
# a110w

INTFC=wg0
SERVER_PUBKEY=$(cat ~/.config/wireguard/$INTFC-pubkey)
SERVER_PUBLIC_IP=96.30.192.235

usage() {
  echo "
  USAGE: ./addclient [name]
  Create/add a new client and generate config
  "
}

get_next_ip() {
  [ ! -f last-ip.txt ] && printf "10.0.0.1" > last-ip.txt
  ip="10.0.0."$(expr $(cat last-ip.txt | awk -F'.' '{print $4}') + 1)
  printf "$ip" > last-ip.txt
}

add_peer() {
	sudo wg set $INTFC peer $(cat clients/$NAME/$NAME.pubkey) allowed-ips $ip/32
}

generate_keys() {
	wg genkey | tee clients/$NAME/$NAME.privkey | wg pubkey > clients/$NAME/$NAME.pubkey
	echo "what is going on"
}

create_config() {
	NAME=$1	
	mkdir -p clients/$NAME
	generate_keys || echo "error: could not generate keys"
	key=$(cat clients/$NAME/$NAME.privkey) 
	get_next_ip	
	cat templates/client.conf | sed 's/:CLIENT_IP:/'"$ip"'/;s|:CLIENT_KEY:|'"$key"'|;s|:SERVER_PUB_KEY:|'"$SERVER_PUBKEY"'|;s|:SERVER_ADDRESS:|'"$SERVER_PUBLIC_IP"'|' > clients/$1/$1.conf
	tar czf clients/$NAME.tar.gz clients/$NAME
}

[ $# -eq 0 ] && {
	usage
} || {
	create_config $1 && {
		add_peer && {
			printf "$ip $NAME\n" | sudo tee -a /etc/hosts
		} || {
			echo "error: failed to add peer to wireguard interface"
			exit 1
		}
	} || {
		echo "something went wrong. better check."
		exit 1
	}
}  

