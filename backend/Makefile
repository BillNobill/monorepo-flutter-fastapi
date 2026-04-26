.PHONY: install run-dev lint migrate

install:
	pip install pip-tools
	pip-compile requirements.in
	pip-sync requirements.txt

run-dev:
	uvicorn app.main:app --reload

lint:
	ruff check . --fix
	ruff format .

migrate-init:
	alembic init alembic

migrate-revision:
	alembic revision --autogenerate -m "Initial migration"

migrate-up:
	alembic upgrade head
