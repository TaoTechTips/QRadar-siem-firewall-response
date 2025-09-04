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

