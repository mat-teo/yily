# api/routers/couple.py
from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session

from database import get_session
from schemas.couple import CreateCoupleRequest, JoinCoupleRequest, CoupleCreateResponse, JoinCoupleResponse, CoupleOut
from crud.couple import create_couple, join_couple, get_couple_by_id
from api.dependencies import create_access_token, get_current_user
from models.user import User

router = APIRouter(prefix="/couples", tags=["couples"])

@router.post("/", response_model=CoupleCreateResponse)
def create_new_couple(
    req: CreateCoupleRequest,
    db: Session = Depends(get_session)
):
    couple = create_couple(db, req.name)
    
    # ID of the creator (first user) is needed for token generation
    creator = couple.users[0]  
    token = create_access_token(creator.id)
    
    return {
        "id": couple.id,
        "token": couple.token,
        "users": [{"id": u.id, "name": u.name} for u in couple.users],
        "access_token": token,
        "token_type": "bearer"
    }

@router.post("/join", response_model=JoinCoupleResponse)
def join_existing_couple(
    req: JoinCoupleRequest,
    db: Session = Depends(get_session)
):
    couple = join_couple(db, req.token, req.name)
    if not couple:
        raise HTTPException(400, "Codice non valido o coppia già completa")
    
    # New user is the one we just added, so we find them in the couple's users
    new_user = next((u for u in couple.users if u.name == req.name), None)
    if not new_user:
        raise HTTPException(500, "Errore interno")
    
    token = create_access_token(new_user.id)
    
    return {
        "id": couple.id,
        "token": couple.token,
        "users": [{"id": u.id, "name": u.name} for u in couple.users],
        "access_token": token,
        "token_type": "bearer"
    }

@router.get("/us", response_model=CoupleOut)
def get_couple_info(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_session)
):
    couple = get_couple_by_id(db, current_user.couple_id)
    if not couple:
        raise HTTPException(404, "Couple not found")
    
    return CoupleOut(
        id=couple.id,
        token=couple.token,
        users=[{"id": u.id, "name": u.name} for u in couple.users]
    )