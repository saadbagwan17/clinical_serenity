from app.database import Base, engine

# Import all models so SQLAlchemy knows about every table
from app.models import (
    Patient,
    Doctor,
    Admin,
    DoctorDocument,
    MedicalRecord,
    Prescription,
    Medicine,
    AccessOTP,
    Notification,
)

print("Creating Clinical Serenity database tables...")

Base.metadata.create_all(bind=engine)

print("ALL TABLES CREATED SUCCESSFULLY")