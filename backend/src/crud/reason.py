# crud/reason.py 
from sqlmodel import Session, select, func
import random

from models import Reason, User


def create_reason(
    db: Session,
    from_user_id: int,
    to_user_id: int,
    content: str
) -> Reason:
    """
    Create a new reason after validation.
    """
    from_user = db.get(User, from_user_id)
    to_user = db.get(User, to_user_id)

    if not from_user or not to_user:
        raise ValueError("User not found")

    if from_user.couple_id != to_user.couple_id or from_user.couple_id is None:
        raise ValueError("Users do not belong to the same couple")

    reason = Reason(
        from_user_id=from_user_id,
        to_user_id=to_user_id,
        content=content
    )
    db.add(reason)
    db.commit()
    db.refresh(reason)
    return reason


def get_reasons_for_user(
    db: Session,
    user_id: int,
    only_received: bool = False,
) -> list[Reason]:
    """
    Retrieve reasons for the user:
    - only_received=True → only received reasons (to_user_id == user_id)
    - only_received=False → all couple reasons (sent + received)
    """
    user = db.get(User, user_id)
    if not user or not user.couple_id:
        return []

    stmt = select(Reason).where(
        (Reason.from_user_id == user_id) | (Reason.to_user_id == user_id)
    )

    if only_received:
        stmt = stmt.where(Reason.to_user_id == user_id)

    stmt = stmt.order_by(Reason.created_at.desc())

    return db.exec(stmt).all()


def get_reason_counts(
    db: Session,
    user_id: int
) -> dict:
    """
    Return counts of reasons:
    - sent: written by the user
    - received: written for the user by partner
    - total: sum of sent + received
    """
    user = db.get(User, user_id)
    if not user or not user.couple_id:
        return {"sent": 0, "received": 0, "total": 0}

    # Sent reasons (from_user_id == user_id)
    sent_result = db.exec(
        select(func.count(Reason.id)).where(Reason.from_user_id == user_id)
    ).first()
    sent = sent_result if sent_result is not None else 0

    # Received reasons (to_user_id == user_id)
    received_result = db.exec(
        select(func.count(Reason.id)).where(Reason.to_user_id == user_id)
    ).first()
    received = received_result if received_result is not None else 0

    # Total (sent or received by user)
    total_result = db.exec(
        select(func.count(Reason.id)).where(
            (Reason.from_user_id == user_id) |
            (Reason.to_user_id == user_id)
        )
    ).first()
    total = total_result if total_result is not None else 0

    return {
        "sent": sent,
        "received": received,
        "total": total
    }


def get_random_received_reason(
    db: Session,
    user_id: int
) -> Reason | None:
    """
    Get a random received reason (to_user_id == user_id).
    Returns None if no received reasons exist.
    """
    user = db.get(User, user_id)
    if not user or not user.couple_id:
        return None

    # Count received reasons
    count_result = db.exec(
        select(func.count(Reason.id)).where(Reason.to_user_id == user_id)
    ).first()
    count = count_result if count_result is not None else 0

    if count == 0:
        return None

    offset = random.randint(0, count - 1)

    reason = db.exec(
        select(Reason)
        .where(Reason.to_user_id == user_id)
        .offset(offset)
        .limit(1)
    ).first()

    return reason