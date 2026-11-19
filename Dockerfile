# AETHER — Sovereign Local Intelligence
# Multi-stage production Dockerfile

FROM python:3.11-slim-bookworm AS base

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    ffmpeg \
    libsndfile1 \
    portaudio19-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install the Chromium browser and its OS deps (needs the playwright CLI from pip above)
RUN playwright install --with-deps chromium \
    && rm -rf /var/lib/apt/lists/*

# Copy the rest of the application
COPY . .

# Create necessary directories
RUN mkdir -p data user_files logs

# Expose ports
EXPOSE 7860 8765

# Default command — can be overridden
CMD ["python", "main.py"]
