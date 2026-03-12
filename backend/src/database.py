# database.py
from sqlmodel import SQLModel, create_engine, Session
from models import *  

SQLITE_URL = "sqlite:///database.db"  

engine = create_engine(SQLITE_URL, echo=True)  # echo=False in prod

def get_session() -> Session:
    with Session(engine) as session:
        yield session

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)