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

function Write-PrVote($vote){
  switch($vote){
    0 {  Write-Host " - " -nonewline; break  }
    -5 {  Write-Host -ForegroundColor "Black" -BackgroundColor "Yellow" "(?)" -nonewline; break  }
    5 {  Write-Host -ForegroundColor "Black" -BackgroundColor "Green" "(?)" -nonewline; break  }
    10 {  Write-Host -ForegroundColor "Black" -BackgroundColor "Green" "($([char]0x2713))" -nonewline; break  }
    default { Write-Host $_ -nonewline }
  }
}


function Write-Pr($pr){
  $id = $pr.pullRequestId
  $repo = $pr.repository.name
  $project = $pr.repository.project.name
  Write-Host -ForegroundColor "White" "$id | $($pr.title)"
  Write-Host $pr.createdBy.displayName (Get-Date $pr.creationDate)
  Write-Host -ForegroundColor "Cyan" "https://tfs.kneat.org/tfs/DefaultCollection/$project/_git/$repo/pullrequest/$id"
  Write-Host "$($pr.sourceRefName.Substring(11)) -> $($pr.targetRefName.Substring(11))"
  Write-Host "----- Description -----"
  Write-Host $pr.description
  Write-Host "-----------------------"
  $pr.reviewers | %{
    Write-PrVote($_.vote)
    Write-Host " $($_.displayName)"
  }
}

function global:Read-PrCommand()
{
  $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  switch($key.VirtualKeyCode) {
    17 { 'none' }
    37 { 'prev' }
    38 { 'prev' }
    39 { 'next' }
    40 { 'next' }
    40 { 'next' }
    default {
      switch($key.Character) {
        '' {'none'}
        'q' { 'quit' }
        'k' { 'prev' }
        default {
          'next'
        }
      }
    }
  }
}

function global:Get-PullRequest([parameter(Position=0,Mandatory=$false)]$id,[switch]$force){
  if ($id -eq $null)
  {
    $idCol = @{Label="ID"; Expression={$_.pullRequestId}}
    $repo = @{Label="Repository"; Expression={$_.repository.name};}
    $branch = @{Label="Target Branch"; Expression={$_.targetRefName.Substring(11)}; Width=20}
    $title = @{Label="Title"; Expression={$_.title}}
    $creator = @{Label="Creator"; Expression={$_.createdBy.DisplayName}}

    if(!$script:repos -Or $force)
    {
       Write-Host "initialising repo list for first time use"
       $script:repos = @(irm "https://tfs.kneat.org/tfs/DefaultCollection/_apis/git/repositories" -UseDefaultCredentials).value.id
    }

    $prs = $script:repos |
    %{
      (irm "https://tfs.kneat.org/tfs/DefaultCollection/_apis/git/repositories/{$_}/pullRequests"  -UseDefaultCredentials).value
    }

    $current = 0
    $stop = $false
    $show = $true
    while(!$stop)
    {
      if ($current -ge $prs.length)
      {
        $stop = $true
        $show = $false
      }

      if($show) {
        cls
        Write-Pr $prs[$current]
        $show = $false
        Write-Host -NoNewLine ":"
      }

      switch(Read-PrCommand) {
        'quit' {
          $stop = $true
          Write-Host
        }
        'next' {
          $current++;
          $show = $true
        }
        'prev' {
          if ($current -gt 0){
            $current--; $show = $true
          }
          else {
            Write-Host -NoNewLine "`rAt First PR :"
          }
        }
      }
    }
  }
  else {
      Write-Pr (irm "https://tfs.kneat.org/tfs/DefaultCollection/_apis/git/pullRequests/$id"  -UseDefaultCredentials)
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
Set-Alias pr Show-PullRequest
Set-Alias pester Invoke-Pester
