#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM ubuntu:18.04
MAINTAINER Etienne Trimaille<etienne.trimaille@gmail.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

# RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt -y update
RUN apt -y install ca-certificates rpl pwgen python3

#-------------Application Specific Stuff ----------------------------------------------------

# Install osmupdate
RUN apt -y install osmctools wget gzip gcc libc-dev zlib1g-dev
WORKDIR /home
ADD osmupdate.c /home/osmupdate.c
ADD osmconvert.c /home/osmconvert.c
RUN gcc -x c - -o osmupdate osmupdate.c
RUN gcc -x c - -O3 -o osmconvert osmconvert.c -lz

# Add the python script which will call osmupdate
ADD download.py /home/download.py

CMD ["python3", "-u", "/home/download.py"]