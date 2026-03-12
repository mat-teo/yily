# crud/couple.py
import secrets
import string
from sqlmodel import Session, select
from models import Couple, User


def generate_unique_token(db: Session, length=8) -> str:
    alphabet = string.ascii_uppercase + string.digits
    while True:
        token = ''.join(secrets.choice(alphabet) for _ in range(length))
        if not db.exec(select(Couple).where(Couple.token == token)).first():
            return token


def create_couple(db: Session, creator_name: str) -> Couple:
    token = generate_unique_token(db)
    couple = Couple(token=token)
    db.add(couple)
    db.commit()
    db.refresh(couple)

    user = User(name=creator_name, couple_id=couple.id)
    db.add(user)
    db.commit()
    db.refresh(user)

    return couple


def get_couple_by_token(db: Session, token: str) -> Couple | None:
    return db.exec(select(Couple).where(Couple.token == token)).first()


def join_couple(db: Session, token: str, new_name: str) -> Couple | None:
    couple = get_couple_by_token(db, token)
    if not couple:
        return None

    users = couple.users  
    if len(users) >= 2:
        return None

    if any(u.name == new_name for u in users):
        raise ValueError("Nome già usato nella coppia")

    new_user = User(name=new_name, couple_id=couple.id)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    db.refresh(couple)  
    return couple