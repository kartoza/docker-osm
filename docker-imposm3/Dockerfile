FROM golang:1.10
MAINTAINER Etienne Trimaille <etienne.trimaille@gmail.com>

RUN apt-get update
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - |  apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt update && apt install -y python3-pip \
      libprotobuf-dev libleveldb-dev libgeos-dev \
      libpq-dev python3-dev postgresql-client-11 python-setuptools \
      gdal-bin \
      --no-install-recommends

ENV \
    DOCKERIZE_VERSION=v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN ln -s /usr/lib/libgeos_c.so /usr/lib/libgeos.so

WORKDIR $GOPATH
RUN go get github.com/tools/godep
RUN git clone https://github.com/omniscale/imposm3 src/github.com/omniscale/imposm3
RUN cd src/github.com/omniscale/imposm3 && make update_version && go install ./cmd/imposm/

ADD requirements.txt /home/requirements.txt
RUN pip3 install -r /home/requirements.txt

ADD importer.py /home/

WORKDIR /home

CMD [ "dockerize", "-wait","file:///home/settings/country.pbf","python3" , "-u", "/home/importer.py" ]
