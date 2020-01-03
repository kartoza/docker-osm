FROM alpine:latest

RUN apk --no-cache add --update bash

ENV BASE_URL='http://download.geofabrik.de'
ENV CONTINENT=''
ENV COUNTRY=''
ENV MAPPING_URL='https://raw.githubusercontent.com/kartoza/docker-osm/develop/settings'
ENV GEOJSON_URL=''

RUN mkdir /home/settings
ADD download.sh /download.sh

ENTRYPOINT ["/bin/bash", "/download.sh"]
