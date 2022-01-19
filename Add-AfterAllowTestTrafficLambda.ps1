param(
    [parameter(Mandatory = $true)]
    [string]$AppSpecFile,
    [parameter(Mandatory = $true)]
    [string]$EnvironmentName
)

# $AppSpecFile = $ {{ inputs.appspec-name }}
$s = Get-Content "./$($AppSpecFile)" | ConvertFrom-Json

if ($null -eq $s.Hooks) {
    Add-Member -InputObject $s -NotePropertyName "Hooks" -NotePropertyValue @()
}

# $EnvironmentName = $ {{ github.event.inputs.environment}}
$newHook = New-Object PSObject -Property @{ 
    "AfterAllowTestTraffic" = "$($EnvironmentName)-common-code-deploy-test-traffic"
}

$s.Hooks += $newHook

$s | ConvertTo-Json -Depth 100 | Set-Content "./$($AppSpecFile)"
