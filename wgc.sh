#!/bin/bash
#
# n0
# File: wgc.sh
# Description: Create wireguard tunnels and add/remove peers 
# Written: jsavage [20200316]
# a110w

usage() {
echo "
USAGE: 
  ./wgc.sh [DOWHAT] [OPTIONS]

DOWHAT:
  create            create wireguard interface
  add-peer          add peer to wireguard interface
  remove-peer       remove peer from wireguard interface

OPTIONS:
  <interface>       wireguard interface
  <peer-pubkey>     peer public key
  <peer-ip>         peer allowed-ip
  <endpoint:port>   peer public IP:PORT

EXAMPLES:
  ./wgc.sh create <interface> <ip>
  ./wgc.sh add-peer <interface> <peer-pubkey> <ip> <endpoint:port>
  ./wgc.sh remove-peer <interface> <peer-pubkey>

  ./wgc.sh create wg0 10.0.0.1 
  ./wgc.sh add-peer wg0 abcde123= 10.0.0.2/32 example.org:56072
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
  	gen_key
  }
  ip link add $INTFC type wireguard 
  ip addr add $VPN_IP dev $INTFC
  wg set $INTFC private-key $SERVER_PRIVKEY
  ip link set $INTFC up
  wg show $INTFC
}

# generate keys for interface
gen_key() {
  umask 0777 && wg genkey | tee $SERVER_PRIVKEY | wg pubkey > $SERVER_PUBKEY
}

# remove peer from interface
remove_peer() {
  wg set "$1" peer "$2" remove
  wg show
}

# add peer to interface
add_peer() {
  INTFC="$1"
  PUBKEY="$2"
  VPN_IP="$3"
  PUBLIC_IP="$4"
  wg set $INTFC peer $PUBKEY allowed-ips $VPN_IP endpoint $PUBLIC_IP
}

case "$1" in 
    create)         add_interface "$2" "$3"
                    ;;
    add-peer)       add_peer "$2" "$3" "$4" "$5"
                    ;;
    remove-peer)    remove_peer "$2" "$3"
                    ;;
    *)              usage
                    ;;
esac


