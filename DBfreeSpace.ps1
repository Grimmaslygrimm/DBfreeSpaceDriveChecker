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
    [ValidateSet("V2", "V4", "V6", "V7", "V9", "V10", 
    "V12", "V20", "V22", "V23",
     "Washington", "Temple", "Tampa",
      "St_Louis", "San_Juan", 
    "San_Antonio", "Orlando", "Martinsburg", 
    "Little_Rock", "Jackson", "Houston", "Denver", 
    "Bay_Pines", "Baltimore", "All")]
    [string[]]$SelectedServerGroups,

    [Parameter()]
    [PSCredential]
    $cred = (Get-Credential -Message "Enter your credentials")

)

if ($prodOrStage -ieq "stage") {
    $ServerGroupsMap = @{
        V2 = @("OITV03APPTHERAS.va.gov")
        V4 = @("OITV04APPTHERAS.va.gov")#, "OITV04APPTHERA2.va.gov")#, "OITV04APPTHERA3.va.gov",
        #"OITV04APPTHERA4.va.gov", "OITV04APPTHERA5.va.gov", "OITV04APPTHERAD.va.gov")
        V6 = @("OITV06APPTHERAS.va.gov")#, "OITV06APPTHERA2.va.gov")#, "OITV06APPTHERA3.va.gov", 
        #"OITV06APPTHERA4.va.gov", "OITV06DBSTHERAD.va.gov")
        V7 = @("OITV07APPTHERAS.va.gov")#, "OITV07APPTHERA2.va.gov")#, "OITV07DBSTHERAD.va.gov")
        V9 = @("OITV09APPTHERAS.va.gov")#, "OITV09APPTHERA2.va.gov")#, "OITV09APPTHERA3.va.gov", 
        #"OITV09APPTHERA4.va.gov", "OITV09DBSTHERAD.va.gov")
        V10 = @("OITV10APPTHERAS.va.gov")#, "OITV10APPTHERA2.va.gov")#, "OITV10DBSTHERAD.va.gov")
        V12 = @("OITV12APPTHERAS.va.gov")#, "OITV12APPTHERA2.va.gov")#, "OITV12APPTHERA4.va.gov", 
        #"OITV12APPTHERA5.va.gov", "OITV12DBSTHERAD.va.gov")
        V20 = @("OITV20APPTHERAS.va.gov")#, "OITV20APPTHERA2.va.gov")
        #, "OITV20APPTHERA3.va.gov", "OITV20APPTHERA4.va.gov", "OITV20DBSTHERAD.va.gov")
        V22 = @("OITAUSAPPTHV22S.va.gov")#, "OITV22APPThera2.VA.GOV")#, "OITV22APPThera3.VA.GOV"
        #, "OITV22DBSTHRAD2.VA.GOV"
        V23 = @("OITv23APPTheraS.va.gov")#, "OITV23APPThera2.va.gov")#, "OITV23APPThera3.va.gov"
        #, "OITV23APPThera4.va.gov", "OITV23APPThera5.va.gov", "OITv23APPTheraD.va.gov")
        Washington = @("OITBALAPPTHWASS.va.gov")
        Temple = @("OITCTXSTGTHERAS.va.gov")
        Tampa = @("OITORLSTGTHTAMS.va.gov")
        St_Louis = @("OITSTLAPPTHERAS.va.gov")
        San_Juan = @("OITORLAPPTHSAJS.va.gov")
        San_Antonio = @("OITSTXAPPTHERAS.VA.GOV")
        Orlando = @("OITORLAPPTHORLS.va.gov") 
        Martinsburg = @("OITBALAPPTHMWVS.va.gov")
        Little_Rock = @("OITLITSTGTHERAS.va.gov")
        Jackson = @("OITJACAPPTHERAS.va.gov")
        Houston = @("OITAUSAPPTHHOUS.va.gov")
        Denver = @("OITECHAPPTHERAS.VA.GOV")
        Bay_Pines = @("OITORLSTGTHBAYS.va.gov")
        Baltimore = @("OITBALAPPTHERS1.va.gov")
    }
} else {
    $ServerGroupsMap = @{
        V2 = @("OITV03DBSTHERAD.va.gov")
        V4 = @("OITV04APPTHERAD.va.gov")#, "OITV04APPTHERA2.va.gov")#, "OITV04APPTHERA3.va.gov",
        #"OITV04APPTHERA4.va.gov", "OITV04APPTHERA5.va.gov", "OITV04APPTHERAD.va.gov")
        V6 = @("OITV06DBSTHERAD.va.gov")#, "OITV06APPTHERA2.va.gov")#, "OITV06APPTHERA3.va.gov", 
        #"OITV06APPTHERA4.va.gov", "OITV06DBSTHERAD.va.gov")
        V7 = @("OITV07DBSTHERAD.va.gov")#, "OITV07APPTHERA2.va.gov")#, "OITV07DBSTHERAD.va.gov")
        V9 = @("OITV09DBSTHERAD.va.gov")#, "OITV09APPTHERA2.va.gov")#, "OITV09APPTHERA3.va.gov", 
        #"OITV09APPTHERA4.va.gov", "OITV09DBSTHERAD.va.gov")
        V10 = @("OITV10DBSTHERAD.va.gov")#, "OITV10APPTHERA2.va.gov")#, "OITV10DBSTHERAD.va.gov")
        V12 = @("OITV12DBSTHERAD.va.gov")#, "OITV12APPTHERA2.va.gov")#, "OITV12APPTHERA4.va.gov", 
        #"OITV12APPTHERA5.va.gov", "OITV12DBSTHERAD.va.gov")
        V20 = @("OITV20DBSTHERAD.va.gov")#, "OITV20APPTHERA2.va.gov")
        #, "OITV20APPTHERA3.va.gov", "OITV20APPTHERA4.va.gov", "OITV20DBSTHERAD.va.gov")
        V22 = @("OITV22DBSTHRAD2.VA.GOV")#, "OITV22APPThera2.VA.GOV")#, "OITV22APPThera3.VA.GOV"
        #, "OITV22DBSTHRAD2.VA.GOV"
        V23 = @("OITv23APPTheraD.va.gov")#, "OITV23APPThera2.va.gov")#, "OITV23APPThera3.va.gov"
        #, "OITV23APPThera4.va.gov", "OITV23APPThera5.va.gov", "OITv23APPTheraD.va.gov")
        Washington = @("OITBALAPPTHWASD.va.gov")
        Temple = @("OITCTXDBSTHERAD.va.gov")
        Tampa = @("OITORLDBSTHTAMD.va.gov")
        St_Louis = @("OITSTLAPPTHERAD.va.gov")
        San_Juan = @("OITORLDBSTHSAJD.va.gov")
        San_Antonio = @("OITSTXDBSTHERAD.VA.GOV")
        Orlando = @("OITORLDBSTHORLD.va.gov") 
        Martinsburg = @("OITBALAPPTHMWVD.va.gov")
        Little_Rock = @("OITLITDBSTHERAD.va.gov")
        Jackson = @("OITJACDBSTHERAD.va.gov")
        Houston = @("OITAUSDBSTHHOUD.va.gov")
        Denver = @("OITECHDBSTHERAD.VA.GOV")
        Bay_Pines = @("OITBALAPPTHERD1.va.gov")
        Baltimore = @("OITBALAPPTHERD1.va.gov")
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