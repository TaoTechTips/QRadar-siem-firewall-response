#!/bin/bash
#
# block_ip.sh - Add an IP address to pfSense blocklist via SSH

# === Configuration ===
PFSENSE_HOST="10.10.1.1"
PFSENSE_USER="qradar_usr"
SSH_KEY="/home/customactionuser/.ssh/id_rsa"
BLOCK_TABLE="qradar_blocklist"

# === Input validation ===
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

IP=$1

# === Add IP to blocklist ===
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$PFSENSE_USER@$PFSENSE_HOST" \
    "sudo /sbin/pfctl -t $BLOCK_TABLE -T add $IP"

# === Check result ===
if [ $? -eq 0 ]; then
    echo "[+] Successfully added $IP to blocklist ($BLOCK_TABLE)"
else
    echo "[-] Failed to add $IP to blocklist"
    exit 1
fi
