from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class MedicalRecord(Base):
    __tablename__ = "medical_records"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        index=True
    )

    patient_id: Mapped[int] = mapped_column(
        ForeignKey("patients.id"),
        nullable=False,
        index=True
    )

    doctor_id: Mapped[int | None] = mapped_column(
        ForeignKey("doctors.id"),
        nullable=True,
        index=True
    )

    symptoms: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    medical_history: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    allergies: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    diagnosis_notes: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    test_results: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    treatment_notes: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    record_date: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        nullable=False
    )