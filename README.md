# app-portfolio

Portfolio web app scaffold with FastAPI frontend + backend, Firestore integration, Cloud Build CI/CD, and Cloud Run deployment.

## Architecture

- `frontend/`: FastAPI UI service (responsive portfolio page + proxy test endpoint)
- `backend/`: FastAPI API service (`/health`, `/api/v1/test` with Firestore write/read)
- `cloudbuild.yaml`: Builds and deploys both services to Cloud Run
- `scripts/bootstrap_gcp.ps1`: Enables APIs, creates Artifact Registry + Firestore
- `scripts/create_trigger.ps1`: Creates GitHub push trigger for `main`
- `scripts/deploy_once.ps1`: Runs an immediate deployment via Cloud Build

## Local run

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r backend/requirements.txt -r frontend/requirements.txt
docker compose up --build
```

- Frontend: `http://localhost:8080`
- Backend: `http://localhost:8081`

## Required names

- Project ID: `app-portfolio`
- GitHub repo: `app-portfolio`
- Backend service: `app-portfolio-backend`
- Frontend service: `app-portfolio-frontend`
- Trigger: `app-portfolio-main-deploy`

## GCP bootstrap

```powershell
.\scripts\bootstrap_gcp.ps1 -ProjectId "app-portfolio" -Region "us-central1" -ArtifactRepo "app-images"
```

## Create trigger

```powershell
.\scripts\create_trigger.ps1 -ProjectId "app-portfolio" -GitHubOwner "luisagcenteno84" -RepoName "app-portfolio" -TriggerName "app-portfolio-main-deploy"
```

## Deploy now

```powershell
.\scripts\deploy_once.ps1 -ProjectId "app-portfolio" -Region "us-central1" -BackendService "app-portfolio-backend" -FrontendService "app-portfolio-frontend"
```

## Validate

```powershell
curl "$BACKEND_URL/health"
curl "$BACKEND_URL/api/v1/test"
curl "$FRONTEND_URL/health"
curl "$FRONTEND_URL/api/v1/test"
```

## AI runbook

1. Confirm `gh auth status` and `gcloud auth list`.
2. Ensure repo and project IDs stay identical.
3. Run bootstrap script once per project.
4. Create trigger for `main` branch.
5. Use deploy script for first release.
6. Validate all four endpoints after deployment.
7. If Firestore test fails, check IAM + Firestore database initialization.