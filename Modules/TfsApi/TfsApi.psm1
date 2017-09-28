function Get-TfsRepository()
{
   @(irm "https://tfs.kneat.org/tfs/DefaultCollection/_apis/git/repositories" -UseDefaultCredentials).value
}

function Get-TfsPullRequest{
   param(
      [Parameter(
         Position=0,
         Mandatory=$true,
         ValueFromPipeline=$true,
         ValueFromPipelineByPropertyName=$true)
      ]
      [String[]]$RepositoryId
   )

   process {
      foreach($id in $RepositoryId)
      {
         (irm "https://tfs.kneat.org/tfs/DefaultCollection/_apis/git/repositories/{$id}/pullRequests"  -UseDefaultCredentials).value
      }
   }
}

function Write-TfsPrVote($vote){
   switch($vote){
      0 {  Write-Host " - " -nonewline; break  }
      -5 {  Write-Host -ForegroundColor "Black" -BackgroundColor "Yellow" "(?)" -nonewline; break  }
      -10 {  Write-Host -ForegroundColor "Black" -BackgroundColor "Red" "(X)" -nonewline; break  }
      5 {  Write-Host -ForegroundColor "Black" -BackgroundColor "Green" "(?)" -nonewline; break  }
      10 {  Write-Host -ForegroundColor "Black" -BackgroundColor "Green" "($([char]0x2713))" -nonewline; break  }
      default { Write-Host $_ -nonewline }
   }
}

function Get-TfsPrUrl($pr){
   $id = $pr.pullRequestId
   $repo = $pr.repository.name
   $project = $pr.repository.project.name
   return "https://tfs.kneat.org/tfs/DefaultCollection/$project/_git/$repo/pullrequest/$id"
}


function Get-TfsCommit(){
   param(
      [Parameter(
         Position=0,
         Mandatory=$true,
         ValueFromPipeline=$true,
         ValueFromPipelineByPropertyName=$true)
      ]
      [object[]]$Repositories
   )

   process {
      $from = (Get-Date).AddDays(-14).ToString("s")


      foreach($repo in $Repositories)
      {
         $Body = @{
             fromDate = $from
         }

         $project = $repo.project.name
         $repositoryId = $repo.id

         $defaultBranch = $repo.defaultBranch

         if ($defaultBranch) {
            $Body.branch = ($repo.defaultBranch.split("/") | Select-Object -Last 1)
         }

         (irm "https://tfs.kneat.org/tfs/DefaultCollection/$project/_apis/git/repositories/$repositoryId/commits" -Method "GET" -Body $Body -UseDefaultCredentials).value
      }
   }
}



Export-ModuleMember -Alias * -Function *