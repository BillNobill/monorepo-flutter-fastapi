from typing import Optional
from pydantic import BaseModel, EmailStr, ConfigDict

class UserBase(BaseModel):
    email: Optional[EmailStr] = None
    is_active: Optional[bool] = True
    full_name: Optional[str] = None

class UserCreate(UserBase):
    email: EmailStr
    password: str
    full_name: str
    role: Optional[str] = "user"

class UserUpdate(UserBase):
    password: Optional[str] = None

class User(UserBase):
    id: int

    model_config = ConfigDict(from_attributes=True)

class UserResponse(UserBase):
    id: int
    role: str

    model_config = ConfigDict(from_attributes=True)
