```
WireGuardConfigure:
USAGE: 
  ./wgc.sh [DOWHAT] [OPTIONS]

DOWHAT:
  create	create wireguard tunnel interface (server)
  add-peer	create/add peer and generate client config
  remove-peer	remove peer from wireguard interface

OPTIONS:
  <interface>	wireguard interface
  <peer-name>	alias for new client/peer

  EXAMPLES:
  ./wgc.sh create <interface>
  ./wgc.sh add-peer <interface> <peer-name>
  ./wgc.sh remove-peer <interface> <peer-pubkey>

  ./wgc.sh create wg0
  ./wgc.sh add-peer wg0 thinkpad-client1
  ./wgc.sh remove-peer wg0 abcde123=
```

This script was heavily influenced by the following:
- <https://github.com/davidgross/wireguard-scripts>
- <https://www.wireguard.com/quickstart/>
- <https://www.wireguard.com/install/>
