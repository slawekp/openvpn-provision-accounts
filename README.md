Provision OpenVPN accounts easily.
==========================

This script will provision OpenVPN accounts for your users with just one command.

## What is actually does?

1. Generates a username.ovpn file with all required certificates bundled inside.
2. Puts .ovpn file into username.tblk directory
3. Makes .tgz archive out of it.

Tunnelblick user will only have to unpack .tgz file and doubleclick on username.tblk to add a VPN connection. Windows users will still have .ovpn file.


## Usage

For a new user who does not have any certificate:

```
$ ./create_user.sh john.doe
[ OK ]  	Username provided:	john.doe
[ OK ]		Using this CA cert:	/etc/openvpn/easy-rsa/2.0/keys/ca.crt
[ OK ]		Using template: ./templates/config.ovpn
[ info ]	No CRT file found for john.doe.
We'll launch Easy-RSA to generate it. Press any key to continue...

( Here Easy-RSA asks few questions and generates a certificate )

[ OK ]		Generated ./output/john.doe.tgz
```

Reprovisioning configuration for users who already have certificates in Easy-RSA:

```
# ./create_user.sh john.doe
[ OK ]  	Username provided:	john.doe
[ OK ]		Using this CA cert:	/etc/openvpn/easy-rsa/2.0/keys/ca.crt
[ OK ]		Using template: ./templates/config.ovpn

Looks like CRT file for john.doe already exists. Do you want to use it? [Y/n]
[ OK ]		Generated ./output/john.doe.tgz
```

## Requirements

OpenVPN and Easy-RSA 2.0

## Installation

Few guidelines:

1. You can put this tool anywhere you want and run it from there.
2. It's prepared to work on Debian with OpenVPN installed and Easy-RSA present in /etc/openvpn/easy-rsa/2.0. If your setup is different, you can change paths in create_user.conf file.
3. You would need root privileges to access Easy-RSA commands. 

