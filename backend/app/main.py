from fastapi import FastAPI

app = FastAPI(
    title="Clinical Serenity API",
    description="Backend API for Clinical Serenity",
    version="1.0.0"
)


@app.get("/")
def root():
    return {
        "message": "Clinical Serenity API is running",
        "status": "success"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }