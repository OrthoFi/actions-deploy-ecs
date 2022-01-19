$fileName = $ {{ inputs.appspec-name }}
$s = Get-Content "./$($fileName)" | ConvertFrom-Json

if ($null -eq $s.Hooks) {
    Add-Member -InputObject $s -NotePropertyName "Hooks" -NotePropertyValue @()
}

$environmentName = $ {{ github.event.inputs.environment}}
$newHook = New-Object PSObject -Property @{ 
    "AfterAllowTestTraffic" = "$($environmentName)-common-code-deploy-test-traffic"
}

$s.Hooks += $newHook

$s | ConvertTo-Json -Depth 100 | Set-Content "./$($fileName)"
