# 🚀 Automated Firewall Blocking with QRadar Custom Actions

## 📌 Introduction

In Security Operations Centers (SOCs), analysts often spend valuable time manually responding to recurring malicious IP connections. This project demonstrates how to automate **incident response in IBM QRadar SIEM** by creating a **custom action script** that blocks malicious IPs directly on a firewall (pfSense).

By reducing response time from minutes to seconds, this automation helps SOC teams improve their **MTTR (Mean Time to Respond)** and strengthens the overall security posture.

---

## 🏗️ Architecture Overview

### Network Architecture

![SOC Architecture](https://github.com/user-attachments/assets/a39d83fb-bd17-4d0d-92ce-3752ff4d510b)

```mermaid
flowchart LR
    A[QRadar Offense Triggered] --> B[Custom Action Script]
    B --> C[SSH Connection to pfSense Firewall]
    C --> D[pfctl Adds IP to Block List Alias]
    D --> E[Firewall Rule Auto Blocks IPs Added to Block List]
```

* **QRadar**: Detects offense (e.g., brute force, port scanning).
* **Custom Action Script**: Bash script runs when offense is triggered.
* **pfSense Firewall**: Executes `pfctl` command which blocks offending IP.

---

## ⚙️ Implementation

### 🔹 Prerequisites

* IBM QRadar CE (SIEM)
* pfSense Firewall VM (Router x Firewall)
* Windows Server (Victim Machine)
* SSH access with restricted admin privileges using ssh keys for authentication
* Bash Script

### 🔹 Steps

1. **Set up SSH Keys for Authentication**

   * On QRadar:
   ``` bash
    ssh-keygen -t rsa
    ssh-copy-id admin@<pfsense-ip>
   ```
   
   Ensure the Qradar system can log in to pfSense without a passowrd

2. **Write Bash Script**

    ```bash
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
    ```

4. **Test Workflow**

   * Trigger a QRadar offense with a test IP.
   * QRadar offense is generated and automated response is triggered.
   * Verify pfSense now has the IP in its block list.
   * Verify blocked connection
     ```bash
     pfctl -t qradar_blocklist -T show
     ```

---

## 📊 Results

* **Before Automation:** Blocking required manual firewall login (\~3–5 mins).
* **After Automation:** QRadar offense triggers script -> IP blocked automatically in seconds.
* **SOC Value:** Faster response & containment, reduced analyst fatigue, repeatable playbook.

---

## 🔮 Future Enhancements

* ✅ Add an unblock script to resotre connection.
* 🔗 Integrate with **Splunk SOAR CE** for advanced playbook orchestration.
* 🌐 Extend support to other firewalls (Cisco ASA, Palo Alto, Fortinet).

---

## 🧰 Skills & Keywords

* SIEM Engineering (QRadar Custom Actions)
* Firewall Integration (pfSense via SSH + pfctl)
* Bash Scripting
* SOC Workflow Optimization
* Incident Response Automation

---

## 📸 Screenshots

* QRadar offense triggered

  <img width="1861" height="39" alt="Screenshot 2025-09-05 235147" src="https://github.com/user-attachments/assets/f4dcac3f-ee93-43c4-9c17-d2b78f4e0cd0" />

  <img width="1251" height="353" alt="Screenshot 2025-09-05 234636" src="https://github.com/user-attachments/assets/9aae31b1-5af2-4a35-a9f0-a100ede46d1e" />

* Custom Action execution logs

  <img width="1142" height="151" alt="Screenshot 2025-09-05 234300" src="https://github.com/user-attachments/assets/830dc9b4-3e20-4851-9685-2a76e8b3ca22" />

* Verification of blocked traffic
  
  --- Blocked RDP connection ---
  
  <img width="728" height="337" alt="Screenshot 2025-09-06 005034" src="https://github.com/user-attachments/assets/fbf8929b-f647-40e8-b2bc-5f5c0102b4b2" />

  --- Blocked QRadar UI Connection (HTTPS) ---
  
  <img width="548" height="443" alt="Screenshot 2025-09-06 005403" src="https://github.com/user-attachments/assets/65fa0e91-14d5-44b3-9779-abc1de9a549f" />

  --- Firewall Log Showing Blocked Traffic ---

  <img width="1133" height="139" alt="Screenshot 2025-09-06 004909" src="https://github.com/user-attachments/assets/83695529-1040-4586-afac-e7aed24b27e9" />


---

## ✍️ Author

👤 **Taofeek Isiaka-Aliagan**

* 💼 Cybersecurity Engineer (SIEM | SOC | Security Engineering)
* 📜 IBM QRadar SIEM Admin | CompTIA Security+ | ISC² CC
* 🌐 [LinkedIn](https://linkedin.com/in/taotechtips) | [Medium](https://medium.com/@taotechtips)
