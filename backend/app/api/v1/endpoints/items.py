from typing import Any, List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api import deps
from app.models.user import User

router = APIRouter()

@router.get("/", response_model=List[dict])
def read_items(
    db: Session = Depends(deps.get_db),
    current_user: User = Depends(deps.get_current_user),
) -> Any:
    """
    Retrieve items (Protected route).
    """
    return [{"id": 1, "title": "Protected Item", "owner_id": current_user.id}]
