. Commands.ps1
function Init() {
    
     
}

function Write-Repos($config) {
        
    Write-Host "| Available Repositiories"
    
    foreach ($item in $config)
    {
        Write-Host "|  - "$item.name
    }
    
    Write-Host "| ------------------"
    Write-Host "| Usages:"
    Write-Host "|   (1) : cm Reposotory prs"
    Write-Host "|   (2) : cm Reposotory history"
    Write-Host "|   (2) : cm Reposotory branches"
    
}

function Get-SelectedItem($config) {
    foreach ($item in $config)
    {
        if($name -eq $item.name) {
            return $item
        }
    }
}

function Set-InitialConfig() {
    if(-not (Test-Path ~/.cmrc.json)) {
            Write-Host $PSScriptRoot
        cp $PSScriptRoot/CodeManagementConfigExample.json ~/.cmrc.json
    }
}

function Get-CMRCConfig() {
    return Get-Content ~/.cmrc.json | ConvertFrom-Json 
}

function CodeManagement() {
    
    # Attempt to set initial config
    Set-InitialConfig
    
    $config = Get-CMRCConfig
        
    if($args[0] -eq "list" -Or $args[0] -eq "help" ) {
        Write-Repos($config)
        return
    }
    
    # Setup arg variables
    $name = $args[0]
    $tab = $args[1]
    $shortHands = @{prs = "pullRequests"}
    
    if ($tab) {
        if($shortHands[$tab]) { $tab = $shortHands[$tab] }
    }
    
    # Get Selected Item
    $selected = Get-SelectedItem($config)
    
    # Generate URL
    if($selected) {
        $url = $selected.url
        Start-Process "${url}/${tab}"
    } else {
        Write-Host "No matching repositories"
    }
 
}

Set-Alias cm CodeManagement


Export-ModuleMember -Alias * -Function CodeManagement