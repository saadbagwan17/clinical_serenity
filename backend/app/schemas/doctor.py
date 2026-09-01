from pydantic import BaseModel, EmailStr, Field, ConfigDict


# =========================================================
# DOCTOR SIGNUP
# =========================================================

class DoctorSignup(BaseModel):

    full_name: str = Field(
        min_length=2,
        max_length=150
    )

    email: EmailStr

    mobile_number: str = Field(
        min_length=10,
        max_length=20
    )

    password: str = Field(
        min_length=8,
        max_length=128
    )

    confirm_password: str = Field(
        min_length=8,
        max_length=128
    )

    medical_registration_number: str = Field(
        min_length=2,
        max_length=100
    )

    state_medical_council: str | None = None

    specialization: str | None = None

    qualifications: str | None = None

    years_of_experience: int | None = Field(
        default=None,
        ge=0
    )

    languages: str | None = None

    bio: str | None = None

    hospital_name: str | None = None

    address: str | None = None

    terms_accepted: bool


# =========================================================
# DOCTOR LOGIN
# =========================================================

class DoctorLogin(BaseModel):

    email: EmailStr | None = None

    mobile_number: str | None = None

    password: str = Field(
        min_length=1,
        max_length=128
    )


# =========================================================
# DOCTOR RESPONSE
# =========================================================

class DoctorResponse(BaseModel):

    model_config = ConfigDict(
        from_attributes=True
    )

    id: int
    doctor_id: str
    full_name: str
    email: str
    mobile_number: str

    medical_registration_number: str
    state_medical_council: str | None

    specialization: str | None
    qualifications: str | None
    years_of_experience: int | None
    languages: str | None

    bio: str | None
    hospital_name: str | None
    address: str | None

    verification_status: str