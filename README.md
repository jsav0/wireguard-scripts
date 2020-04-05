```
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
```
