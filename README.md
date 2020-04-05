```
WireGuardConfigure:
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

```
