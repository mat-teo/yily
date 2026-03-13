# schemas/reason.py
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class ReasonCreate(BaseModel):
    content: str = Field(..., min_length=5, max_length=500)

class ReasonOut(BaseModel):
    id: int
    from_user_id: int
    to_user_id: int
    content: str
    created_at: datetime

    class Config:
        from_attributes = True

class ReasonUpdate(BaseModel):
    content: str | None = None