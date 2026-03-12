# models/reason.py
from typing import Optional
from datetime import datetime
from sqlmodel import SQLModel, Field, Relationship


class Reason(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    
    # Who is the reason from (the sender)
    from_user_id: int = Field(foreign_key="user.id")
    
    # Who is the reason to (the recipient)
    to_user_id: int = Field(foreign_key="user.id")
    
    # Content of the reason
    content: str = Field(max_length=500)
    
    # Timestamp
    created_at: datetime = Field(default_factory=datetime.utcnow)

    
    from_user: Optional["User"] = Relationship(
        sa_relationship_kwargs={"foreign_keys": "Reason.from_user_id"}
    )
    to_user: Optional["User"] = Relationship(
        sa_relationship_kwargs={"foreign_keys": "Reason.to_user_id"}
    )