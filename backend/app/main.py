from fastapi import FastAPI, Depends
from app.routes.admin import router as admin_router
from sqlalchemy import text, select
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.patient import Patient
from app.routes.patient import router as patient_router
from app.routes.doctor import router as doctor_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Clinical Serenity API",
    description="Backend API for Clinical Serenity",
    version="1.0.0"
)

app.include_router(patient_router)
app.include_router(doctor_router)
app.include_router(admin_router)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
@app.get("/")
def root():
    return {
        "message": "Clinical Serenity API is running",
        "status": "success"
    }



@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


# --------------------------------------------------
# DATABASE TEST
# --------------------------------------------------

@app.get("/db-test")
def db_test(db: Session = Depends(get_db)):
    try:
        result = db.execute(text("SELECT 1"))
        value = result.scalar()

        return {
            "status": "success",
            "database": "PostgreSQL",
            "query_result": value
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e)
        }


# --------------------------------------------------
# PATIENT COUNT
# --------------------------------------------------

@app.get("/patients/count")
def patient_count(db: Session = Depends(get_db)):

    count = db.query(Patient).count()

    return {
        "status": "success",
        "patient_count": count
    }


# --------------------------------------------------
# GET ALL PATIENTS
# --------------------------------------------------

@app.get("/patients")
def get_patients(db: Session = Depends(get_db)):

    result = db.execute(
        select(Patient)
    )

    patients = result.scalars().all()

    return {
        "status": "success",
        "count": len(patients),
        "patients": [
            {
                "id": patient.id,
                "patient_id": patient.patient_id,
                "full_name": patient.full_name,
                "email": patient.email,
                "mobile_number": patient.mobile_number,
                "blood_group": patient.blood_group
            }
            for patient in patients
        ]
    }
