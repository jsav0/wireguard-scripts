# wireguard-scripts
basic wireguard configuration made even easier

** WIP / not finished **

### wgtunnel.sh - Create a wireguard interface
```
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
```

