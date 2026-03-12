# models/user.py
from typing import Optional
from datetime import datetime
from sqlmodel import SQLModel, Field, Relationship


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(max_length=60, index=True)
    couple_id: Optional[int] = Field(default=None, foreign_key="couple.id", nullable=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)

    couple: Optional["Couple"] = Relationship(back_populates="users")