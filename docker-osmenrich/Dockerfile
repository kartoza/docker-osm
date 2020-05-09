FROM python:3
MAINTAINER Irwan Fathurrahman <meomancer@gmail.com>

ADD requirements.txt /home/requirements.txt
RUN pip3 install -r /home/requirements.txt
ENV \
    DOCKERIZE_VERSION=v0.6.1

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
ADD enrich.py /home/

WORKDIR /home

CMD [ "dockerize", "-wait","file:///home/settings/importer.lock", "python3" , "-u", "/home/enrich.py" ]



