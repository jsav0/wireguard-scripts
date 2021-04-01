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


---

## Basic usage

Download
```
git clone git://wfnintr.net/wireguard-scripts
```

1. create the server interface
```
./wgc create wg0
```

2. create a config for a client on the interface, name it whatever you want
```
./wgc add-peer wg0 iphone
./wgc add-peer wg0 thinkpadx220
./wgc add-peer wg0 thinkpadx230
```

3. export/import the config `client/<name>.conf` to your client
You will need to tweak the client config before using, adding the ipv4 server address, until it's added to the script



Note: You can generate a QR code of the client config like so:
```
qrencode -t ansiutf8 -r iphone.conf
```
