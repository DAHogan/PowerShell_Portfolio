# Active Directory Home Lab — SudoFixIt.local

A hands-on home lab project building a fully functional Active Directory environment from scratch using Windows Server 2022 and Windows 11 Pro, hosted on macOS Apple Silicon via UTM/QEMU.

---

## Environment

| Component | Details |
|---|---|
| Host machine | macOS Apple Silicon (UTM/QEMU ARM) |
| Domain controller | Windows Server 2022 (ARM64) |
| Client machine | Windows 11 Pro (ARM64) |
| Domain | `SudoFixIt.local` |
| Scripting | PowerShell 5.1 |

---

## What I built

- Installed the Active Directory Domain Services (AD DS) role on Windows Server 2022
- Promoted the server to a domain controller for the `SudoFixIt.local` forest
- Designed and created an Organizational Unit (OU) structure mirroring a real business environment
- Created user accounts and security groups and assigned users to appropriate OUs
- Joined a Windows 11 Pro client machine to the `SudoFixIt.local` domain
- Logged in as a domain user and verified domain membership via ADUC and System settings
- Practiced core help desk tasks: password resets, account lockouts, disable/enable accounts

---

## Project structure

```
Active-Directory-Lab/
├── README.md
├── screenshots/
│   ├── 01-adds-install.png
│   ├── 02-domain-sudofixit.png
│   ├── 03-aduc-ous.png
│   ├── 04-users-groups.png
│   └── 05-win11-domain-join.png
└── scripts/
    └── New-LabUsers.ps1
```

---

## Skills demonstrated

| Skill | Tool / Technology |
|---|---|
| AD DS role installation | Server Manager |
| Domain controller promotion | Active Directory wizard |
| Forest and domain creation | `SudoFixIt.local` |
| OU design and creation | ADUC (`dsa.msc`) |
| User account management | ADUC, PowerShell |
| Security group creation and membership | ADUC |
| Domain join and troubleshooting | Windows Settings, DNS |
| DNS configuration for domain resolution | Windows Server DNS Manager |
| Help desk account tasks (reset, unlock, disable) | ADUC |
| Bulk user creation via scripting | PowerShell 5.1 |

---

## Screenshots

> **Note:** The domain controller promotion wizard screenshot was not captured — the server was already promoted prior to documentation setup.

### 1. AD DS role installed
## Example Output
![Script Output](<img width="1728" height="1124" alt="Screenshot 2026-04-01 at 4 48 17 PM" src="https://github.com/user-attachments/assets/0fc15d37-09bb-4521-8fd6-4b83b3a98f7f" />)

*Active Directory Domain Services role successfully installed via Server Manager.*

### 2. First login as domain administrator
<img width="3456" height="2248" alt="image" src="https://github.com/user-attachments/assets/f70c1172-b377-4002-8ec6-f576da4b7be4" />

*Login screen showing `SUDOFIXIT\Administrator` confirming domain is active.*

### 3. OU structure in ADUC
![OU structure](screenshots/03-aduc-ous.png)

*Organizational Units created to mirror a real business: IT, HR, and Workstations.*

### 4. Users and security groups
![Users and groups](screenshots/04-users-groups.png)

*Domain user accounts created inside OUs with a security group for IT staff.*

### 5. Windows 11 joined to domain
![Domain join](screenshots/05-win11-domain-join.png)

*Windows 11 Pro successfully joined to `SudoFixIt.local` and logged in as a domain user.*

---

## Key troubleshooting notes

- **DNS is the #1 cause of domain join failures.** The Windows 11 client's DNS must point to the Server 2022 IP before attempting to join the domain.
- On UTM/QEMU, ensure the ISO is ejected after OS installation or the VM will boot back into the installer on restart.
- Both VMs must be on the same virtual network switch in UTM for communication to work.

---

## Part of a larger lab series

This project is Phase 1 of a multi-phase Windows IT & Security Home Lab:

| Phase | Focus | Status |
|---|---|---|
| Phase 1 | Active Directory & user management | ✅ Complete |
| Phase 2 | Networking — DNS, DHCP, Group Policy | 🔲 Upcoming |
| Phase 3 | Security hardening & monitoring | 🔲 Upcoming |
| Phase 4 | Cloud & Azure (AZ-900 prep) | 🔲 Upcoming |

---

*Built as part of a self-directed IT/cybersecurity home lab to develop practical, job-ready skills.*
