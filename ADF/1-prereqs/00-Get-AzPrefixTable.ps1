$PrefixLookup = @{}
$subscriptionId = Get-AzContext | ForEach-Object Subscription | ForEach-Object Id
$URI = "https://management.azure.com/subscriptions/$subscriptionId/locations?api-version=2020-01-01"
$locations = Invoke-AzRestMethod $URI | ForEach-Object Content | ConvertFrom-Json | ForEach-Object value
Get-AzLocation | ForEach-Object {
    $parts = $_.displayname -split '\s'
    $location = $_.location
    
    # Build the Naming Standard based on the name parts, then prefix with A for Azure
    $NameFormat = $($Parts[0][0] + $Parts[1][0] ) + $(if ($parts[2]) { $parts[2][0] }else { 1 })
    $Prefix = 'A' + $NameFormat

    # override the 3 duplicates, maintain new ones in this lookup as new regions come online
    $manualOverrides = @{
        'brazilsoutheast' = 'BSE'
        'northeurope'     = 'NEU'
        'westeurope'      = 'WEU'
    }

    $UsablePrefix = if ($manualOverrides[$location]) { 'A' + $manualOverrides[$location] } else { $Prefix }
    
    $Current = [pscustomobject]@{
        displayname  = $_.displayname
        location     = $location
        first        = $Parts[0]
        second       = $parts[1]
        third        = $parts[2]
        Name         = $NameFormat
        NameOverRide = $manualOverrides[$location]
        PREFIX       = $UsablePrefix
        pairedRegion = $locations | Where-Object name -EQ $location | ForEach-Object metadata | ForEach-Object pairedRegion | ForEach-Object name
    }
    $Current
    
    # Only export limited propeties to json to limit size with loadtextcontext
    $PrefixLookup[$UsablePrefix] = $Current | Select-Object displayname, location, prefix, pairedRegion
} | Format-Table -AutoSize

$PrefixLookup | ConvertTo-Json | Set-Content -Path $PSScriptRoot\..\bicep\global\prefix.json

# Documentation for this is available here:
# https://brwilkinson.github.io/AzureDeploymentFramework/docs/Naming_Standards_Prefix.html

<#
- 3 Name overrides are currently in place
    - Brazil Southeast    BS1 --> BSE
    - North Europe        NE1 --> NEU
    - West Europe         WE1 --> WEU
#>

