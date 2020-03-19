# wireguard-scripts
basic wireguard configurations made even easier

### wgtunnel.sh - Create a wireguard interface
```
USAGE: ./wgtunnel <interface> <ip>
  Creates a wireguard tunnel <interface> with <ip>

EXAMPLE:
  ./wgtunnel wg0 10.0.0.1

```

### wgaddpeer.sh - Add a peer to existing wireguard interface 
```
USAGE: ./wgaddpeer.sh <interface> <peer-pubkey> <ip> <endpoint/public-ip:port>
  Adds a peer to existing wireguard interface

EXAMPLE:
  ./wgaddpeer.sh wg0 ABCDE= 10.0.0.2/32 96.30.192.235:56072

```
