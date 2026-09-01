from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.admin import Admin
from app.models.doctor import Doctor


router = APIRouter(
    prefix="/admin",
    tags=["Admin"]
)

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)
class AdminLoginRequest(BaseModel):
    email: str
    password: str

# =========================================================
# ADMIN LOGIN
# =========================================================

@router.post("/login")
def admin_login(
    data: AdminLoginRequest,
    db: Session = Depends(get_db)
):

    admin = db.query(Admin).filter(
        Admin.email == data.email
    ).first()

    if not admin:
        raise HTTPException(
            status_code=401,
            detail="Invalid admin credentials"
        )

    if not admin.is_active:
        raise HTTPException(
            status_code=403,
            detail="Admin account is inactive"
        )

    if not pwd_context.verify(
        data.password,
        admin.password_hash
    ):
        raise HTTPException(
            status_code=401,
            detail="Invalid admin credentials"
        )

    return {
        "status": "success",
        "message": "Admin login successful",
        "admin": {
            "admin_id": admin.admin_id,
            "full_name": admin.full_name,
            "email": admin.email
        }
    }

    admin = db.query(Admin).filter(
        Admin.email == email
    ).first()

    if not admin:
        raise HTTPException(
            status_code=401,
            detail="Invalid admin credentials"
        )

    if not admin.is_active:
        raise HTTPException(
            status_code=403,
            detail="Admin account is inactive"
        )

    if not pwd_context.verify(
        password,
        admin.password_hash
    ):
        raise HTTPException(
            status_code=401,
            detail="Invalid admin credentials"
        )

    return {
        "status": "success",
        "message": "Admin login successful",
        "admin": {
            "admin_id": admin.admin_id,
            "full_name": admin.full_name,
            "email": admin.email
        }
    }


# =========================================================
# GET PENDING DOCTORS
# =========================================================

@router.get("/doctors/pending")
def get_pending_doctors(
    db: Session = Depends(get_db)
):

    doctors = db.query(Doctor).filter(
        Doctor.verification_status == "pending"
    ).all()

    return {
        "status": "success",
        "count": len(doctors),
        "doctors": [
            {
                "id": doctor.id,
                "doctor_id": doctor.doctor_id,
                "full_name": doctor.full_name,
                "email": doctor.email,
                "mobile_number": doctor.mobile_number,
                "medical_registration_number":
                    doctor.medical_registration_number,
                "state_medical_council":
                    doctor.state_medical_council,
                "specialization":
                    doctor.specialization,
                "qualifications":
                    doctor.qualifications,
                "years_of_experience":
                    doctor.years_of_experience,
                "languages":
                    doctor.languages,
                "bio":
                    doctor.bio,
                "hospital_name":
                    doctor.hospital_name,
                "address":
                    doctor.address,
                "verification_status":
                    doctor.verification_status
            }
            for doctor in doctors
        ]
    }


# =========================================================
# GET SINGLE DOCTOR
# =========================================================

@router.get("/doctors/{doctor_id}")
def get_doctor(
    doctor_id: str,
    db: Session = Depends(get_db)
):

    doctor = db.query(Doctor).filter(
        Doctor.doctor_id == doctor_id
    ).first()

    if not doctor:
        raise HTTPException(
            status_code=404,
            detail="Doctor not found"
        )

    return {
        "status": "success",
        "doctor": {
            "id": doctor.id,
            "doctor_id": doctor.doctor_id,
            "full_name": doctor.full_name,
            "email": doctor.email,
            "mobile_number": doctor.mobile_number,
            "medical_registration_number":
                doctor.medical_registration_number,
            "state_medical_council":
                doctor.state_medical_council,
            "specialization":
                doctor.specialization,
            "qualifications":
                doctor.qualifications,
            "years_of_experience":
                doctor.years_of_experience,
            "languages":
                doctor.languages,
            "bio":
                doctor.bio,
            "hospital_name":
                doctor.hospital_name,
            "address":
                doctor.address,
            "verification_status":
                doctor.verification_status,
            "verified_at":
                doctor.verified_at
        }
    }


# =========================================================
# APPROVE DOCTOR
# =========================================================

@router.put("/doctors/{doctor_id}/approve")
def approve_doctor(
    doctor_id: str,
    db: Session = Depends(get_db)
):

    doctor = db.query(Doctor).filter(
        Doctor.doctor_id == doctor_id
    ).first()

    if not doctor:
        raise HTTPException(
            status_code=404,
            detail="Doctor not found"
        )

    if doctor.verification_status == "approved":
        return {
            "status": "success",
            "message": "Doctor is already approved",
            "doctor_id": doctor.doctor_id
        }

    doctor.verification_status = "approved"
    doctor.verified_at = datetime.utcnow()

    db.commit()
    db.refresh(doctor)

    return {
        "status": "success",
        "message": "Doctor approved successfully",
        "doctor_id": doctor.doctor_id,
        "verification_status":
            doctor.verification_status,
        "verified_at":
            doctor.verified_at
    }


# =========================================================
# REJECT DOCTOR
# =========================================================

@router.put("/doctors/{doctor_id}/reject")
def reject_doctor(
    doctor_id: str,
    db: Session = Depends(get_db)
):

    doctor = db.query(Doctor).filter(
        Doctor.doctor_id == doctor_id
    ).first()

    if not doctor:
        raise HTTPException(
            status_code=404,
            detail="Doctor not found"
        )

    doctor.verification_status = "rejected"
    doctor.verified_at = None

    db.commit()
    db.refresh(doctor)

    return {
        "status": "success",
        "message": "Doctor rejected",
        "doctor_id": doctor.doctor_id,
        "verification_status":
            doctor.verification_status
    }

