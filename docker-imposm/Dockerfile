FROM golang:1.21
MAINTAINER Etienne Trimaille <etienne.trimaille@gmail.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy \
        python3-pip gdal-bin libgeos-dev libleveldb-dev postgresql-client

RUN go install github.com/omniscale/imposm3/cmd/imposm@latest

WORKDIR /home
ADD requirements.txt .
RUN pip install --break-system-packages -r requirements.txt

ADD importer.py .

CMD ["python3", "-u", "importer.py"]
