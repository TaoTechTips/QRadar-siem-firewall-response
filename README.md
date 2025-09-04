# QRadar-siem-firewall-response
Automated blocking of malicious IP addresses on pfSense firewall in response to QRadar SIEM correlation rules

This project demonstrates how to extend QRadar's **Custom Rule Engine (CRE) actions** to dynamically add or remove IP addresses from a pfSense firewall alias. The result is automated threat response (SOAR-lite) without needing extra tools.

## ✨ Features
- Block malicious IPs on pfSense directly from QRadar rules  
- Unblock IPs automatically (manual trigger or scheduled timeout)  
- Integration via SSH (`pfctl`) or pfSense REST API (if enabled)  
- Works with pfSense aliases, integrates with firewall rules  
- Lightweight scripts, no extra dependencies  

---

## 🏗️ Architecture
```text
[QRadar SIEM]
   │  (Custom Action)
   ▼
block_ip_pfsense.sh
   │  (SSH / API)
   ▼
[pfSense Firewall]
   │
   ▼
Firewall Alias → Block Rule → Dropped Traffic

```

---

## ⚙️ Setup Guide

### Prepare pfSense
1. Create a user on pfSense for automation (`qradar_usr`)
2. Enable SSH access (`User - System: Shell account access`)
3. Configure an alias in pfSense called `qradar_blocklist`.
4. Add a firewall rule to block traffic from this alias.

### 



## 🚀 Usage

Block an IP (manual test)

`/opt/qradar/bin/block_ip_pfsense.sh 1.2.3.4`


Unblock an IP (manual test)

`/opt/qradar/bin/unblock_ip_pfsense.sh 1.2.3.4`


Automatic Blocking:
Attach the Block Action to a QRadar rule (e.g., "10 failed logins from same IP in 5 minutes").

Automatic Unblocking:
Attach the Unblock Action to a scheduled rule, or run via cron for time-based expiry.

## 🔐 Security Notes

- Use a dedicated pfSense user with minimal privileges.

- Least Privilege - Add dedicated user to sudoers file but restrict access to run only the required command for the automation to work.

- Monitor and log all automated blocks to avoid accidental self-blocking.

## 🛠️ Roadmap

- Add pfSense RESTCONF integration (persistent alias updates via API)

- pfBlockerNG integration for GUI-persistent feeds

- Example QRadar rule exports

## 🤝 Contributing

Pull requests are welcome! Please open an issue first to discuss major changes.

## 📜 License

free to use, modify, and share.
