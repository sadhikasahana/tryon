# Use a lightweight Python base image
FROM python:3.10.6-slim

# Prevent Python from writing .pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install minimal OS dependencies required for OpenCV and MediaPipe
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy your project files into the image
COPY . .

# Expose the port your app uses (5001 as per your app.run)
EXPOSE 5001

# Start the app with Gunicorn in production mode (4 workers)
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5001", "app:app"]