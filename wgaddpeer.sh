#!/bin/bash
#
# n0
# File: wgaddpeer.sh
# Description: Adds a peer to existing wireguard interface 
# Written: jsavage [20200316]
# a110w


usage() {
echo "
USAGE: ./wgaddpeer.sh <interface> <peer-pubkey> <ip> <endpoint/public-ip:port>
  Adds a peer to existing wireguard interface

EXAMPLE:
  ./wgaddpeer.sh wg0 ABCDE= 10.0.0.2/32 96.30.192.235:56072
"
}

INTFC="$1"
PUBKEY="$2"
VPN_IP="$3"
PUBLIC_IP="$4"

add_peer() {
  wg set $INTFC peer $KEY allowed-ips $VPN_IP endpoint $PUBLIC_IP 
}

[ -z "$1" ] && {
	usage 
  } || {
	echo $INTFC
	echo $PUBKEY
	echo $VPN_IP
	echo $PUBLIC_IP
	#add_peer
}



