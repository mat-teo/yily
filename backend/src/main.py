# main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from database import create_db_and_tables
from api.routers.couple import router as couple_router
from api.routers.reason import router as reason_router
from api.routers.auth import router as auth_router

app = FastAPI(title="Yily API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "*",                       
        "http://localhost:19006",  
        "http://localhost:3000",   
        "http://localhost:8080",   
        "https://tuo-dominio.com", 
        "https://*.tuo-dominio.com",
    ],
    allow_credentials=True,        
    allow_methods=["*"],           
    allow_headers=["*"],           
)

@app.on_event("startup")
def startup():
    create_db_and_tables()

app.include_router(auth_router, prefix="/api/v0.1.0", tags=["auth"])
app.include_router(couple_router, prefix="/api/v0.1.0", tags=["couples"])
app.include_router(reason_router, prefix="/api/v0.1.0", tags=["reasons"])