# models/couple.py
from typing import List, Optional
from datetime import datetime
from sqlmodel import SQLModel, Field, Relationship


class Couple(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    token: str = Field(max_length=10, unique=True, index=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)

    users: List["User"] = Relationship(back_populates="couple")