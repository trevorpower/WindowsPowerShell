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
      [String[]]$Id,
      [Parameter(
         Position=1,
         Mandatory=$false,
         ValueFromPipeline=$false,
         ValueFromPipelineByPropertyName=$true)
      ]
      [String[]]$Name
   )

   begin {
      Write-Progress -Activity "Getting PRs" -Status "0% Complete:" -PercentComplete 0;
      $repositories = @()
   }

   process {
      $repositories += $Id;

      if ($null -eq $Name)
      {
         $Name = $Id;
      }

      $names += $Name;
      $Name = $null;
   }

   end {

      Write-Progress -Activity "Fetching PRs" -PercentComplete 0;
      for ($counter=0; $counter -lt $repositories.Length;){
         (irm "https://tfs.kneat.org/tfs/DefaultCollection/_apis/git/repositories/{$($repositories[$counter])}/pullRequests"  -UseDefaultCredentials).value
         $percent = (++$counter / $repositories.Length) * 100;
         Write-Progress -Activity "Getting PRs" -PercentComplete $percent -CurrentOperation $names[$counter]
      }

      Write-Progress -Activity "Getting PRs" -Completed
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