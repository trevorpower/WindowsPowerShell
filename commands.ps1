function global:Pop-Directory(){
   Set-Location ..
}

function global:Reset-Directory(){
   Set-Location ~
}

function global:Find-Aliases($definition){
   Get-Alias -Definition *$definition*
}

function global:Stop-ProcessByName($name){
   Stop-Process -Name $name
}

function global:Stop-ProcessByName($name){
   Stop-Process -Name $name
}

function global:Connect-Machine($name){
   if ([IPAddress]::TryParse($name, [ref]$null)){
      mstsc /v:$name
   }
   elseif (-Not $name) {
      Get-ChildItem ~/.rdp | %{ $_.BaseName }
   }
   else {
      mstsc (Get-Item "~/.rdp/$name.rdp").Fullname
   }
}

function global:Restart-Machine(){
   shutdown /r /t 00
}

function global:Show-Content($file){
   sh -c "less $file"
}

function global:Start-Timer($minutes = 5, $message = "Times Up!"){
   $timer = New-Object System.Timers.Timer
   $timer.Interval = $minutes * 60 * 1000
   $timer.AutoReset = $false

   $action = {
      Write-Host
      Write-Host -foregroundcolor magenta "   ###    $($Event.MessageData)    ###"
   }

   Register-ObjectEvent -InputObject $timer -MessageData $message -EventName Elapsed -Action $action > $null

   $timer.Start()
}

function global:Get-Task(){
   tfpt query "git1601/My Queries/My Tasks" /collection:https://tfs.kneat.org/tfs/DefaultCollection /include:data
}

function global:Get-PullRequest(){
   @(irm "https://tfs.kneat.org/tfs/DefaultCollection/_apis/git/repositories" -UseDefaultCredentials).value.id |
   %{
       (irm "https://tfs.kneat.org/tfs/DefaultCollection/_apis/git/repositories/{$_}/pullRequests"  -UseDefaultCredentials).value
   }   |
   Group-Object {$_.repository.name} |
   %{
       Write-Host "Repository: " -foregroundcolor "gray" -NoNewline
       Write-Host $_.Name -foregroundcolor "white"
       Write-Host
       $_.Group | %{
           $_.reviewers | ?{ $_.uniqueName -eq "KNEATORG\trevor.power" } |
           %{ Write-Host $_.vote }
           Write-Host "$($_.pullRequestId)  $($_.title)" -foregroundcolor "white"
           Write-Host $_.url -foregroundcolor "cyan"
           Write-Host $_.sourceRefName.Substring(11) -> $_.targetRefName.Substring(11) -foregroundcolor "darkgray"
           Write-Host
       }
   }
}


Set-Alias ~ Reset-Directory
Set-Alias .. Pop-Directory
Set-Alias al Find-Aliases
Set-Alias cull Stop-ProcessByName
Set-Alias sync Sync-PSProfile
Set-Alias rdp Connect-Machine
Set-Alias restart Restart-Machine
Set-Alias less Show-Content
Set-Alias tea Start-Timer
Set-Alias ts Get-Task
Set-Alias prs Get-PullRequest
Set-Alias pester Invoke-Pester
