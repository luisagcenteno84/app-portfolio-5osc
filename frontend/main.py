import os
from typing import Any, Dict

import httpx
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

app = FastAPI(title="App Portfolio Frontend", version="1.0.0")
templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")

BACKEND_URL = os.getenv("BACKEND_URL", "")


@app.get("/health")
def health() -> Dict[str, str]:
    return {"status": "ok", "service": "app-portfolio-5osc-frontend"}


@app.get("/api/v1/test")
async def api_test() -> Dict[str, Any]:
    if not BACKEND_URL:
        return {"status": "error", "message": "BACKEND_URL not configured"}

    endpoint = f"{BACKEND_URL.rstrip('/')}/api/v1/test"
    async with httpx.AsyncClient(timeout=20.0) as client:
        resp = await client.get(endpoint)
        resp.raise_for_status()
        data = resp.json()

    return {"status": "ok", "frontend": "app-portfolio-5osc-frontend", "backend_response": data}


@app.get("/", response_class=HTMLResponse)
async def index(request: Request) -> HTMLResponse:
    cards = [
        {
            "title": "Upcoming Sports Games",
            "status": "Live",
            "desc": "Track schedules, matchups, and game details in one place.",
            "url": "https://luisagcenteno84.github.io/upcoming-sports-games/",
        },
        {
            "title": "Thoughts Publisher",
            "status": "Beta",
            "desc": "Draft and publish short updates with clean formatting.",
            "url": "https://luisagcenteno84.github.io/thoughts-publisher/",
        },
        {
            "title": "Task Priority Organizer",
            "status": "Build",
            "desc": "Prioritize work with AI-assisted ranking and focus views.",
            "url": "https://luisagcenteno84.github.io/task-priority-organizer/",
        },
    ]

    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "title": "Luis Centeno | App Portfolio",
            "subtitle": "A curated collection of projects in active development",
            "cards": cards,
        },
    )

