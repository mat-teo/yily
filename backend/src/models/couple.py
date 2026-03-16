# models/couple.py
from typing import List, Optional
from datetime import datetime, date
from sqlmodel import SQLModel, Field, Relationship


class Couple(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    token: str = Field(max_length=10, unique=True, index=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    anniversary_date: Optional[date] = Field(default=None)
    users: List["User"] = Relationship(back_populates="couple")