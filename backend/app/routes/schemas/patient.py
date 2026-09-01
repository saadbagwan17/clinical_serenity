from pydantic import BaseModel, Field, ConfigDict


# -------------------------
# PATIENT SIGNUP
# -------------------------

class PatientSignup(BaseModel):
    full_name: str
    email: str | None = None
    mobile_number: str
    address: str | None = None
    age: int | None = None
    height: float | None = None
    weight: float | None = None
    blood_group: str | None = None

    password: str = Field(
        min_length=6,
        max_length=128
    )


# -------------------------
# PATIENT LOGIN
# -------------------------

class PatientLogin(BaseModel):
    email: str | None = None
    mobile_number: str | None = None

    password: str = Field(
        min_length=6,
        max_length=128
    )


# -------------------------
# PATIENT RESPONSE
# -------------------------

class PatientResponse(BaseModel):
    id: int
    patient_id: str
    full_name: str
    email: str | None = None
    mobile_number: str
    address: str | None = None
    age: int | None = None
    height: float | None = None
    weight: float | None = None
    blood_group: str | None = None

    model_config = ConfigDict(
        from_attributes=True
    )