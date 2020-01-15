FROM python:3
MAINTAINER Irwan Fathurrahman <meomancer@gmail.com>

ADD requirements.txt /home/requirements.txt
RUN pip3 install -r /home/requirements.txt

ADD enrich.py /home/

WORKDIR /home
CMD ["python3", "-u", "/home/enrich.py"]

