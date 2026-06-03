# Windows IT Home Lab — SudoFixIt.local

A hands-on home lab project building a fully functional Active Directory, networking, and security environment from scratch using Windows Server 2022 and Windows 11 Pro, hosted on macOS Apple Silicon via UTM/QEMU. Covers Active Directory, DNS, DHCP, Group Policy, firewall hardening, audit policies, and event log monitoring.

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

### Phase 3 — Security hardening & monitoring
- Created custom inbound firewall rules in Windows Defender Firewall with Advanced Security
- Blocked Telnet (port 23) and restricted RDP (port 3389) to the lab subnet only
- Enabled audit policies for logon events, account management, and policy changes
- Monitored Event Viewer Security log for Event IDs 4624 (logon), 4625 (failed logon), and 4724 (password reset)
- Triggered and identified failed logon events by testing bad credentials from Windows 11
- Configured Remote Desktop with Network Level Authentication (NLA) and connected from Windows 11
- Set account lockout policy via Default Domain Policy — 5 attempts, 15 minute lockout
- Tested lockout policy end to end: triggered lockout, identified locked account in ADUC, unlocked it

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
└── Phase3-Security/
    ├── screenshots/
    │   ├── 01-firewall-block-telnet.png
    │   ├── 02-firewall-rdp-subnet.png
    │   ├── 03-audit-policy-enabled.png
    │   ├── 04-event-4625-failed-logon.png
    │   ├── 05-event-4624-success-logon.png
    │   ├── 06-rdp-session-active.png
    │   └── 07-account-locked-aduc.png
    └── scripts/
        └── Get-FailedLogons.ps1
```

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

### Phase 3 — Security hardening & monitoring
| Skill | Tool / Technology |
|---|---|
| Windows Firewall rule creation | `wf.msc` (Windows Defender Firewall) |
| Port blocking and subnet restrictions | Inbound firewall rules |
| Audit policy configuration | `secpol.msc` |
| Security event log monitoring | Event Viewer (`eventvwr.msc`) |
| Failed logon detection (Event ID 4625) | Event Viewer, PowerShell |
| Successful logon tracking (Event ID 4624) | Event Viewer |
| Password reset auditing (Event ID 4724) | Event Viewer |
| Remote Desktop with NLA | `mstsc`, System Settings |
| Account lockout policy configuration | Default Domain Policy, `gpmc.msc` |
| Account lockout testing and recovery | ADUC, `gpupdate /force` |

---

### Phase 1 — Active Directory

> **Note:** The domain controller promotion wizard screenshot was not captured — the server was already promoted prior to documentation setup.

#### 1. AD DS role installed
![AD DS install](Phase1-ActiveDirectory/screenshots/01-adds-install.png)

*Active Directory Domain Services role successfully installed via Server Manager.*

#### 2. First login as domain administrator
![Domain login](Phase1-ActiveDirectory/screenshots/02-domain-sudofixit.png)

*Login screen showing `SUDOFIXIT\Administrator` confirming domain is active.*

#### 3. OU structure in ADUC
![OU structure](Phase1-ActiveDirectory/screenshots/03-aduc-ous.png)

*Organizational Units created to mirror a real business: IT, HR, and Workstations.*

#### 4. Users and security groups
![Users and groups](Phase1-ActiveDirectory/screenshots/04-users-groups.png)

*Domain user accounts created inside OUs with a security group for IT staff.*

#### 5. Windows 11 joined to domain
![Domain join](Phase1-ActiveDirectory/screenshots/05-win11-domain-join.png)

*Windows 11 Pro successfully joined to `SudoFixIt.local` and logged in as a domain user.*

---

### Phase 2 — Networking

#### 1. DNS forward lookup zone
![DNS forward zone](Phase2-Networking/screenshots/01-dns-forward-zone.png)

*Forward lookup zone for `SudoFixIt.local` showing A and SOA records in DNS Manager.*

#### 2. DNS reverse lookup zone
![DNS reverse zone](Phase2-Networking/screenshots/02-dns-reverse-zone.png)

*Reverse lookup zone for the `192.168.64.x` subnet with PTR record pointing back to the server.*

#### 3. DHCP scope configured
![DHCP scope](Phase2-Networking/screenshots/03-dhcp-scope.png)

*DHCP scope covering `192.168.64.50`–`192.168.64.150` with DNS and gateway options set.*

#### 4. DHCP reservation
![DHCP reservation](Phase2-Networking/screenshots/04-dhcp-reservation.png)

*Windows 11 client MAC address reserved to `192.168.64.50` — confirmed via `ipconfig /renew`.*

#### 5. GPO linked to IT OU
![GPO IT policy](Phase2-Networking/screenshots/05-gpo-it-policy.png)

*`IT-LockScreen-Policy` GPO created and linked to the IT OU in Group Policy Management.*

#### 6. Control Panel blocked for HR user
![GPO HR blocked](Phase2-Networking/screenshots/06-gpo-hr-controlpanel-blocked.png)

*Control Panel access blocked for `bwilliams` via the `HR-RestrictControlPanel` GPO.*

### Phase 3 — Security hardening & monitoring

#### 1. Firewall rule — block Telnet
![Block Telnet](Phase3-Security/screenshots/01-firewall-block-telnet.png)

*Custom inbound rule blocking port 23 (Telnet) in Windows Defender Firewall with Advanced Security.*

#### 2. Firewall rule — RDP restricted to lab subnet
![RDP subnet rule](Phase3-Security/screenshots/02-firewall-rdp-subnet.png)

*RDP (port 3389) restricted to `192.168.64.0/24` — only lab machines can connect.*

#### 3. Audit policies enabled
![Audit policy](Phase3-Security/screenshots/03-audit-policy-enabled.png)

*Logon, account management, and policy change audit policies enabled for Success and Failure.*

#### 4. Event ID 4625 — failed logon
![Failed logon](Phase3-Security/screenshots/04-event-4625-failed-logon.png)

*Security log filtered to show failed logon attempts generated by testing bad credentials.*

#### 5. Event ID 4624 — successful logon
![Successful logon](Phase3-Security/screenshots/05-event-4624-success-logon.png)

*Successful domain logon event captured after authenticating as a domain user.*

#### 6. RDP session active from Windows 11
![RDP session](Phase3-Security/screenshots/06-rdp-session-active.png)

*Remote Desktop session connected from Windows 11 to Server 2022 using NLA.*

#### 7. Account locked in ADUC
![Account locked](Phase3-Security/screenshots/07-account-locked-aduc.png)

*`jsmith` account locked after exceeding the 5 attempt lockout threshold — unlocked via ADUC.*

---

- **DNS is the #1 cause of domain join failures.** The Windows 11 client's DNS must point to the Server 2022 IP before attempting to join the domain.
- **IPv6 can override IPv4 DNS settings.** If `nslookup` still shows an IPv6 address after setting DNS manually, disable IPv6 on the adapter: `Disable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6`
- **Set DNS via PowerShell if Settings won't save it:** `Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.64.3"`
- On UTM/QEMU, ensure the ISO is ejected after OS installation or the VM will boot back into the installer on restart.
- Never change VM network adapter settings while the VM is running — always shut down fully first.
- Both VMs must be on the same virtual network mode in UTM (Shared Network) for communication to work.
- DHCP must be authorized in Active Directory before it will hand out leases on a domain network.
- **UTM Shared Network has a built-in DHCP service that cannot be disabled.** It will win the DHCP race against your Windows Server DHCP in most cases. The scope, reservation, and options are correctly configured on the server — this is a hypervisor limitation, not a misconfiguration. Use DHCP reservations to document intent.

---

## Part of a larger lab series

This project covers Phases 1–3 of a multi-phase Windows IT & Security Home Lab:

| Phase | Focus | Status |
|---|---|---|
| Phase 1 | Active Directory & user management | ✅ Complete |
| Phase 2 | Networking — DNS, DHCP, Group Policy | ✅ Complete |
| Phase 3 | Security hardening & monitoring | ✅ Complete |
| Phase 4 | Cloud & Azure (AZ-900 prep) | 🔲 Upcoming |

---

*Built as part of a self-directed IT/cybersecurity home lab to develop practical, job-ready skills.*
