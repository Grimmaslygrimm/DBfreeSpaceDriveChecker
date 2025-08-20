[CmdletBinding()]
param(

    [Parameter(
        Mandatory=$true,
        HelpMessage="Prod or Stage?"
    )]
    [string]$prodOrStage,
    
    [Parameter(
        Mandatory=$true,
        HelpMessage="Choose servers: "
    )]
    [ValidateSet("Stage", "Prod", "All")]
    [string[]]$SelectedServerGroups,

    [Parameter()]
    [PSCredential]
    $cred = (Get-Credential -Message "Enter your credentials")

)

if ($prodOrStage -ieq "stage") {
    $ServerGroupsMap = @{
        Stage = @("Example_Stage_Server")
    }
} else {
    $ServerGroupsMap = @{
        Prod = @("Example_Prod_Server")
    }
}

$SelectedDBs = @()

if ($SelectedServerGroups -contains "All") {
    foreach ($group in $ServerGroupsMap.Values) {
        $SelectedDBs += $group
    }
} 

else {
    foreach ($group in $SelectedServerGroups) {
        if ($ServerGroupsMap.ContainsKey($group)) {
            $SelectedDBs += $ServerGroupsMap[$group]
        } else {
            Write-Warning "Server group '$group' not found"
        }
    }
}

Write-Host "Selected servers: $($SelectedDBs -join ', ')" -ForegroundColor Yellow
Write-Host "Total count: $($SelectedDBs.Count)" -ForegroundColor Yellow

function Get-DBfreeSpace {
    param (
    )
    try {
        $result = Get-CimInstance -ClassName Win32_LogicalDisk | 
            Where-Object {$_.DriveType -eq 3} | 
            Select-Object DeviceID, 
                @{Name="Size(GB)"; Expression={[math]::Round($_.Size /1GB, 2)}},
                @{Name="FreeSpace(GB)"; Expression={[math]::Round($_.FreeSpace /1GB, 2)}} |
            Select-Object DeviceID, "Size(GB)", "FreeSpace(GB)"
    
        $result | Format-Table -AutoSize
    
    } catch {
        Write-Host "Error executing $db free space command: $($_.Exception.Message)" -ForegroundColor Red
    }
}

foreach ($db in $SelectedDBs) {
    
    try {
        
        $session = New-PSSession -ComputerName $db -Credential $cred

        Write-Host "$db : " -ForegroundColor Green
        Invoke-Command -Session $session -ScriptBlock ${function:Get-DBfreeSpace}
        Write-Host

    } catch {

        Write-Host "Error Processing $db : $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Continuing..." -ForegroundColor Yellow

    } finally {

        if ($session) {
            Remove-PSSession $session
        }

    }

}
Write-Host
Write-Host "All server operations complete"
Read-Host -Prompt "Enter to Exit: "