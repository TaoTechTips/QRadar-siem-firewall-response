#!/bin/bash
#
# unblock_ip.sh - Remove an IP address from pfSense blocklist via SSH
#

# === Configuration ===
PFSENSE_HOST="10.10.1.1"             # pfSense IP/hostname
PFSENSE_USER="qradar_usr"            # pfSense user with sudo rights for pfctl
SSH_KEY="/root/.ssh/id_rsa"          # Private key path on QRadar
BLOCK_TABLE="qradar_blocklist"       # pfSense table name

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

