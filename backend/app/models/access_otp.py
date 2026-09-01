from datetime import datetime

from sqlalchemy import Boolean, DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class AccessOTP(Base):
    __tablename__ = "access_otps"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        index=True
    )

    patient_id: Mapped[int | None] = mapped_column(
        Integer,
        nullable=True,
        index=True
    )

    doctor_id: Mapped[int | None] = mapped_column(
        Integer,
        nullable=True,
        index=True
    )

    otp_hash: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )

    purpose: Mapped[str] = mapped_column(
        String(100),
        nullable=False
    )

    expires_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False
    )

    is_used: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
        nullable=False
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        nullable=False
    )