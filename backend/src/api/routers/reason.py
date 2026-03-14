# api/routers/reason.py
from fastapi import APIRouter, Depends, HTTPException, Response
from sqlmodel import Session, select

from database import get_session
from schemas.reason import ReasonCreate, ReasonOut, ReasonUpdate
from crud.reason import (
    create_reason,
    get_reasons_for_user,
    get_reason_counts,
    get_random_received_reason
)
from models.user import User
from models.reason import Reason  
from api.dependencies import get_current_user

router = APIRouter(prefix="/reasons", tags=["reasons"])

@router.post("/", response_model=ReasonOut)
def add_reason(
    reason: ReasonCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_session)
):
    couple = current_user.couple
    if couple is None or len(couple.users) != 2:
        raise HTTPException(400, "Couple is not properly set up")

    partner = next((u for u in couple.users if u.id != current_user.id), None)
    if partner is None:
        raise HTTPException(400, "Partner not found")
    created = create_reason(
        db=db,
        from_user_id=current_user.id,
        to_user_id=partner.id,
        content=reason.content,
    )
    return created


@router.get("/my", response_model=list[ReasonOut])
def get_my_reasons(
    current_user: User = Depends(get_current_user),
    received_only: bool = False,
    sent_only: bool = False,
    db: Session = Depends(get_session)
):
    reasons = get_reasons_for_user(
        db=db,
        user_id=current_user.id,
        only_received=received_only,
        only_sent=sent_only
    )
    return reasons


@router.delete("/{reason_id}", status_code=204)
def delete_reason(
    reason_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_session)
):
    reason = db.get(Reason, reason_id)
    if not reason:
        raise HTTPException(status_code=404, detail="Reason not found")

    if reason.from_user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="You can only delete reasons you created"
        )

    db.delete(reason)
    db.commit()
    return Response(status_code=204)


@router.put("/{reason_id}", response_model=ReasonOut)
def update_reason(
    reason_id: int,
    update_data: ReasonUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_session)
):
    reason = db.get(Reason, reason_id)
    if not reason:
        raise HTTPException(status_code=404, detail="Reason not found")

    if reason.from_user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="You can only modify reasons you created"
        )

    # Update only provided fields
    if update_data.content is not None:
        reason.content = update_data.content

    db.add(reason)
    db.commit()
    db.refresh(reason)

    return reason


@router.get("/counts", response_model=dict)
def get_counts(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_session)
):
    counts = get_reason_counts(db, current_user.id)
    return counts


@router.get("/random", response_model=ReasonOut | None)
def get_random_reason(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_session)
):
    reason = get_random_received_reason(db, current_user.id)
    if not reason:
        raise HTTPException(status_code=404, detail="No received reasons yet")
    return reason