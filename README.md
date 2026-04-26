# Monorepo Flutter & FastAPI

A monorepo setup for a full-stack application with a Flutter frontend and a FastAPI backend.

## 📁 Repository Structure

```text
.
├── apps/               # Mobile/Web applications (Flutter)
├── backend/            # FastAPI REST API (Python 3.11+)
├── docs/               # Architecture and design specs
├── GEMINI.md           # Instructional context for Gemini CLI
├── README.md           # This file
└── sync_models.py      # Utility: Sync Pydantic models to Dart classes

## 🛠️ Components

### Backend (FastAPI)
A production-ready REST API featuring:
- Layered Repository Pattern.
- Versioned API (v1).
- SQLAlchemy with SQLite & Alembic migrations.
- Pydantic v2 Settings and Schemas.
- Dockerized multi-stage builds.
- Automation via Makefile.

For setup and execution, see the [Backend README](./backend/README.md).

### Frontend (Flutter)
A foundational mobile app structure in `apps/mobile_app` featuring:
- Layered architecture (core/features).
- Dio networking and Provider state management.
- Dynamic Material 3 theming (seed-based).

### 🔄 Model Synchronization (`sync_models.py`)
This repository includes a utility to keep your frontend and backend types in sync automatically.

- **What it does:** Reads Pydantic schemas from `backend/app/schemas/` and generates equivalent Dart model classes in `apps/mobile_app/lib/core/models/`.
- **How to use:**
  ```bash
  python sync_models.py
  ```

## 🚀 Quick Execution

### Using Docker Compose
Run both frontend (when available) and backend:
```bash
docker-compose up --build
```
Currently, this only spins up the backend service on `localhost:8000`.

