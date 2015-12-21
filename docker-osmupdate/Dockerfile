#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM ubuntu:latest
MAINTAINER Etienne Trimaille<etienne@kartoza.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

# RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install ca-certificates rpl pwgen

#-------------Application Specific Stuff ----------------------------------------------------

# Install osmupdate
RUN apt-get -y install osmctools wget gzip gcc libc-dev zlib1g-dev
WORKDIR /home
ADD osmupdate.c /home/osmupdate.c
ADD osmconvert.c /home/osmconvert.c
RUN gcc -x c - -o osmupdate osmupdate.c
RUN gcc -x c - -O3 -o osmconvert osmconvert.c -lz

# Add the python script which will call osmupdate
ADD download.py /home/download.py

CMD ["python", "-u", "/home/download.py"]