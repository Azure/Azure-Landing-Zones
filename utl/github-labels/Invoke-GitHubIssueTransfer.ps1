<#
.SYNOPSIS
  Transfers all open GitHub issues from a list of GitHub repositories to another, single, repository in the same organization/user.

.DESCRIPTION
  This script connects to specified GitHub repositories using the GitHub CLI and transfers all open issues from those repositories to a target repository. It optionally adds a label to the transferred issues indicating their source repository, if provided in the SourceRepositoriesOrgAndNameObject. These labels can be customized per source repository and should already exist in the target repository. The script includes automatic retry logic with exponential backoff to handle transient errors such as HTTP 404s, rate limits, or temporary network issues.

.PARAMETER SourceRepositoriesOrgAndNameObject
  An array of hashtables or PSCustomObjects containing repository information. Each entry must have a 'RepositoryOrgAndName' property in the format <OrgName>/<RepoName> and optionally a 'LabelToApply' property to specify which label should be added to transferred issues. If 'LabelToApply' is provided and the -AddSourceRepoLabel switch is used, that label will be applied to all issues transferred from that repository.

  The structure of the object should be as follows:
  @(
    @{ RepositoryOrgAndName = "my-org/repo-1"; LabelToApply = "Transfer From: repo-1" }
    @{ RepositoryOrgAndName = "my-org/repo-2"; LabelToApply = "Transfer From: repo-2" }
  )

.PARAMETER TargetRepositoryOrgAndName
  The organization and repository name in the format <OrgName>/<RepoName> representing the target repository to which issues will be transferred.

.PARAMETER AddSourceRepoLabel
  A switch parameter that, when specified, enables label addition to transferred issues. Labels are only applied to issues from repositories that have the 'LabelToApply' property defined in their source repository object. The label value is taken from the 'LabelToApply' property of each source repository object.

.PARAMETER MaxRetries
  The maximum number of retry attempts for failed operations (such as issue transfer or label addition) due to transient errors. Default is 3. Exponential backoff is applied between retries.

.PARAMETER RetryDelaySeconds
  The base delay in seconds between retry attempts. With exponential backoff, each retry waits longer (delay * attempt number). Default is 5 seconds.

.EXAMPLE
    . .\Invoke-GitHubIssueTransfer.ps1 # Dot source the script/functions
    $SourceRepos = @(
      @{ RepositoryOrgAndName = "my-org/repo-1"; LabelToApply = "Transfer From: repo-1" }
      @{ RepositoryOrgAndName = "my-org/repo-2"; LabelToApply = "Transfer From: repo-2" }
    )
    Invoke-GitHubIssueTransfer -SourceRepositoriesOrgAndNameObject $SourceRepos -TargetRepositoryOrgAndName "my-org/target-repo" -AddSourceRepoLabel

    This command transfers all open issues from "repo-1" and "repo-2" under the organization "my-org" to the target repository "target-repo". It adds labels indicating the source repository to transferred issues and uses default retry settings (3 retries with 5 second base delay).

.EXAMPLE
    . .\Invoke-GitHubIssueTransfer.ps1 # Dot source the script/functions
    $SourceRepos = @(
      @{ RepositoryOrgAndName = "my-org/repo-1"; LabelToApply = "Transfer From: repo-1" }
      @{ RepositoryOrgAndName = "my-org/repo-2"; LabelToApply = "Transfer From: repo-2" }
    )
    Invoke-GitHubIssueTransfer -SourceRepositoriesOrgAndNameObject $SourceRepos -TargetRepositoryOrgAndName "my-org/target-repo" -AddSourceRepoLabel -MaxRetries 5 -RetryDelaySeconds 10

    This command transfers all open issues with custom retry settings: 5 retry attempts with a 10 second base delay (exponential backoff will use 10s, 20s, 30s, 40s, 50s).

.EXAMPLE
    . .\Invoke-GitHubIssueTransfer.ps1 # Dot source the script/functions
    $SourceRepos = @(
      @{ RepositoryOrgAndName = "my-org/repo-1"; LabelToApply = "Transfer From: repo-1" }
      @{ RepositoryOrgAndName = "my-org/repo-2" }
    )
    Invoke-GitHubIssueTransfer -SourceRepositoriesOrgAndNameObject $SourceRepos -TargetRepositoryOrgAndName "my-org/target-repo" -AddSourceRepoLabel

    This command transfers all open issues from both repositories. Labels are only applied to issues from "repo-1" (which has LabelToApply defined), but not to issues from "repo-2" (which lacks the LabelToApply property).

.NOTES
    - Requires GitHub CLI (gh) to be installed and authenticated
    - Labels specified in LabelToApply must already exist in the target repository
    - The script validates repository names and existence before transferring issues
    - Both hashtable and PSCustomObject formats are supported for source repository objects
    - Automatic retry logic with exponential backoff helps handle transient errors
#>

function Invoke-GitHubIssueTransfer {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [object[]]$SourceRepositoriesOrgAndNameObject,

    [Parameter(Mandatory = $true)]
    [string]$TargetRepositoryOrgAndName,

    [Parameter(Mandatory = $false)]
    [switch]$AddSourceRepoLabel,

    [Parameter(Mandatory = $false)]
    [int]$MaxRetries = 3,

    [Parameter(Mandatory = $false)]
    [int]$RetryDelaySeconds = 5
  )

  Confirm-GitHubCliInstalledAndAuthenticated

  Confirm-GitHubRepositoryExists -RepositoryOrgAndName $TargetRepositoryOrgAndName

  foreach ($SourceRepo in $SourceRepositoriesOrgAndNameObject) {
    $SourceRepoOrgAndName = $SourceRepo.RepositoryOrgAndName
    $ShouldAddSourceLabel = $false
    
    # Handle both hashtables and PSCustomObjects
    if ($SourceRepo -is [hashtable]) {
      if ($SourceRepo.ContainsKey('LabelToApply') -and -not [string]::IsNullOrWhiteSpace($SourceRepo.LabelToApply)) {
        $ShouldAddSourceLabel = $true
      }
    } else {
      if ($SourceRepo.PSObject.Properties.Name -contains 'LabelToApply' -and -not [string]::IsNullOrWhiteSpace($SourceRepo.LabelToApply)) {
        $ShouldAddSourceLabel = $true
      }
    }

    Confirm-GitHubRepositoryExists -RepositoryOrgAndName $SourceRepoOrgAndName

    Invoke-TransferGitHubIssuesBetweenRepos -SourceRepositoryOrgAndName $SourceRepoOrgAndName -TargetRepositoryOrgAndName $TargetRepositoryOrgAndName -AddSourceRepoLabel:($AddSourceRepoLabel -and $ShouldAddSourceLabel) -SourceRepoLabelValue:($SourceRepo.LabelToApply) -MaxRetries $MaxRetries -RetryDelaySeconds $RetryDelaySeconds
  }
}

function Invoke-TransferGitHubIssuesBetweenRepos {
  param (
    [Parameter(Mandatory = $true)]
    [string]$SourceRepositoryOrgAndName,

    [Parameter(Mandatory = $true)]
    [string]$TargetRepositoryOrgAndName,

    [Parameter(Mandatory = $false)]
    [bool]$AddSourceRepoLabel = $false,

    [Parameter(Mandatory = $false)]
    [string]$SourceRepoLabelValue = "",

    [Parameter(Mandatory = $false)]
    [int]$MaxRetries = 3,

    [Parameter(Mandatory = $false)]
    [int]$RetryDelaySeconds = 5
  )

  $OpenIssuesRaw = gh issue list --repo $SourceRepositoryOrgAndName --state open --limit 999 --json number,title
  $OpenIssues = $OpenIssuesRaw | ConvertFrom-Json

  foreach ($Issue in $OpenIssues) {

    # Transfer issue with retry logic
    $transferCapture = Invoke-GitHubCommandWithRetry -ScriptBlock {
      gh issue transfer --repo $SourceRepositoryOrgAndName $Issue.number $TargetRepositoryOrgAndName
    } -OperationDescription "Transfer issue #$($Issue.number) from $($SourceRepositoryOrgAndName)" -MaxRetries $MaxRetries -RetryDelaySeconds $RetryDelaySeconds
    
    $transferredIssueNumber = $transferCapture.Split("/")[-1]

    Write-Host "Transferred issue #$($Issue.number) from $($SourceRepositoryOrgAndName) to $($TargetRepositoryOrgAndName) #$($transferredIssueNumber)." -ForegroundColor Green

    if ($AddSourceRepoLabel -and $SourceRepoLabelValue -ne "") {
      # After transferring, add the label to the issue in the target repository with retry logic
      Invoke-GitHubCommandWithRetry -ScriptBlock {
        gh issue edit --repo $TargetRepositoryOrgAndName $transferredIssueNumber --add-label "$SourceRepoLabelValue"
      } -OperationDescription "Add label to issue #$($transferredIssueNumber) in $($TargetRepositoryOrgAndName)" -MaxRetries $MaxRetries -RetryDelaySeconds $RetryDelaySeconds
      
      Write-Host "Added label '$SourceRepoLabelValue' to issue #$($transferredIssueNumber) in $($TargetRepositoryOrgAndName)." -ForegroundColor Green
    }
  }
}

# Helper Functions
function Invoke-GitHubCommandWithRetry {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [scriptblock]$ScriptBlock,

    [Parameter(Mandatory = $true)]
    [string]$OperationDescription,

    [Parameter(Mandatory = $false)]
    [int]$MaxRetries = 3,

    [Parameter(Mandatory = $false)]
    [int]$RetryDelaySeconds = 5
  )

  $attempt = 0
  $success = $false
  $result = $null

  while (-not $success -and $attempt -lt $MaxRetries) {
    $attempt++
    try {
      $result = & $ScriptBlock
      $success = $true
    }
    catch {
      if ($attempt -lt $MaxRetries) {
        $delay = $RetryDelaySeconds * $attempt  # Exponential backoff
        Write-Host "Failed to $($OperationDescription) (Attempt $attempt/$MaxRetries). Error: $($_.Exception.Message). Retrying in $delay seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds $delay
      }
      else {
        Write-Host "Failed to $($OperationDescription) after $MaxRetries attempts. Error: $($_.Exception.Message)" -ForegroundColor Red
        throw
      }
    }
  }

  return $result
}

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