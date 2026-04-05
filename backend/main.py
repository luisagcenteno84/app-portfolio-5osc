import os
from datetime import datetime, timezone
from typing import Any, Dict

from fastapi import FastAPI
from google.cloud import firestore

app = FastAPI(title="App Portfolio Backend", version="1.0.0")

COLLECTION = os.getenv("FIRESTORE_COLLECTION", "items")


def get_db_client() -> firestore.Client:
    return firestore.Client()


@app.get("/health")
def health() -> Dict[str, str]:
    return {"status": "ok", "service": "app-portfolio-backend"}


@app.get("/api/v1/test")
def api_test() -> Dict[str, Any]:
    doc_id = f"test-{int(datetime.now(tz=timezone.utc).timestamp())}"
    payload = {
        "message": "backend test ok",
        "created_at": datetime.now(tz=timezone.utc).isoformat(),
    }

    db = get_db_client()
    ref = db.collection(COLLECTION).document(doc_id)
    ref.set(payload)
    saved = ref.get()

    return {
        "status": "ok",
        "service": "app-portfolio-backend",
        "collection": COLLECTION,
        "doc_id": doc_id,
        "data": saved.to_dict(),
    }