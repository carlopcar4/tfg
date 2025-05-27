FROM python:3.11-slim

RUN apt update && apt install -y curl jq docker.io
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    docker.io \
    docker-compose
    
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . . 

CMD [ "python", "flask/app.py" ]
