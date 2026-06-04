<#
.SYNOPSIS
    Queries the Security event log for failed logon attempts (Event ID 4625).

.DESCRIPTION
    Searches the Windows Security event log on a local or remote machine for
    failed logon events (Event ID 4625). Outputs a formatted report showing
    the time, username, logon type, source IP, and failure reason for each
    event. Useful for identifying brute force attempts, mistyped credentials,
    and locked accounts in the SudoFixIt.local domain.

.PARAMETER ComputerName
    The computer to query. Defaults to the local machine.
    Use the domain controller IP or name to query domain logon failures.

.PARAMETER Hours
    How many hours back to search. Defaults to 24 hours.

.PARAMETER MaxEvents
    Maximum number of events to return. Defaults to 50.

.PARAMETER ExportCSV
    Optional path to export results as a CSV file.
    Example: -ExportCSV "C:\Reports\FailedLogons.csv"

.EXAMPLE
    .\Get-FailedLogons.ps1

.EXAMPLE
    .\Get-FailedLogons.ps1 -Hours 48 -MaxEvents 100

.EXAMPLE
    .\Get-FailedLogons.ps1 -ComputerName 192.168.64.3 -ExportCSV "C:\Reports\FailedLogons.csv"

.NOTES
    Author:   SudoFixIt Lab
    Requires: Run as Administrator
    Domain:   SudoFixIt.local

    Common Logon Type codes:
      2  = Interactive (local console)
      3  = Network (mapped drives, shares)
      4  = Batch
      5  = Service
      7  = Unlock (screen saver unlock)
      8  = NetworkCleartext
      10 = RemoteInteractive (RDP)
      11 = CachedInteractive

    Common Failure Reason codes:
      0xC000006A = Wrong password
      0xC0000064 = Username does not exist
      0xC000006D = Bad username or password
      0xC000006E = Account restriction
      0xC000006F = Outside logon hours
      0xC0000070 = Workstation restriction
      0xC0000071 = Expired password
      0xC0000072 = Account disabled
      0xC0000193 = Account expired
      0xC0000234 = Account locked out
#>

[CmdletBinding()]
param (
    [string]$ComputerName = $env:COMPUTERNAME,
    [int]$Hours = 24,
    [int]$MaxEvents = 50,
    [string]$ExportCSV = ""
)

# ── Logon type lookup table ────────────────────────────────────────────────────
$LogonTypes = @{
    2  = "Interactive (Console)"
    3  = "Network"
    4  = "Batch"
    5  = "Service"
    7  = "Unlock"
    8  = "NetworkCleartext"
    10 = "RemoteInteractive (RDP)"
    11 = "CachedInteractive"
}

# ── Failure reason lookup table ────────────────────────────────────────────────
$FailureReasons = @{
    "0xC000006A" = "Wrong password"
    "0xC0000064" = "Username does not exist"
    "0xC000006D" = "Bad username or password"
    "0xC000006E" = "Account restriction"
    "0xC000006F" = "Outside allowed logon hours"
    "0xC0000070" = "Workstation restriction"
    "0xC0000071" = "Password expired"
    "0xC0000072" = "Account disabled"
    "0xC0000193" = "Account expired"
    "0xC0000234" = "Account locked out"
}

# ── Require Administrator ──────────────────────────────────────────────────────
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[-] This script must be run as Administrator. Exiting." -ForegroundColor Red
    exit 1
}

# ── Header ─────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=============================================" -ForegroundColor DarkRed
Write-Host "   Get-FailedLogons.ps1 — SudoFixIt.local   " -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor DarkRed
Write-Host ""
Write-Host "  Computer : $ComputerName" -ForegroundColor White
Write-Host "  Searching: Last $Hours hours" -ForegroundColor White
Write-Host "  Max events: $MaxEvents" -ForegroundColor White
Write-Host ""

# ── Build the time filter ──────────────────────────────────────────────────────
$StartTime = (Get-Date).AddHours(-$Hours)

Write-Host "[*] Querying Security event log for Event ID 4625..." -ForegroundColor Cyan

# ── Query the event log ────────────────────────────────────────────────────────
try {
    $Events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{
        LogName   = "Security"
        Id        = 4625
        StartTime = $StartTime
    } -MaxEvents $MaxEvents -ErrorAction Stop
} catch [System.Exception] {
    if ($_.Exception.Message -match "No events were found") {
        Write-Host "[+] No failed logon events found in the last $Hours hours." -ForegroundColor Green
        Write-Host ""
        Write-Host "    Tips:" -ForegroundColor Yellow
        Write-Host "    - Ensure audit policies are enabled: secpol.msc -> Audit Policy" -ForegroundColor Yellow
        Write-Host "    - Run: auditpol /get /category:`"Account Logon`"" -ForegroundColor Yellow
        Write-Host "    - Try a failed login attempt first to generate events" -ForegroundColor Yellow
        exit 0
    } else {
        Write-Host "[-] Error querying event log: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

Write-Host "[+] Found $($Events.Count) failed logon event(s)." -ForegroundColor Green
Write-Host ""

# ── Parse each event ───────────────────────────────────────────────────────────
$Results = foreach ($Event in $Events) {
    $XML = [xml]$Event.ToXml()
    $EventData = $XML.Event.EventData.Data

    # Extract fields by name
    $Username     = ($EventData | Where-Object { $_.Name -eq "TargetUserName" }).'#text'
    $Domain       = ($EventData | Where-Object { $_.Name -eq "TargetDomainName" }).'#text'
    $LogonTypeRaw = ($EventData | Where-Object { $_.Name -eq "LogonType" }).'#text'
    $SourceIP     = ($EventData | Where-Object { $_.Name -eq "IpAddress" }).'#text'
    $SourcePort   = ($EventData | Where-Object { $_.Name -eq "IpPort" }).'#text'
    $StatusCode   = ($EventData | Where-Object { $_.Name -eq "SubStatus" }).'#text'
    $WorkStation  = ($EventData | Where-Object { $_.Name -eq "WorkstationName" }).'#text'

    # Resolve logon type
    $LogonTypeInt = [int]$LogonTypeRaw
    $LogonTypeStr = if ($LogonTypes.ContainsKey($LogonTypeInt)) {
        $LogonTypes[$LogonTypeInt]
    } else { "Unknown ($LogonTypeRaw)" }

    # Resolve failure reason
    $ReasonStr = if ($FailureReasons.ContainsKey($StatusCode)) {
        $FailureReasons[$StatusCode]
    } else { "Unknown ($StatusCode)" }

    # Skip machine accounts (ending in $)
    if ($Username -match '\$$') { continue }

    [PSCustomObject]@{
        Time          = $Event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
        Username      = "$Domain\$Username"
        LogonType     = $LogonTypeStr
        SourceIP      = if ($SourceIP -eq "-") { "Local" } else { $SourceIP }
        SourcePort    = if ($SourcePort -eq "-") { "-" } else { $SourcePort }
        Workstation   = $WorkStation
        FailureReason = $ReasonStr
    }
}

# ── Display results ────────────────────────────────────────────────────────────
if ($Results) {
    $Results | Format-Table -AutoSize -Wrap

    # ── Summary by username ────────────────────────────────────────────────────
    Write-Host ""
    Write-Host "── Summary by username ───────────────────────" -ForegroundColor DarkCyan
    $Results | Group-Object Username | Sort-Object Count -Descending |
        Select-Object @{N="Username";E={$_.Name}}, @{N="Failed Attempts";E={$_.Count}} |
        Format-Table -AutoSize

    # ── Summary by source IP ───────────────────────────────────────────────────
    Write-Host "── Summary by source IP ──────────────────────" -ForegroundColor DarkCyan
    $Results | Group-Object SourceIP | Sort-Object Count -Descending |
        Select-Object @{N="Source IP";E={$_.Name}}, @{N="Failed Attempts";E={$_.Count}} |
        Format-Table -AutoSize

    # ── Export to CSV if requested ─────────────────────────────────────────────
    if ($ExportCSV -ne "") {
        try {
            $Results | Export-Csv -Path $ExportCSV -NoTypeInformation -Encoding UTF8
            Write-Host "[+] Report exported to: $ExportCSV" -ForegroundColor Green
        } catch {
            Write-Host "[-] Failed to export CSV: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
} else {
    Write-Host "[+] No user account failed logon events found (machine accounts excluded)." -ForegroundColor Green
}

Write-Host ""
Write-Host "[*] Scan complete. Total events processed: $($Events.Count)" -ForegroundColor Cyan
Write-Host ""
