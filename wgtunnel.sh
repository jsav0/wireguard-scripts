#!/bin/bash
#
# n0
# File: wgtunnel.sh
# Description: creates a wireguard interface 
# Written: jsavage [20200316]
# a110w

usage() {
echo "
USAGE: ./wgtunnel.sh <interface> <ip>
  Creates a wireguard tunnel <interface> with <ip>

EXAMPLE:
  ./wgtunnel wg0 10.0.0.1 
"
}

VPN_IP="$2"
INTFC="$1"
PRIVATE_KEY_FILE=~/.config/wireguard/$INTFC-privkey

add_tunnel() {
  [ ! -f $PRIVATE_KEY_FILE ] && {
  	[ ! -d ~/.config/wireguard ] && mkdir -p ~/.config/wireguard
	gen_key
  }
  ip link add $INTFC type wireguard 
  ip addr add $VPN_IP dev $INTFC
  wg set $INTFC private-key $PRIVATE_KEY_FILE
  ip link set $INTFC up
  wg show $INTFC

}

# generate private key for interface
gen_key() {
  umask 0777 && wg genkey > $PRIVATE_KEY_FILE
}

[ -z "$1" ] && {
  usage 
} || {
  [[ "$1" == "create" ]] && {
    add_tunnel
  } || { 
    [[ $1 == "remove-peer" ]] && {
      wg set "$2" peer "$3" remove
      wg show
    } || {
      echo "invalid operation"
    }
  }
}



