from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Prescription(Base):
    __tablename__ = "prescriptions"

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

    doctor_id: Mapped[int] = mapped_column(
        ForeignKey("doctors.id"),
        nullable=False,
        index=True
    )

    medicine_id: Mapped[int] = mapped_column(
        ForeignKey("medicines.id"),
        nullable=False,
        index=True
    )

    dosage: Mapped[str] = mapped_column(
        String(100),
        nullable=False
    )

    frequency: Mapped[str] = mapped_column(
        String(100),
        nullable=False
    )

    duration: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True
    )

    instructions: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    prescribed_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        nullable=False
    )