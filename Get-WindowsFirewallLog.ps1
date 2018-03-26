<#
.SYNOPSIS
    Gives Output from windows firewall logs

.INPUTS
    Windows Firewall log file


.PARAMETER 
    -Date Gets logs from that date
    -DateStart 
        Has to be used with -DateEnd.  Gets the logs after or on a certain date.
        Format yyyy-MM-dd
    -DateEnd 
        Has to be used with -DateStart.  Gets the logs before or on a certain date.
        Format yyyy-MM-dd
    -StartTime 
        Has to be used with -EndTime.  Gets the logs after or on a certain Time.
        Format hh:mm:ss
    -EndTime 
        Has to be used with -StartTime.  Gets the logs before or on a certain Time.
        Format hh:mm:ss

.EXAMPLE
    .\Get-WindowsFirewallLog.ps1 -DateStart 2018-03-22 -DateEnd 2018-03-23 -StarTime 01:00:00 -EndTime 17:00:00 -FirewallLog c:\logs\domainprofile.log

.NOTES
    CREATE DATE:    2018-03-26
    CREATE AUTHOR:  Zackery Schwermer
#>

param (
    [String]$Date,
    [String]$DateStart,
    [String]$DateEnd,
    [String]$StartTime,
    [String]$EndTime,
    [Parameter(Mandatory = $true)]
    [String]$FirewallLog
)

if (!($Date)) {$Date = get-date -Format yyyy-MM-dd}
if ($DateStart) {
    if (!($DateEnd)) {
        Write-Host "Need DatEend"
        Exit
    }
}

if ($DateEnd) {
    if (!($DateStart)) {
        Write-Host "Need DateStart"
        Exit
    }
}

if ($StartTime) {
    if (!($EndTime)) {
        Write-Host "Need EndTime"
        Exit
    }
}

if ($EndTime) {
    if (!($StartTime)) {
        Write-Host "Need StartTime"
        Exit
    }
}

$FirewallLogObjects = import-csv -Path $FirewallLog -Delimiter " " -Header Date, Time, Action, Protocol, SourceIP, `
    DestinationIP, SourcePort, DestinationPort, Size, tcpflags, tcpsyn, tcpack, tcpwin, icmptype, icmpcode, info, path | `
    Where-Object {$_.date -match "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"}


if (($Datestart) -and ($Dateend)) {
    $FirewallLogObjects = $FirewallLogObjects | Where-Object {$_.Date -ge "$DateStart" -and $_.Date -le "$DateEnd"}
}
elseif ($Date) {
    $FirewallLogObjects = $FirewallLogObjects | Where-Object {$_.Date -eq "$Date"}
}

if (($StartTime) -and ($EndTime)) {
    $FirewallLogObjects = $FirewallLogObjects | Where-Object {$_.Time -ge "$StartTime" -and $_.Time -le "$EndTime"}
}

$FirewallLogObjects