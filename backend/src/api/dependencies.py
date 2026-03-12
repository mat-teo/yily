# api/dependencies.py
from datetime import datetime, timezone
from typing import Optional

from fastapi import Depends, HTTPException, status
from fastapi.security import APIKeyHeader
from jose import JWTError, jwt
from sqlmodel import Session

from database import get_session
from models.user import User

# Costanti – in produzione spostale in .env + pydantic_settings
SECRET_KEY = "your-super-secret-key-change-this-in-prod-2026"  # CAMBIA QUESTA!!!
ALGORITHM = "HS256"

# Definiamo lo schema per l'header Authorization
authorization_header = APIKeyHeader(
    name="Authorization",
    auto_error=False,  # lo gestiamo noi manualmente
    description="Insert token in the format: Bearer <token",
)

def create_access_token(user_id: int) -> str:
    """
    Create a JWT with the user ID as the subject. 
    """
    to_encode = {
        "sub": str(user_id),
    }
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(
    authorization: Optional[str] = Depends(authorization_header),
    db: Session = Depends(get_session)
) -> User:
    """
    Extracts and validates the JWT from the Authorization header.
    Returns the User from the database or raises 401.
    """
    if authorization is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token missing. Use the format: Bearer <token>",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # Removes "Bearer " (case insensitive) and handles extra spaces
    if not authorization.lower().startswith("bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token format. Must start with 'Bearer '",
            headers={"WWW-Authenticate": "Bearer"},
        )

    token = authorization[7:].strip()  # 7 = len("Bearer ")

    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired token",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id_str: Optional[str] = payload.get("sub")
        if user_id_str is None:
            raise credentials_exception

        try:
            user_id = int(user_id_str)
        except ValueError:
            raise credentials_exception

    except JWTError:
        raise credentials_exception

    user = db.get(User, user_id)
    if user is None:
        raise credentials_exception

    return user