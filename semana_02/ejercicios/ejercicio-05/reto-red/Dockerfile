FROM python:3.8-slim
WORKDIR /app
COPY requirements.txt .
RUN apt-get update && apt-get install -y default-libmysqlclient-dev build-essential pkg-config python3-dev \
    && pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt 
COPY . .
EXPOSE 5000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]