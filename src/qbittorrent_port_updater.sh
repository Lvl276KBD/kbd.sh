#!/usr/bin/env bash

# Path to ProtonVPN's forwarded port
PP_FILE="/run/user/1000/Proton/VPN/forwarded_port"
# qBittorrent Web UI endpoint
QBT_URL="http://localhost:8082"

# Check if ProtonVPN's port file exists
if [[ ! -f "$PP_FILE" ]]; then
    echo "ProtonVPN port not found: $PP_FILE"
    exit 1
fi

# Read port value and remove any newline characters
port="$(cat "$PP_FILE" | tr -d '\n')"

if ! [[ "$port" =~ ^[0-9]+$ ]]; then
    echo "Invalid port value: $port"
    exit 1
fi

echo "ProtonVPN port: $port"

# Send the port update to qBittorrent Web API
curl -s \
    -d "json={\"listen_port\":$port}" \
    "$QBT_URL/api/v2/app/setPreferences" > /dev/null

# Notify user that update was successful
notify-send "qBittorrent" "Port updated to $port"
