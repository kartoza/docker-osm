FROM golang:1.9
MAINTAINER Etienne Trimaille <etienne@kartoza.com>

RUN apt-get update && apt-get install -y python-pip \
      libprotobuf-dev libleveldb-dev libgeos-dev \
      libpq-dev python-dev postgresql-client-9.6 python-setuptools \
      --no-install-recommends

RUN ln -s /usr/lib/libgeos_c.so /usr/lib/libgeos.so

WORKDIR $GOPATH
RUN go get github.com/tools/godep
RUN git clone https://github.com/omniscale/imposm3 src/github.com/omniscale/imposm3
RUN cd src/github.com/omniscale/imposm3 && make update_version && go install ./cmd/imposm3/

ADD requirements.txt /home/requirements.txt
RUN pip install -r /home/requirements.txt

ADD importer.py /home/

WORKDIR /home
CMD ["python", "-u", "/home/importer.py"]
