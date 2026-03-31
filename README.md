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

**Screenshot:**
<img width="1728" height="1124" alt="Screenshot 2026-03-28 at 3 40 59 PM" src="https://github.com/user-attachments/assets/c7309628-7203-4f92-bb2f-c1592fc3275e" />
<img width="3456" height="2248" alt="image" src="https://github.com/user-attachments/assets/ad07ad17-426c-4711-9739-317148da8f7b" />

---

## Project 3 — Task Scheduler Automation

**Objective:** Schedule a PowerShell script to automatically export 
failed login events to a CSV on a recurring basis.

**Skills demonstrated:**
- Task Scheduler configuration
- Scheduled PowerShell execution
- Automated log export to CSV

**Script:** 
- "C:\Labs\Scripts\log_check.ps1"

**Screenshot:**
<img width="3456" height="2248" alt="image" src="https://github.com/user-attachments/assets/dbb9479e-1de9-4fe8-a1a5-db766f32dfb7" />
<img width="3456" height="2248" alt="image" src="https://github.com/user-attachments/assets/f74d81cd-ef8b-4b72-8ed7-f0db313c3727" />

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
