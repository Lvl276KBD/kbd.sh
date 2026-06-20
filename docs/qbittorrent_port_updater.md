# ❤︎ qbittorrent_port_updater — qBittorrent + ProtonVPN port updater ❤︎

A Bash script that automatically syncs the ProtonVPN forwarded port with qBittorrent.


## ❤︎ Overview

This script reads the forwarded port provided by ProtonVPN and applies it to qBittorrent via its Web API.
It ensures that qBittorrent always uses the correct VPN-assigned port for incoming connections.


## ❤︎ What it does

- Reads ProtonVPN's forwarded port file
- Validates port value
- Sends port to qBittorrent Web UI API
- Sends desktop notification on success


## ❤︎ Requirements

- `curl`
- `notify-send`
- qBittorrent Web UI enabled

## ❤︎ Configuration

### ❤︎ ProtonVPN port file

The script reads the currently forwarded VPN port from:

/run/user/1000/Proton/VPN/forwarded_port


### ❤︎ qBittorrent Web UI

Default Web UI endpoint:

http://localhost:8082

Make sure the Web UI is enabled in qBittorrent settings.