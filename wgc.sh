#!/bin/bash
#
# n0
# File: wgc.sh
# Description: Create wireguard tunnels and add/remove peers 
# Written: jsavage [20200316]
# a110w

SERVER_PUBLIC_IP="example.com"

usage() {
echo "WireGuardConfigure:
USAGE: 
  ./wgc.sh [DOWHAT] [OPTIONS]

DOWHAT:
  create	create wireguard interface
  add-peer	create/add peer and generate client config
  remove-peer	remove peer from wireguard interface

OPTIONS:
  <interface>	wireguard interface
  <ip>		new wireguard tunnel address
  <peer-name>	alias for new client/peer

  EXAMPLES:
  ./wgc.sh create <interface> <ip>
  ./wgc.sh add-peer <interface> <peer-name>
  ./wgc.sh remove-peer <interface> <peer-pubkey>

  ./wgc.sh create wg0 10.0.0.1 
  ./wgc.sh add-peer wg0 thinkpadx220
  ./wgc.sh remove-peer wg0 abcde123=
"
}

# create new wireguard interface
add_interface() {
  VPN_IP="$2"
  INTFC="$1"
  SERVER_PRIVKEY=~/.config/wireguard/$INTFC-privkey
  SERVER_PUBKEY=~/.config/wireguard/$INTFC-pubkey
  [ ! -f $SERVER_PRIVKEY ] && {
	mkdir -p ~/.config/wireguard
  	gen_server_keys
  }
  ip link add $INTFC type wireguard 
  ip addr add $VPN_IP dev $INTFC
  wg set $INTFC private-key $SERVER_PRIVKEY
  ip link set $INTFC up
  wg show $INTFC
}

# generate keys for interface
gen_server_keys() {
  umask 0777 && wg genkey | tee $SERVER_PRIVKEY | wg pubkey > $SERVER_PUBKEY
}

# remove peer from interface
remove_peer() {
  wg set "$1" peer "$2" remove
  wg show
}

#INTFC=$2
#SERVER_PUBKEY=$(cat ~/.config/wireguard/$INTFC-pubkey)
#echo $INTFC
#echo $SERVER_PUBKEY
get_next_ip() {
  [ ! -f last-ip.txt ] && printf "10.0.0.1" > last-ip.txt
  ip="10.0.0."$(expr $(cat last-ip.txt | awk -F'.' '{print $4}') + 1)
  printf "$ip" > last-ip.txt
}

add_client_peer() {
	INTFC=$1
	NAME=$2
	sudo wg set $INTFC peer $(cat clients/$NAME/$NAME.pubkey) allowed-ips $ip/32
#	printf "$ip $NAME\n" | sudo tee -a /etc/hosts
}

generate_client_keys() {
	NAME="$1"
	wg genkey | tee clients/$NAME/$NAME.privkey | wg pubkey > clients/$NAME/$NAME.pubkey
	echo "what is going on"
}

create_client_config() {
	NAME="$1"	
	mkdir -p clients/$NAME
	generate_client_keys $NAME || echo "error: could not generate keys"
	key=$(cat clients/$NAME/$NAME.privkey) 
	get_next_ip	
	cat templates/client.conf | sed 's/:CLIENT_IP:/'"$ip"'/;s|:CLIENT_KEY:|'"$key"'|;s|:SERVER_PUB_KEY:|'"$SERVER_PUBKEY"'|;s|:SERVER_ADDRESS:|'"$SERVER_PUBLIC_IP"'|' > clients/$1/$1.conf
	tar czf clients/$NAME.tar.gz clients/$NAME
}

case "$1" in 
    create)         add_interface "$2" "$3"
                    ;;
    add-peer)		create_client_config "$3" && {
						add_client_peer "$2" "$3"  && {
							printf "$ip $NAME\n" | sudo tee -a /etc/hosts
						} || {
							echo "error: failed to add peer to wireguard interface"
							exit 1
						}
					}
					;;
    remove-peer)    remove_peer "$2" "$3"
                    ;;
    *)              usage
                    ;;
esac


