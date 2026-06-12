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

### Phase 3 — Security hardening & monitoring

#### 1. Firewall rule — block Telnet
![Block Telnet](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Security%20Hardening%20&%20Monitoring%20Lab/screenshots/1.%20Firewall%20rule%20%E2%80%94%20block%20Telnet%20&%202.%20Firewall%20rule%20%E2%80%94%20RDP%20restricted%20to%20lab%20subnet.png?raw=true)

*Custom inbound rule blocking port 23 (Telnet) in Windows Defender Firewall with Advanced Security.*

#### 2. Firewall rule — RDP restricted to lab subnet
![RDP subnet rule](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Security%20Hardening%20&%20Monitoring%20Lab/screenshots/1.%20Firewall%20rule%20%E2%80%94%20block%20Telnet%20&%202.%20Firewall%20rule%20%E2%80%94%20RDP%20restricted%20to%20lab%20subnet.png?raw=true)

*RDP (port 3389) restricted to `192.168.64.0/24` — only lab machines can connect.*

#### 3. Audit policies enabled
![Audit policy](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Security%20Hardening%20&%20Monitoring%20Lab/screenshots/3.%20Audit%20policies%20enabled.png?raw=true)

*Logon, account management, and policy change audit policies enabled for Success and Failure.*

#### 4. Event ID 4625 — failed logon
![Failed logon](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Security%20Hardening%20&%20Monitoring%20Lab/screenshots/4.%20Event%20ID%204625%20%E2%80%94%20failed%20logon.png?raw=true)

*Security log filtered to show failed logon attempts generated by testing bad credentials.*

#### 5. Event ID 4624 — successful logon
![Successful logon](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Security%20Hardening%20&%20Monitoring%20Lab/screenshots/5.%20Event%20ID%204624%20%E2%80%94%20successful%20logon.png?raw=true)

*Successful domain logon event captured after authenticating as a domain user.*

#### 6. RDP session active from Windows 11
![RDP session](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Security%20Hardening%20&%20Monitoring%20Lab/screenshots/6.%20RDP%20session%20active%20from%20Windows%2011.png?raw=true)

*Remote Desktop session connected from Windows 11 to Server 2022 using NLA.*

#### 7. Account locked in ADUC
![Account locked](https://github.com/DAHogan/PowerShell_Portfolio/blob/main/Security%20Hardening%20&%20Monitoring%20Lab/screenshots/7.%20Account%20locked%20in%20ADUC.png?raw=true)

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

---

*Built as part of a self-directed IT/cybersecurity home lab to develop practical, job-ready skills.*
