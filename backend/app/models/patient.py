from datetime import datetime

from sqlalchemy import DateTime, Float, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Patient(Base):
    __tablename__ = "patients"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)

    patient_id: Mapped[str] = mapped_column(
        String(20),
        unique=True,
        index=True,
        nullable=False
    )

    full_name: Mapped[str] = mapped_column(String(150), nullable=False)

    email: Mapped[str | None] = mapped_column(
        String(150),
        unique=True,
        index=True,
        nullable=True
    )

    mobile_number: Mapped[str] = mapped_column(
        String(20),
        unique=True,
        index=True,
        nullable=False
    )

    address: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    age: Mapped[int | None] = mapped_column(
        Integer,
        nullable=True
    )

    height: Mapped[float | None] = mapped_column(
        Float,
        nullable=True
    )

    weight: Mapped[float | None] = mapped_column(
        Float,
        nullable=True
    )

    blood_group: Mapped[str | None] = mapped_column(
        String(10),
        nullable=True
    )

    password_hash: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow
    )