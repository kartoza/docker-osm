FROM python:3
MAINTAINER Irwan Fathurrahman <meomancer@gmail.com>

ADD requirements.txt /home/requirements.txt
RUN pip3 install -r /home/requirements.txt

ADD enrich.py /home/

RUN if [ ! -f /home/check_tables.sql ]; then \
    echo "SELECT EXISTS (SELECT 1 AS result from information_schema.tables where table_name like  'osm_%');" >> /home/check_tables.sql;\
    fi;

WORKDIR /home
CMD ["python3", "-u", "/home/enrich.py"]

