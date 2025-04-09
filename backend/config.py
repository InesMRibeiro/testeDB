import os

class Config:
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://ines:1234@localhost:5432/Names')
