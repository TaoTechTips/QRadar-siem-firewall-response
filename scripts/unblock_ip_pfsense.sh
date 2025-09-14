#!/bin/bash

# === Static Variables ===
PFSENSE_HOST="10.10.1.1"             
PFSENSE_USER="qradar_usr"         
SSH_KEY="/root/.ssh/id_rsa"         
BLOCK_TABLE="qradar_blocklist"    

# === Input validation ===
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

IP=$1

# === Remove IP from blocklist ===
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$PFSENSE_USER@$PFSENSE_HOST" \
    "sudo /sbin/pfctl -t $BLOCK_TABLE -T delete $IP"

# === Check result ===
if [ $? -eq 0 ]; then
    echo "[+] Successfully removed $IP from blocklist ($BLOCK_TABLE)"
else
    echo "[-] Failed to remove $IP from blocklist"
    exit 1
fi

