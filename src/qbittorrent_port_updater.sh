#!/usr/bin/env bash

PP_FILE="/run/user/1000/Proton/VPN/forwarded_port"
QBT_URL="http://localhost:8082"

if [[ ! -f "$PP_FILE" ]]; then
    echo "ProtonVPN port not found: $PP_FILE"
    exit 1
fi

port="$(cat "$PP_FILE" | tr -d '\n')"

if ! [[ "$port" =~ ^[0-9]+$ ]]; then
    echo "Invalid port value: $port"
    exit 1
fi

echo "ProtonVPN port: $port"

curl -s \
    -d "json={\"listen_port\":$port}" \
    "$QBT_URL/api/v2/app/setPreferences" > /dev/null

notify-send "qBittorrent" "Port updated to $port"
