param(
  [Parameter(Mandatory=$true)] [string]$ProjectId,
  [Parameter(Mandatory=$true)] [string]$GitHubOwner,
  [Parameter(Mandatory=$true)] [string]$RepoName,
  [Parameter(Mandatory=$true)] [string]$TriggerName,
  [string]$Branch = "^main$",
  [string]$BuildConfig = "cloudbuild.yaml",
  [string]$Region = "global"
)

$ErrorActionPreference = "Stop"
$gcloud = "C:\Users\luisa\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd"

& $gcloud config set project $ProjectId | Out-Null

$existing = & $gcloud builds triggers list --filter="name=$TriggerName" --format="value(id)"
if ($existing) {
  & $gcloud builds triggers delete $existing --quiet
}

& $gcloud builds triggers create github `
  --name=$TriggerName `
  --repo-owner=$GitHubOwner `
  --repo-name=$RepoName `
  --branch-pattern=$Branch `
  --build-config=$BuildConfig `
  --region=$Region

Write-Host "Trigger created: $TriggerName"