<#
.SYNOPSIS
    Configures DNS settings on a domain client for SudoFixIt.local

.DESCRIPTION
    Sets the preferred DNS server to the SudoFixIt.local domain controller,
    disables IPv6 to prevent it from overriding IPv4 DNS, flushes the DNS
    resolver cache, and verifies resolution of SudoFixIt.local.

    Run this script on any Windows client that needs to communicate with
    the SudoFixIt.local domain — especially before a domain join.

.PARAMETER DCIPAddress
    IP address of the SudoFixIt.local domain controller.
    Defaults to 192.168.64.3.

.PARAMETER AdapterName
    Name of the network adapter to configure.
    Defaults to "Ethernet". Run Get-NetAdapter to find yours.

.EXAMPLE
    .\Set-LabDNS.ps1

.EXAMPLE
    .\Set-LabDNS.ps1 -DCIPAddress "192.168.64.3" -AdapterName "Ethernet"

.NOTES
    Author:  SudoFixIt Lab
    Requires: Run as Administrator
#>

[CmdletBinding()]
param (
    [string]$DCIPAddress = "192.168.64.3",
    [string]$AdapterName = "Ethernet"
)

# ── Helper function for consistent output ──────────────────────────────────────
function Write-Status {
    param (
        [string]$Message,
        [ValidateSet("Info", "Success", "Warning", "Error")]
        [string]$Type = "Info"
    )
    $colors = @{
        Info    = "Cyan"
        Success = "Green"
        Warning = "Yellow"
        Error   = "Red"
    }
    $prefix = @{
        Info    = "[*]"
        Success = "[+]"
        Warning = "[!]"
        Error   = "[-]"
    }
    Write-Host "$($prefix[$Type]) $Message" -ForegroundColor $colors[$Type]
}

# ── Require Administrator privileges ──────────────────────────────────────────
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Status "This script must be run as Administrator. Exiting." -Type Error
    exit 1
}

Write-Host ""
Write-Host "================================================" -ForegroundColor DarkCyan
Write-Host "   Set-LabDNS.ps1 — SudoFixIt.local Lab Setup  " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor DarkCyan
Write-Host ""

# ── Step 1: Verify the adapter exists ─────────────────────────────────────────
Write-Status "Checking for network adapter: '$AdapterName'..." -Type Info

try {
    $adapter = Get-NetAdapter -Name $AdapterName -ErrorAction Stop
    Write-Status "Found adapter: $($adapter.Name) — Status: $($adapter.Status)" -Type Success
} catch {
    Write-Status "Adapter '$AdapterName' not found. Available adapters:" -Type Error
    Get-NetAdapter | Format-Table Name, Status, MacAddress -AutoSize
    Write-Host ""
    Write-Status "Re-run with: .\Set-LabDNS.ps1 -AdapterName `"<name>`"" -Type Warning
    exit 1
}

# ── Step 2: Disable IPv6 to prevent DNS override ──────────────────────────────
Write-Status "Disabling IPv6 on '$AdapterName' to prevent DNS override..." -Type Info

try {
    Disable-NetAdapterBinding -Name $AdapterName -ComponentID ms_tcpip6 -ErrorAction Stop
    Write-Status "IPv6 disabled on '$AdapterName'." -Type Success
} catch {
    Write-Status "Could not disable IPv6 (may already be disabled): $($_.Exception.Message)" -Type Warning
}

# ── Step 3: Set DNS to domain controller IP ───────────────────────────────────
Write-Status "Setting DNS server to $DCIPAddress..." -Type Info

try {
    Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ServerAddresses $DCIPAddress -ErrorAction Stop
    Write-Status "DNS set to $DCIPAddress on '$AdapterName'." -Type Success
} catch {
    Write-Status "Failed to set DNS: $($_.Exception.Message)" -Type Error
    exit 1
}

# ── Step 4: Flush DNS resolver cache ──────────────────────────────────────────
Write-Status "Flushing DNS resolver cache..." -Type Info

try {
    Clear-DnsClientCache -ErrorAction Stop
    Write-Status "DNS cache flushed." -Type Success
} catch {
    Write-Status "Failed to flush DNS cache: $($_.Exception.Message)" -Type Warning
}

# ── Step 5: Verify DNS resolves SudoFixIt.local ───────────────────────────────
Write-Host ""
Write-Status "Verifying DNS resolution for SudoFixIt.local..." -Type Info

try {
    $result = Resolve-DnsName -Name "SudoFixIt.local" -Server $DCIPAddress -ErrorAction Stop
    Write-Status "DNS resolution successful!" -Type Success
    Write-Host ""
    Write-Host "   Name:    $($result[0].Name)" -ForegroundColor White
    Write-Host "   Address: $($result[0].IPAddress)" -ForegroundColor White
} catch {
    Write-Status "DNS resolution failed: $($_.Exception.Message)" -Type Error
    Write-Status "Ensure the domain controller is running and reachable at $DCIPAddress" -Type Warning
    Write-Host ""
    Write-Status "Try: ping $DCIPAddress" -Type Info
    exit 1
}

# ── Step 6: Verify connectivity to the domain controller ──────────────────────
Write-Host ""
Write-Status "Testing connectivity to domain controller at $DCIPAddress..." -Type Info

$ping = Test-Connection -ComputerName $DCIPAddress -Count 2 -Quiet
if ($ping) {
    Write-Status "Domain controller is reachable." -Type Success
} else {
    Write-Status "Cannot ping $DCIPAddress — check UTM network settings on both VMs." -Type Warning
}

# ── Summary ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "================================================" -ForegroundColor DarkCyan
Write-Host "   Configuration Complete                       " -ForegroundColor Green
Write-Host "================================================" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Adapter   : $AdapterName" -ForegroundColor White
Write-Host "  DNS Server: $DCIPAddress" -ForegroundColor White
Write-Host "  IPv6      : Disabled" -ForegroundColor White
Write-Host "  Domain    : SudoFixIt.local" -ForegroundColor White
Write-Host ""
Write-Status "Ready to join the domain. Run sysdm.cpl to proceed." -Type Success
Write-Host ""
