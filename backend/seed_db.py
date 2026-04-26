import sys
import os

# Adiciona o diretório atual ao sys.path para importar o app
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.db.session import SessionLocal
from app.repositories.user import user_repo
from app.schemas.user import UserCreate

def seed():
    db = SessionLocal()
    try:
        # Verifica se já existe um admin
        user = user_repo.get_by_email(db, email="admin@admin.com")
        if not user:
            print("Criando usuário admin padrão...")
            user_in = UserCreate(
                email="admin@admin.com",
                password="admin",
                full_name="Admin User",
                role="admin"
            )
            user_repo.create(db, obj_in=user_in)
            print("Usuário admin criado com sucesso!")
        else:
            print("Usuário admin já existe.")
    finally:
        db.close()

if __name__ == "__main__":
    seed()
