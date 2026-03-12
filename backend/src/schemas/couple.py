# schemas/couple.py
from pydantic import BaseModel
from typing import List, Optional

class UserOut(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True

class CoupleOut(BaseModel):
    id: int
    token: str
    users: List[UserOut]

    class Config:
        from_attributes = True

class CreateCoupleRequest(BaseModel):
    name: str  # name of the first user creating the couple

class JoinCoupleRequest(BaseModel):
    token: str
    name: str

class CoupleCreateResponse(CoupleOut):
    access_token: str
    token_type: str = "bearer"

class JoinCoupleResponse(CoupleOut):
    access_token: str
    token_type: str = "bearer"

class RecoverRequest(BaseModel):
    token: str          # couple token
    name: str           # name of the user trying to recover access

class RecoverResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut
    couple: dict
    partner: Optional[UserOut] = None