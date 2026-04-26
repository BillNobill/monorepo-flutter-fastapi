# Stage 1: Build
FROM python:3.11-slim as builder

WORKDIR /app
COPY requirements.in .
RUN pip install pip-tools && pip-compile requirements.in && pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /app/wheels /wheels
RUN pip install --no-cache /wheels/*

COPY . .

# Comando direto para rodar migrations e iniciar o app
CMD sh -c "alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port 8000"
