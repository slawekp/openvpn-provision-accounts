Provision OpenVPN accounts easily.
==========================

This script will provision OpenVPN accounts for your users with just one command.

## Requirements

OpenVPN and Easy-RSA 2.0

## What is actually does?

It generates a username.ovpn file with CA CRT, user CRT and key bundled inside. Then it creates a username.tblk directory on top of it and then make a .tgz archive out of it. Tunnelblick user will only have to unpack this file and doubleclick on username.tblk.

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

