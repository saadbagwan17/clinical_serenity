from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class DoctorDocument(Base):
    __tablename__ = "doctor_documents"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        index=True
    )

    doctor_id: Mapped[int] = mapped_column(
        ForeignKey("doctors.id"),
        nullable=False,
        index=True
    )

    document_type: Mapped[str] = mapped_column(
        String(100),
        nullable=False
    )

    document_name: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )

    file_url: Mapped[str] = mapped_column(
        Text,
        nullable=False
    )

    verification_status: Mapped[str] = mapped_column(
        String(30),
        default="pending",
        nullable=False
    )

    uploaded_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        nullable=False
    )

    verified_at: Mapped[datetime | None] = mapped_column(
        DateTime,
        nullable=True
    )