function Write-HeadingOne ($heading)
{
   Write-Host -ForegroundColor "White" $heading
   Write-Host -ForegroundColor "White" ("=" * $heading.length)
}

function Write-HeadingTwo ($heading)
{
   Write-Host $heading
   Write-Host ("-" * $heading.length)
}

function Fetch-PullRequests {
   return $script:repos | Get-TfsPullRequest | Sort-Object pullRequestId
}

function Write-Pr($pr){
   $id = $pr.pullRequestId
   $repo = $pr.repository.name
   $project = $pr.repository.project.name
   $url = Get-TfsPrUrl($pr)
   Write-HeadingOne "$id | $($pr.title)"
   Write-Host "$project`:$repo"
   Write-Host -nonewline "$($pr.sourceRefName.Substring(11)) -> "
   Write-Host -ForegroundColor "White" $pr.targetRefName.Substring(11)
   Write-Host $pr.createdBy.displayName (Get-Date $pr.creationDate)
   Write-Host -ForegroundColor "Cyan" $url
   Write-Host
   Write-HeadingTwo "Description"
   Write-Host $pr.description
   Write-Host
   Write-HeadingTwo "Votes"
   $pr.reviewers | %{
      Write-TfsPrVote($_.vote)
      Write-Host " $($_.displayName)"
   }
}

function Read-PrCommand()
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
            'c' { 'checkout' }
            'k' { 'prev' }
            'q' { 'quit' }
            'r' { 'reload' }
            '?' { 'help' }
            'h' { 'help' }
            default {
             'next'
          }
       }
    }
 }
}

<#
 .Synopsis
  Iterate PRs.

 .Description
  Displays Pull Requests one at a time with keyboard navigation.

 .Example
   Pull-Requests
   23223 | fix for selection bug 12678
   ===================================
   example-project
   myFix -> master
      ...

   Description
   -----------
      ...

   Votes
   -----
      ...
   :

 .Example
   Pull-Requests -force
   initialising repo list for first time use
#>
function Get-PullRequest(
   # force the fetch of repositories
   [switch]$force
){
   $idCol = @{Label="ID"; Expression={$_.pullRequestId}}
   $repo = @{Label="Repository"; Expression={$_.repository.name};}
   $branch = @{Label="Target Branch"; Expression={$_.targetRefName.Substring(11)}; Width=20}
   $title = @{Label="Title"; Expression={$_.title}}
   $creator = @{Label="Creator"; Expression={$_.createdBy.DisplayName}}

   $current = 0
   $stop = $false
   $show = $true

   if(!$script:repos -Or $force)
   {
      Write-Host "initialising repo list for first time use"
      try {
         $script:repos = (Get-TfsRepository).id
      }
      catch {
         $stop = $true
         Write-Host -ForegroundColor "red" $_.Exception.Message
         Write-Host "failed to get repository list"
      }
   }

   if (!$stop)
   {
      $prs = Fetch-PullRequests
   }

   while(!$stop)
   {
      if($show) {
         cls
         Write-Pr $prs[$current]
         $show = $false
         Write-Host -NoNewLine "$($current + 1)/$($prs.length):"
      }

      switch(Read-PrCommand) {
         'quit' {
            $stop = $true
            Write-Host
         }
         'help' {
            Write-Host
            Write-Host " h : show this help"
            Write-Host " q : quit"
            Write-Host " r : reload - update all request all PRs and show first"
            Write-Host " j : show next PR"
            Write-Host " k : show previous PR"
            Write-Host " c : checkout branch in current directory"
            Write-Host -NoNewLine ":"
         }
         'next' {
            if ($current -lt $prs.length - 1){
               $current++;
               $show = $true
            }
            else {
               Write-Host -NoNewLine "`rAt Last PR :"
            }
         }
         'prev' {
            if ($current -gt 0){
               $current--;
               $show = $true
            }
            else {
               Write-Host -NoNewLine "`rAt First PR :"
            }
         }
         'checkout' {
            Write-Host
            git checkout $prs[$current].sourceRefName.Substring(11)
            Write-Host -nonewline ":"
         }
         'reload' {
            $show = $true
            $current = 0
            Write-Host -NoNewLine "`rReloading..."
            $prs = Fetch-PullRequests
         }
      }
   }
}