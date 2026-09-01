from fastapi import APIRouter, Depends, HTTPException
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.doctor import Doctor
from app.schemas.doctor import (
    DoctorSignup,
    DoctorLogin,
    DoctorResponse
)


router = APIRouter(
    prefix="/doctors",
    tags=["Doctors"]
)


# =========================================================
# PASSWORD HASHING
# =========================================================

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)


# =========================================================
# DOCTOR SIGNUP
# =========================================================

@router.post(
    "/signup",
    response_model=DoctorResponse
)
def doctor_signup(
    doctor_data: DoctorSignup,
    db: Session = Depends(get_db)
):

    # -----------------------------------------------------
    # Confirm password
    # -----------------------------------------------------

    if doctor_data.password != doctor_data.confirm_password:
        raise HTTPException(
            status_code=400,
            detail="Passwords do not match"
        )

    # -----------------------------------------------------
    # Terms and privacy
    # -----------------------------------------------------

    if not doctor_data.terms_accepted:
        raise HTTPException(
            status_code=400,
            detail="Terms and privacy consent is required"
        )

    # -----------------------------------------------------
    # Check email
    # -----------------------------------------------------

    existing_email = db.query(Doctor).filter(
        Doctor.email == doctor_data.email
    ).first()

    if existing_email:
        raise HTTPException(
            status_code=400,
            detail="Email already registered"
        )

    # -----------------------------------------------------
    # Check mobile
    # -----------------------------------------------------

    existing_mobile = db.query(Doctor).filter(
        Doctor.mobile_number == doctor_data.mobile_number
    ).first()

    if existing_mobile:
        raise HTTPException(
            status_code=400,
            detail="Mobile number already registered"
        )

    # -----------------------------------------------------
    # Check medical registration number
    # -----------------------------------------------------

    existing_registration = db.query(Doctor).filter(
        Doctor.medical_registration_number
        == doctor_data.medical_registration_number
    ).first()

    if existing_registration:
        raise HTTPException(
            status_code=400,
            detail="Medical registration number already registered"
        )

    # -----------------------------------------------------
    # Hash password
    # -----------------------------------------------------

    hashed_password = pwd_context.hash(
        doctor_data.password
    )

    # -----------------------------------------------------
    # Create doctor
    # -----------------------------------------------------

    doctor = Doctor(

        doctor_id="TEMP",

        full_name=doctor_data.full_name,

        email=doctor_data.email,

        mobile_number=doctor_data.mobile_number,

        password_hash=hashed_password,

        medical_registration_number=(
            doctor_data.medical_registration_number
        ),

        state_medical_council=(
            doctor_data.state_medical_council
        ),

        specialization=(
            doctor_data.specialization
        ),

        qualifications=(
            doctor_data.qualifications
        ),

        years_of_experience=(
            doctor_data.years_of_experience
        ),

        languages=(
            doctor_data.languages
        ),

        bio=doctor_data.bio,

        hospital_name=(
            doctor_data.hospital_name
        ),

        address=doctor_data.address,

        # IMPORTANT
        # New doctors must be verified by admin.
        verification_status="pending"
    )

    db.add(doctor)

    # Get generated database ID
    db.flush()

    # Example:
    # D0001
    # D0002
    # D0003

    doctor.doctor_id = f"D{doctor.id:04d}"

    db.commit()

    db.refresh(doctor)

    return doctor


# =========================================================
# DOCTOR LOGIN
# =========================================================

@router.post("/login")
def doctor_login(
    login_data: DoctorLogin,
    db: Session = Depends(get_db)
):

    doctor = None

    # -----------------------------------------------------
    # Login using email
    # -----------------------------------------------------

    if login_data.email:

        doctor = db.query(Doctor).filter(
            Doctor.email == login_data.email
        ).first()

    # -----------------------------------------------------
    # Login using mobile
    # -----------------------------------------------------

    elif login_data.mobile_number:

        doctor = db.query(Doctor).filter(
            Doctor.mobile_number
            == login_data.mobile_number
        ).first()

    else:

        raise HTTPException(
            status_code=400,
            detail="Email or mobile number is required"
        )

    # -----------------------------------------------------
    # Doctor not found
    # -----------------------------------------------------

    if not doctor:

        raise HTTPException(
            status_code=401,
            detail="Invalid email/mobile number or password"
        )

    # -----------------------------------------------------
    # Verify password
    # -----------------------------------------------------

    password_correct = pwd_context.verify(
        login_data.password,
        doctor.password_hash
    )

    if not password_correct:

        raise HTTPException(
            status_code=401,
            detail="Invalid email/mobile number or password"
        )

    # -----------------------------------------------------
    # Verification check
    # -----------------------------------------------------

    if doctor.verification_status == "pending":

        return {
            "status": "pending",
            "message": (
                "Your account is waiting for admin verification"
            ),
            "doctor": {
                "doctor_id": doctor.doctor_id,
                "full_name": doctor.full_name,
                "email": doctor.email,
                "verification_status": (
                    doctor.verification_status
                )
            }
        }

    # -----------------------------------------------------
    # Rejected doctor
    # -----------------------------------------------------

    if doctor.verification_status == "rejected":

        raise HTTPException(
            status_code=403,
            detail=(
                "Your doctor verification request "
                "was rejected"
            )
        )

    # -----------------------------------------------------
    # Approved doctor
    # -----------------------------------------------------

    return {
        "status": "success",
        "message": "Doctor login successful",
        "doctor": {
            "id": doctor.id,
            "doctor_id": doctor.doctor_id,
            "full_name": doctor.full_name,
            "email": doctor.email,
            "mobile_number": doctor.mobile_number,
            "medical_registration_number": (
                doctor.medical_registration_number
            ),
            "specialization": doctor.specialization,
            "verification_status": (
                doctor.verification_status
            )
        }
    }