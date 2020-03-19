#!/bin/bash
#
# n0
# File: wgtunnel.sh
# Description: Create wireguard tunnels and add/remove peers 
# Written: jsavage [20200316]
# a110w

usage() {
echo "
USAGE: 
  ./wgtunnel.sh [DOWHAT] [OPTIONS]

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
  ./wgtunnel.sh create <interface> <ip>
  ./wgtunnel.sh add-peer <interface> <peer-pubkey> <ip> <endpoint:port>
  ./wgtunnel.sh remove-peer <interface> <peer-pubkey>

  ./wgtunnel.sh create wg0 10.0.0.1 
  ./wgtunnel.sh add-peer wg0 abcde123= 10.0.0.2/32 example.org:56072
  ./wgtunnel.sh remove-peer wg0 abcde123=
"
}

PRIVATE_KEY_FILE=~/.config/wireguard/$INTFC-privkey

# create new wireguard interface
add_interface() {
  VPN_IP="$2"
  INTFC="$1"
  echo $INTFC
  echo $VPN_IP
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
  wg set $INTFC peer $KEY allowed-ips $VPN_IP endpoint $PUBLIC_IP 
}


[ -z "$1" ] && {
  usage 
} || {
  [[ "$1" == "create" ]] && {
    add_interface "$2" "$3"
  } || { 
    [[ $1 == "remove-peer" ]] && {
      remove_peer "$2" "$3"
    } || {
      [[ $1 == "add-peer" ]] && {
        add_peer "$2" "$3" "$4" "$5"
        } || {
            echo "invalid args provided"
        }
    }
  }
}



