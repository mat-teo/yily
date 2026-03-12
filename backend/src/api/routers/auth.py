# api/routers/auth.py
from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select

from database import get_session
from models import User, Couple
from schemas.couple import RecoverRequest, RecoverResponse
from api.dependencies import create_access_token

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/recover", response_model=RecoverResponse)
def recover_access(
    req: RecoverRequest,
    db: Session = Depends(get_session)
):
    # Find the couple by token
    couple = db.exec(select(Couple).where(Couple.token == req.token)).first()
    if not couple:
        raise HTTPException(status_code=404, detail="Couple token not found")

    # Find the user with that exact name in the couple
    user = db.exec(
        select(User).where(
            User.couple_id == couple.id,
            User.name == req.name
        )
    ).first()

    if not user:
        raise HTTPException(
            status_code=404,
            detail="Name not found in this couple. Verify that you have written the exact same name used at the beginning."
        )

    # Generate new token for this user
    new_token = create_access_token(user.id)

    # Optional: return useful info for the app
    partner = next((u for u in couple.users if u.id != user.id), None)

    return {
        "access_token": new_token,
        "token_type": "bearer",
        "user": {"id": user.id, "name": user.name},
        "couple": {"id": couple.id, "token": couple.token},
        "partner": {"id": partner.id, "name": partner.name} if partner else None
    }