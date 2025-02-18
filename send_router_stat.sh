#!/bin/sh

function send_stat {
    curl -s -H "$CustomHeader" "$URL:$PORT/$CustomPath?mac-addr=$1" 2>&1 > /dev/null
    logger -t send_router_stat "send request to $URL:$PORT"
}

function get_mac_addr {
    mac="$(ip link | grep -A1 "$1" | grep -Eo '(\w+:\w+)+' | grep -v 'ff:ff:ff:ff:ff:ff')"
    logger -t send_router_stat "getted mac addr: $mac" 
    echo "$mac"
}


# waiting initialize network interfaces
sleep 20

mac=$(get_mac_addr $INTERFACE)

while true; do
    send_stat $mac
    sleep $TIMEOUT
done
