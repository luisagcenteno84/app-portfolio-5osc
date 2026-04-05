param(
  [Parameter(Mandatory=$true)] [string]$ProjectId,
  [string]$Region = "us-central1",
  [string]$BackendService = "app-portfolio-backend",
  [string]$FrontendService = "app-portfolio-frontend"
)

$ErrorActionPreference = "Stop"
$gcloud = "C:\Users\luisa\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd"

& $gcloud config set project $ProjectId | Out-Null

& $gcloud builds submit --config cloudbuild.yaml --substitutions="_REGION=$Region,_BACKEND_SERVICE=$BackendService,_FRONTEND_SERVICE=$FrontendService"

$backendUrl = & $gcloud run services describe $BackendService --region $Region --format="value(status.url)"
$frontendUrl = & $gcloud run services describe $FrontendService --region $Region --format="value(status.url)"

Write-Host "Backend URL: $backendUrl"
Write-Host "Frontend URL: $frontendUrl"