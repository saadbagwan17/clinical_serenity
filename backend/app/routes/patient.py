from fastapi import APIRouter, Depends, HTTPException
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.patient import Patient
from app.schemas.patient import (
    PatientSignup,
    PatientLogin,
    PatientResponse
)


router = APIRouter(
    prefix="/patients",
    tags=["Patients"]
)


# -------------------------
# PASSWORD HASHING
# -------------------------

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)


# =========================================================
# PATIENT SIGNUP
# =========================================================

@router.post(
    "/signup",
    response_model=PatientResponse
)
def patient_signup(
    patient_data: PatientSignup,
    db: Session = Depends(get_db)
):

    # -------------------------
    # Check mobile number
    # -------------------------

    existing_mobile = db.query(Patient).filter(
        Patient.mobile_number == patient_data.mobile_number
    ).first()

    if existing_mobile:
        raise HTTPException(
            status_code=400,
            detail="Mobile number already registered"
        )

    # -------------------------
    # Check email
    # -------------------------

    if patient_data.email:

        existing_email = db.query(Patient).filter(
            Patient.email == patient_data.email
        ).first()

        if existing_email:
            raise HTTPException(
                status_code=400,
                detail="Email already registered"
            )

    # -------------------------
    # Hash password
    # -------------------------

    hashed_password = pwd_context.hash(
        patient_data.password
    )

    # -------------------------
    # Create patient
    # -------------------------

    patient = Patient(
        patient_id="TEMP",

        full_name=patient_data.full_name,
        email=patient_data.email,
        mobile_number=patient_data.mobile_number,

        address=patient_data.address,
        age=patient_data.age,
        height=patient_data.height,
        weight=patient_data.weight,
        blood_group=patient_data.blood_group,

        password_hash=hashed_password
    )

    db.add(patient)

    # Get auto-generated database ID
    db.flush()

    # -------------------------
    # Generate Patient ID
    # Example: P0001
    # -------------------------

    patient.patient_id = f"P{patient.id:04d}"

    db.commit()

    db.refresh(patient)

    return patient


# =========================================================
# PATIENT LOGIN
# =========================================================

@router.post("/login")
def patient_login(
    login_data: PatientLogin,
    db: Session = Depends(get_db)
):

    # -------------------------
    # Find patient
    # -------------------------

    patient = None

    # Login using EMAIL
    if login_data.email:

        patient = db.query(Patient).filter(
            Patient.email == login_data.email
        ).first()

    # Login using MOBILE
    elif login_data.mobile_number:

        patient = db.query(Patient).filter(
            Patient.mobile_number == login_data.mobile_number
        ).first()

    # Neither email nor mobile
    else:

        raise HTTPException(
            status_code=400,
            detail="Email or mobile number is required"
        )

    # -------------------------
    # Patient not found
    # -------------------------

    if not patient:

        raise HTTPException(
            status_code=401,
            detail="Invalid email/mobile number or password"
        )

    # -------------------------
    # Verify bcrypt password
    # -------------------------

    password_correct = pwd_context.verify(
        login_data.password,
        patient.password_hash
    )

    if not password_correct:

        raise HTTPException(
            status_code=401,
            detail="Invalid email/mobile number or password"
        )

    # -------------------------
    # Login successful
    # -------------------------

    return {
        "status": "success",
        "message": "Login successful",

        "patient": {
            "id": patient.id,
            "patient_id": patient.patient_id,
            "full_name": patient.full_name,
            "email": patient.email,
            "mobile_number": patient.mobile_number,
            "address": patient.address,
            "age": patient.age,
            "height": patient.height,
            "weight": patient.weight,
            "blood_group": patient.blood_group
        }
    }