<#
.SYNOPSIS
    Removes default GitHub labels from a specified GitHub repository.
.DESCRIPTION
    This script connects to a specified GitHub repository using the GitHub CLI and removes all default labels that are present in the repository.
.PARAMETER RepositoryOrgAndName 
    The organization and repository name in the format <OrgName>/<RepoName>.
.EXAMPLE
    . .\Remove-DefaultGitHubLabels.ps1 # Dot source the script/functions
    Remove-DefaultGitHubLabels -RepositoryOrgAndName "my-org/my-repo"

    This command removes all default GitHub labels from the repository "my-repo" under the organization "my-org".
#>

function Remove-DefaultGitHubLabels {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]$RepositoryOrgAndName
  )

  Confirm-GitHubCliInstalledAndAuthenticated -RepositoryOrgAndName $RepositoryOrgAndName

  Confirm-GitHubRepositoryExists -RepositoryOrgAndName $RepositoryOrgAndName

  $DefaultLabels = Get-GitHubDefaultLabelsFromRepo -RepositoryOrgAndName $RepositoryOrgAndName

  if ($DefaultLabels.Length -ge 1) {
    Remove-GitHubLabelsFromRepo -RepositoryOrgAndName $RepositoryOrgAndName -LabelsToRemove $DefaultLabels
    Write-Host "Removed $($DefaultLabels.Length) default labels from the GitHub repository $($RepositoryOrgAndName)." -ForegroundColor Green
  }
  else {
    Write-Host "No default labels found in the GitHub repository $($RepositoryOrgAndName). Nothing to remove." -ForegroundColor Yellow
  }
}

## Helper Functions
function Confirm-GitHubCliInstalledAndAuthenticated {
  # Check if the GitHub CLI is installed
  $GitHubCliInstalled = Get-Command gh -ErrorAction SilentlyContinue
  if ($null -eq $GitHubCliInstalled) {
    throw "The GitHub CLI is not installed. Please install the GitHub CLI and try again."
  }
  Write-Host "The GitHub CLI is installed..." -ForegroundColor Green

  # Check if GitHub CLI is authenticated
  $GitHubCliAuthenticated = gh auth status
  if ($null -eq $GitHubCliAuthenticated) {
    throw "Not authenticated to GitHub. Please authenticate to GitHub using the GitHub CLI, `gh auth login`, and try again."
  }
  Write-Host "Authenticated to GitHub..." -ForegroundColor Green
}

function Confirm-GitHubRepositoryExists {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]$RepositoryOrgAndName
  )

  # Check if GitHub repository name is valid
  $GitHubRepositoryNameValid = $RepositoryOrgAndName -match "^[a-zA-Z0-9-]+/[a-zA-Z0-9-]+$"
  if ($false -eq $GitHubRepositoryNameValid) {
    throw "The GitHub repository name $($RepositoryOrgAndName) is not valid. Please check the repository name and try again. The format must be <OrgName>/<RepoName>"
  }

  # List GitHub repository provided and check it exists
  $GitHubRepository = gh repo view $RepositoryOrgAndName
  if ($null -eq $GitHubRepository) {
    throw "The GitHub repository $($RepositoryOrgAndName) does not exist. Please check the repository name and try again."
  }
  Write-Host "The GitHub repository $($RepositoryOrgAndName) exists..." -ForegroundColor Green
}

function Get-GitHubDefaultLabelsFromRepo {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]$RepositoryOrgAndName
  )

  $GhLabelsFromRepoRaw = gh label list --repo $RepositoryOrgAndName --limit 999 --json name,isDefault
  $GhLabelsFromRepo = $GhLabelsFromRepoRaw | ConvertFrom-Json

  $FilteredDefaultLabels = $GhLabelsFromRepo | Where-Object { $_.isDefault -eq $true }

  return $FilteredDefaultLabels
}

function Remove-GitHubLabelsFromRepo {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]$RepositoryOrgAndName,

    [Parameter(Mandatory = $true)]
    [object[]]$LabelsToRemove
  )

  foreach ($Label in $LabelsToRemove) {
    gh label delete -R $RepositoryOrgAndName $Label.name --yes
    Write-Host "Removed label: $($Label.name)" -ForegroundColor Green
  }
}