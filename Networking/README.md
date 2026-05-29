# Windows IT Home Lab — SudoFixIt.local

A hands-on home lab project building a fully functional Active Directory and networking environment from scratch using Windows Server 2022 and Windows 11 Pro, hosted on macOS Apple Silicon via UTM/QEMU. Covers Active Directory, DNS, DHCP, and Group Policy.

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

### Phase 1 — Active Directory & user management
- Installed the Active Directory Domain Services (AD DS) role on Windows Server 2022
- Promoted the server to a domain controller for the `SudoFixIt.local` forest
- Designed and created an Organizational Unit (OU) structure mirroring a real business environment
- Created user accounts and security groups and assigned users to appropriate OUs
- Joined a Windows 11 Pro client machine to the `SudoFixIt.local` domain
- Logged in as a domain user and verified domain membership via ADUC and System settings
- Practiced core help desk tasks: password resets, account lockouts, disable/enable accounts

### Phase 2 — Networking (DNS, DHCP, Group Policy)
- Configured forward and reverse lookup zones in DNS Manager
- Tested DNS resolution using `nslookup` from the Windows 11 client
- Installed and authorized a DHCP server in Active Directory
- Created a DHCP scope (`192.168.64.50`–`192.168.64.150`) with DNS and gateway options
- Created a DHCP reservation to pin the Windows 11 client to a fixed IP by MAC address
- Created and linked Group Policy Objects (GPOs) to department OUs
- Applied a lock screen policy to the IT OU and a Control Panel restriction to the HR OU
- Verified GPO application using `gpupdate /force` and tested policies against domain user accounts

---

## Project structure

```
Windows-IT-Lab/
├── README.md
├── Phase1-ActiveDirectory/
│   ├── screenshots/
│   │   ├── 01-adds-install.png
│   │   ├── 02-domain-sudofixit.png
│   │   ├── 03-aduc-ous.png
│   │   ├── 04-users-groups.png
│   │   └── 05-win11-domain-join.png
│   └── scripts/
│       └── New-LabUsers.ps1
└── Phase2-Networking/
    ├── screenshots/
    │   ├── 01-dns-forward-zone.png
    │   ├── 02-dns-reverse-zone.png
    │   ├── 03-dhcp-scope.png
    │   ├── 04-dhcp-reservation.png
    │   ├── 05-gpo-it-policy.png
    │   └── 06-gpo-hr-controlpanel-blocked.png
    └── scripts/
        └── Set-LabDNS.ps1
```

---

## Skills demonstrated

### Phase 1 — Active Directory
| Skill | Tool / Technology |
|---|---|
| AD DS role installation | Server Manager |
| Domain controller promotion | Active Directory wizard |
| Forest and domain creation | `SudoFixIt.local` |
| OU design and creation | ADUC (`dsa.msc`) |
| User account management | ADUC, PowerShell |
| Security group creation and membership | ADUC |
| Domain join and troubleshooting | Windows Settings, DNS |
| Help desk account tasks (reset, unlock, disable) | ADUC |
| Bulk user creation via scripting | PowerShell 5.1 |

### Phase 2 — Networking
| Skill | Tool / Technology |
|---|---|
| DNS forward lookup zone management | DNS Manager (`dnsmgmt.msc`) |
| DNS reverse lookup zone creation and PTR records | DNS Manager |
| DNS resolution testing and troubleshooting | `nslookup`, PowerShell |
| DHCP server installation and AD authorization | Server Manager, DHCP Manager |
| DHCP scope creation with options | DHCP Manager (`dhcpmgmt.msc`) |
| DHCP reservation by MAC address | DHCP Manager |
| IP configuration and lease management | `ipconfig /release`, `ipconfig /renew` |
| Group Policy Object creation and linking | Group Policy Management (`gpmc.msc`) |
| GPO application and verification | `gpupdate /force`, `gpresult` |
| Department-level access control via GPO | Group Policy Management |

---

## Screenshots

### Phase 2 — Networking

#### 1. DNS forward lookup zone
![DNS forward zone](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Networking/screenshots/1.%20DNS%20forward%20lookup%20zone.png?raw=true)

*Forward lookup zone for `SudoFixIt.local` showing A and SOA records in DNS Manager.*

#### 2. DNS reverse lookup zone
![DNS reverse zone](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Networking/screenshots/2.%20DNS%20reverse%20lookup%20zone.png?raw=true)

*Reverse lookup zone for the `192.168.64.x` subnet with PTR record pointing back to the server.*

#### 3. DHCP scope configured
![DHCP scope]([https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Networking/screenshots/DHCP%20ADDR%20POOL.png?raw=true](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Networking/screenshots/3.%20DHCP%20Address%20Pool.png?raw=true))

*DHCP scope covering `192.168.64.50`–`192.168.64.150` with DNS and gateway options set.*

#### 4. DHCP reservation
![DHCP reservation](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Networking/screenshots/4.%20Reservation%20for%20Computer%20-01.png?raw=true)
![DHCP reservation](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Networking/screenshots/4.%20Scope%20Confirmation%20via%20ipconfig.png?raw=true)
![DHCP reservation](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Networking/screenshots/4.%20Scope%20Options.png?raw=true)

*Windows 11 client MAC address reserved to `192.168.64.50` — UTM gateway was faster to assign IP ADDR.*

#### 5. GPO linked to IT OU
![GPO IT policy](Phase2-Networking/screenshots/05-gpo-it-policy.png)

*`IT-LockScreen-Policy` GPO created and linked to the IT OU in Group Policy Management.*

#### 6. Control Panel blocked for HR user
![GPO HR blocked](Phase2-Networking/screenshots/06-gpo-hr-controlpanel-blocked.png)

*Control Panel access blocked for `bwilliams` via the `HR-RestrictControlPanel` GPO.*

---

## Key troubleshooting notes

- **DNS is the #1 cause of domain join failures.** The Windows 11 client's DNS must point to the Server 2022 IP before attempting to join the domain.
- **IPv6 can override IPv4 DNS settings.** If `nslookup` still shows an IPv6 address after setting DNS manually, disable IPv6 on the adapter: `Disable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6`
- **Set DNS via PowerShell if Settings won't save it:** `Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.64.3"`
- On UTM/QEMU, ensure the ISO is ejected after OS installation or the VM will boot back into the installer on restart.
- Never change VM network adapter settings while the VM is running — always shut down fully first.
- Both VMs must be on the same virtual network mode in UTM (Shared Network) for communication to work.
- DHCP must be authorized in Active Directory before it will hand out leases on a domain network.

---

## Part of a larger lab series

This project covers Phases 1 and 2 of a multi-phase Windows IT & Security Home Lab:

| Phase | Focus | Status |
|---|---|---|
| Phase 1 | Active Directory & user management | ✅ Complete |
| Phase 2 | Networking — DNS, DHCP, Group Policy | ✅ Complete |
| Phase 3 | Security hardening & monitoring | 🔲 Upcoming |
| Phase 4 | Cloud & Azure (AZ-900 prep) | 🔲 Upcoming |

---

*Built as part of a self-directed IT/cybersecurity home lab to develop practical, job-ready skills.*
