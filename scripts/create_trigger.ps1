param(
  [Parameter(Mandatory=$true)] [string]$ProjectId,
  [Parameter(Mandatory=$true)] [string]$GitHubOwner,
  [Parameter(Mandatory=$true)] [string]$RepoName,
  [Parameter(Mandatory=$true)] [string]$TriggerName,
  [string]$Branch = "^main$",
  [string]$BuildConfig = "cloudbuild.yaml"
)

$ErrorActionPreference = "Stop"
$gcloud = "C:\Users\luisa\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd"

& $gcloud config set project $ProjectId | Out-Null

$existing = & $gcloud builds triggers list --format="value(id,name)" | Select-String -Pattern "\s$TriggerName$" | ForEach-Object { ($_ -split '\s+')[0] }
if ($existing) {
  & $gcloud builds triggers delete $existing --quiet
  if ($LASTEXITCODE -ne 0) { throw "Failed deleting existing trigger $TriggerName" }
}

& $gcloud builds triggers create github `
  --name=$TriggerName `
  --repo-owner=$GitHubOwner `
  --repo-name=$RepoName `
  --branch-pattern=$Branch `
  --build-config=$BuildConfig
if ($LASTEXITCODE -ne 0) { throw "Failed creating trigger $TriggerName" }

Write-Host "Trigger created: $TriggerName"
