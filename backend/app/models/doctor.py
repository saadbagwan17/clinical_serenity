from datetime import datetime

from sqlalchemy import DateTime, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Doctor(Base):
    __tablename__ = "doctors"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        index=True
    )

    doctor_id: Mapped[str] = mapped_column(
        String(20),
        unique=True,
        index=True,
        nullable=False
    )

    # -------------------------
    # Account Information
    # -------------------------

    full_name: Mapped[str] = mapped_column(
        String(150),
        nullable=False
    )

    email: Mapped[str] = mapped_column(
        String(150),
        unique=True,
        index=True,
        nullable=False
    )

    mobile_number: Mapped[str] = mapped_column(
        String(20),
        unique=True,
        index=True,
        nullable=False
    )

    password_hash: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )

    # -------------------------
    # Professional Information
    # -------------------------

    medical_registration_number: Mapped[str] = mapped_column(
        String(100),
        unique=True,
        index=True,
        nullable=False
    )

    state_medical_council: Mapped[str | None] = mapped_column(
        String(150),
        nullable=True
    )

    specialization: Mapped[str | None] = mapped_column(
        String(150),
        nullable=True
    )

    qualifications: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    years_of_experience: Mapped[int | None] = mapped_column(
        Integer,
        nullable=True
    )

    languages: Mapped[str | None] = mapped_column(
        String(300),
        nullable=True
    )

    bio: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    hospital_name: Mapped[str | None] = mapped_column(
        String(200),
        nullable=True
    )

    address: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    # -------------------------
    # Verification
    # -------------------------

    verification_status: Mapped[str] = mapped_column(
        String(30),
        default="pending",
        nullable=False
    )

    verified_at: Mapped[datetime | None] = mapped_column(
        DateTime,
        nullable=True
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        nullable=False
    )