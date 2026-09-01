from pydantic import BaseModel, EmailStr, Field


# =========================================================
# PATIENT SIGNUP
# =========================================================

class PatientSignup(BaseModel):
    full_name: str = Field(..., min_length=2, max_length=150)

    email: EmailStr | None = None

    mobile_number: str = Field(
        ...,
        min_length=10,
        max_length=20
    )

    address: str | None = None

    age: int | None = Field(
        default=None,
        ge=0,
        le=150
    )

    height: float | None = None

    weight: float | None = None

    blood_group: str | None = None

    password: str = Field(
        ...,
        min_length=6,
        max_length=100
    )


# =========================================================
# PATIENT LOGIN
# =========================================================

class PatientLogin(BaseModel):
    email: EmailStr | None = None

    mobile_number: str | None = None

    password: str = Field(
        ...,
        min_length=6,
        max_length=100
    )


# =========================================================
# PATIENT RESPONSE
# =========================================================

class PatientResponse(BaseModel):
    id: int
    patient_id: str
    full_name: str
    email: EmailStr | None = None
    mobile_number: str
    address: str | None = None
    age: int | None = None
    height: float | None = None
    weight: float | None = None
    blood_group: str | None = None

    class Config:
        from_attributes = True
