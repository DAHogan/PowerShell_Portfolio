# PowerShell_Portfolio
Portfolio of real-world PowerShell scripts demonstrating automation, administration, and DevOps skills.

# Windows Fundamentals

## Overview
Hands-on exploration of core Windows administration skills using a 
Windows 11 Pro VM running on VirtualBox. Skills practiced here directly 
map to Help Desk, IT Support, and SOC Analyst responsibilities.

---

## Project 1: PowerShell Automation

**Objective:** Use PowerShell to automate common sysadmin tasks, including 
user creation, file management, and service enumeration.

**Skills demonstrated:**
- Local user account creation via PowerShell
- File/directory automation
- Service enumeration and filtering
- Script creation and execution policy management

**Screenshot:**
<img width="1712" height="352" alt="image" src="https://github.com/user-attachments/assets/7aa48679-fedc-40b9-9750-a8e5227c32b8" />
<img width="1710" height="616" alt="image" src="https://github.com/user-attachments/assets/e8f055bf-1505-4e4b-8d7a-4d35f9669354" />
<img width="1710" height="344" alt="image" src="https://github.com/user-attachments/assets/790889cb-c8a3-4351-b8d3-d8bc580407ab" />


**Script:** 

- Get-ComputerInfo | Select-Object CsName, OsName, OsVersion, CsProcessors, CsTotalPhysicalMemory

- New-Item -ItemType Directory -Path "C:\Labs"
- 1..5 | ForEach-Object { New-Item -Path "C:\Labs\Folder$_.txt" -ItemType File }

- $Password = ConvertTo-SecureString "Lab@12345" -AsPlainText -Force
- New-LocalUser -Name "Pharaoh Hogan" -Password $Password -FullName "Pharaoh Hogan" -Description "Lab account"
- Add-LocalGroupMember -Group "Users" -Member "Pharaoah Hogan"

---

## Project 2 — Windows Event Log Analysis

**Objective:** Navigate Windows Event Viewer and identify key security 
events as a SOC analyst would during an investigation.

**Key Event IDs studied:**
| Event ID | Description |
|---|---|
| 4624 | Successful logon |
| 4625 | Failed logon attempt |
| 4634 | Logoff |
| 4720 | User account created |
| 4732 | User added to group |

**What I did:** Manually triggered logon/logoff and failed login events, 
then located and filtered them in Event Viewer using Event ID filters.

**Screenshot:** *(add screenshot of filtered 4625 events)*

---

## Project 3 — Task Scheduler Automation

**Objective:** Schedule a PowerShell script to automatically export 
failed login events to a CSV on a recurring basis.

**Skills demonstrated:**
- Task Scheduler configuration
- Scheduled PowerShell execution
- Automated log export to CSV

**Script:** [log_check.ps1](scripts/log_check.ps1)

**Screenshot:** *(add screenshot of Task Scheduler task + output CSV)*

---

## Project 4 — Windows Firewall Rule Management

**Objective:** Create and verify custom inbound firewall rules and 
audit open ports on the system.

**Skills demonstrated:**
- Custom inbound rule creation (blocked Telnet port 23)
- Rule verification via PowerShell Get-NetFirewallRule
- Open port auditing with netstat
- PID-to-process mapping via Task Manager

**Screenshot:** *(add screenshot of firewall rule + netstat output)*

---

## Tools & Environment
- UTM on macOS (Apple Silicon)
- Windows 11 Pro (ARM64)
- PowerShell 5.1
