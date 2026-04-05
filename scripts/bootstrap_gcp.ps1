param(
  [Parameter(Mandatory=$true)] [string]$ProjectId,
  [string]$Region = "us-central1",
  [string]$ArtifactRepo = "app-images",
  [string]$FirestoreCollection = "items",
  [string]$FirestoreLocation = "nam5"
)

$ErrorActionPreference = "Stop"
$gcloud = "C:\Users\luisa\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd"

& $gcloud config set project $ProjectId | Out-Null

$apis = @(
  "run.googleapis.com",
  "cloudbuild.googleapis.com",
  "artifactregistry.googleapis.com",
  "firestore.googleapis.com",
  "iam.googleapis.com"
)
& $gcloud services enable $apis --project $ProjectId

$repoExists = & $gcloud artifacts repositories list --location $Region --filter="name~$ArtifactRepo" --format="value(name)"
if (-not $repoExists) {
  & $gcloud artifacts repositories create $ArtifactRepo --repository-format=docker --location=$Region --description="Docker images for $ProjectId"
}

$dbType = & $gcloud firestore databases list --project $ProjectId --format="value(type)"
if (-not $dbType) {
  & $gcloud firestore databases create --location=$FirestoreLocation --type=firestore-native --project=$ProjectId
}

Write-Host "Bootstrap completed for project $ProjectId"