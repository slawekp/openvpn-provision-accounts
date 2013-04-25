#!/bin/bash

### Functions

function ask {
    while true; do
 
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi
 
        # Ask the question
        read -p "$1 [$prompt] " REPLY
 
        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
 
        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

### CODE #############################################################


CONFIG_FILE=./create_user.conf
TEMPLATE_FILE="./templates/config.ovpn"
OVPN_FILE=output/$1/$1.tblk/$1.ovpn

if [ -f $CONFIG_FILE ]; then
        . $CONFIG_FILE
fi

if [ $# -eq 0 ];
then
    echo "Usage: create_user.sh username"
    exit 1
fi

#echo -e "This script will create an OpenVPN configuration for: \033[1;32m$prompt$1\033[0m"
echo -e "[ OK ]\t\tUsername provided:\t$1"

if [ ! -f $KEYS_PATH/ca.crt ];
then
    echo "[ERROR]\t\tca.crt file not found under $KEYS_PATH/ca.crt"
fi
echo -e "[ OK ]\t\tUsing this CA cert:\t$KEYS_PATH/ca.crt"

if [ ! -f $TEMPLATE_FILE ];
then
    echo -e "[ ERROR ]\tTemplate file not found under $TEMPLATE_FILE"
    exit 1
fi
echo -e "[ OK ]\t\tUsing template: $TEMPLATE_FILE"

if [ -f $KEYS_PATH/$1.crt ];
then
    echo
    if ask "Looks like CRT file for $1 already exists. Do you want to use it?" Y; then
	echo -n
    else
        echo -e "\nUnfortunately we have to stop here. Please start again and provide a different username.\n"
	exit 1
    fi
else
    echo -e -n "[ info ]\tNo CRT file found for $1.\nWe'll launch Easy-RSA to generate it. Press any key to continue..."
    read -rsn1
    echo
    CWD=`pwd`
    cd $EASY_RSA_PATH
    source $EASY_RSA_PATH/vars
    $EASY_RSA_PATH/build-key $1
    cd $CWD
fi


# At this point we should have $1.crt and $1.key.
# TODO: Add one last check

# replacing variable placeholders in template file
TEMPLATE=`cat $TEMPLATE_FILE`
TEMPLATE=${TEMPLATE//\$SERVER_IP/$SERVER_IP}
TEMPLATE=${TEMPLATE//\$SERVER_PORT/$SERVER_PORT}


mkdir -p output/$1/$1.tblk
echo "$TEMPLATE" > $OVPN_FILE

echo -e "\n<ca>\n""`cat $KEYS_PATH/ca.crt`""\n</ca>"   >> $OVPN_FILE
echo -e "<cert>\n""`cat $KEYS_PATH/$1.crt`""\n</cert>" >> $OVPN_FILE
echo -e "<key>\n""`cat $KEYS_PATH/$1.key`""\n</key>" >> $OVPN_FILE

cd ./output/$1
tar -czf ../$1.tgz *

echo -e "[ OK ]\t\tGenerated ./output/$1.tgz"
