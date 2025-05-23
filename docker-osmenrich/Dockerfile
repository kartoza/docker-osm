FROM python:3.11
MAINTAINER Irwan Fathurrahman <meomancer@gmail.com>

# Install system dependencies needed to build psycopg2
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

ADD requirements.txt /home/requirements.txt

RUN pip3 install --no-binary=psycopg2-binary -r /home/requirements.txt

ADD enrich.py /home/

WORKDIR /home
CMD ["python3", "-u", "/home/enrich.py"]