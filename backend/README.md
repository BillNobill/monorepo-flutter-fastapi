# FastAPI Backend 🚀

Guia passo a passo para configurar e rodar o backend do zero.

---

## 🐋 Opção 1: Rodar com Docker (Mais Rápido)

Se você tem o Docker instalado, este comando sobe tudo (**Python, dependências, migrations e servidor**):

```bash
cd backend
docker-compose up --build
```

- **O que acontece:** O Docker irá instalar tudo e rodar o `alembic upgrade head` automaticamente antes de iniciar o app.
- **API:** `http://localhost:8000`
- **Documentação Interativa (Swagger):** `http://localhost:8000/docs`

---

## 💻 Opção 2: Instalação Local (Desenvolvimento)

Siga esta ordem exata de comandos na primeira vez que clonar o projeto:

### 1. Entrar na pasta e configurar o Python
```bash
cd backend
pyenv install 3.11.9
pyenv local 3.11.9
```

### 2. Criar e Ativar Ambiente Virtual
**No Windows (PowerShell):**
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```
**No Linux/macOS:**
```bash
python -m venv .venv
source .venv/bin/activate
```

### 3. Instalar Dependências e Ferramentas
```bash
pip install pip-tools
pip-compile requirements.in
pip-sync requirements.txt
```

### 4. Configurar Variáveis de Ambiente
Crie um arquivo `.env` na raiz da pasta `backend/`. 

A `SECRET_KEY` é uma chave de segurança usada para criptografar os tokens de login (JWT). **Nunca a compartilhe.**

**Como gerar uma chave segura:**
Rode este comando no terminal e copie o resultado para o seu `.env`:
```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

**Exemplo de conteúdo do .env:**
```env
SECRET_KEY=resultado_do_comando_acima
ALGORITHM=HS256
```

### 5. Rodar as Migrations (Criar o Banco SQLite)
```bash
alembic upgrade head
```

### 6. Iniciar o Servidor
```bash
uvicorn app.main:app --reload
```

---

## 🛠️ Comandos Úteis (Cheat Sheet)

| Ação | Comando |
| :--- | :--- |
| **Instalar Dependências** | `pip-compile requirements.in; pip-sync requirements.txt` |
| **Iniciar Servidor** | `uvicorn app.main:app --reload` |
| **Aplicar Migrations** | `alembic upgrade head` |
| **Gerar Nova Migration** | `alembic revision --autogenerate -m "sua_mensagem"` |
| **Lint e Formatação** | `ruff check . --fix; ruff format .` |

---

## 🗄️ Como adicionar um novo Modelo/Tabela?

1.  Crie o arquivo em `app/models/novo_modelo.py`.
2.  **IMPORTANTE:** Importe este modelo dentro de `app/db/base.py` (senão o Alembic não o enxerga).
3.  Gere a migration:
    ```bash
    alembic revision --autogenerate -m "Adiciona tabela X"
    ```
4.  Aplique no banco:
    ```bash
    alembic upgrade head
    ```

---

## 🔒 Segurança e Auth

### Usuário Padrão (Seed)
Para criar um usuário admin inicial, rode:
```bash
python seed_db.py
```

**Credenciais padrão:**
- **Email:** `admin@admin.com`
- **Senha:** `admin`

- **Login:** `POST /api/v1/auth/login` (usa form-data com `username` e `password`).
- **Proteger Rota:** Adicione `current_user: User = Depends(deps.get_current_user)` nos parâmetros da sua função.
- **Admin Only:** Use `current_user: User = Depends(deps.get_current_admin_user)`.
