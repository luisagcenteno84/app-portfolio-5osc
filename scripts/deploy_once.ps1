param(
  [Parameter(Mandatory=$true)] [string]$ProjectId,
  [string]$Region = "us-central1",
  [string]$BackendService = "app-portfolio-5osc-backend",
  [string]$FrontendService = "app-portfolio-5osc-frontend"
)

$ErrorActionPreference = "Stop"
$gcloud = "C:\Users\luisa\AppData\Local\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd"

& $gcloud config set project $ProjectId | Out-Null

& $gcloud builds submit --config cloudbuild.yaml --substitutions="_REGION=$Region,_BACKEND_SERVICE=$BackendService,_FRONTEND_SERVICE=$FrontendService"
if ($LASTEXITCODE -ne 0) { throw "Deployment build failed" }

$backendUrl = & $gcloud run services describe $BackendService --region $Region --format="value(status.url)"
if ($LASTEXITCODE -ne 0 -or -not $backendUrl) { throw "Backend service lookup failed" }

$frontendUrl = & $gcloud run services describe $FrontendService --region $Region --format="value(status.url)"
if ($LASTEXITCODE -ne 0 -or -not $frontendUrl) { throw "Frontend service lookup failed" }

Write-Host "Backend URL: $backendUrl"
Write-Host "Frontend URL: $frontendUrl"
