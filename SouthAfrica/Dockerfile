# This image is intended to be used as a storage
# only container

FROM byrnedo/alpine-curl
MAINTAINER Tim Sutton <tim@kartoza.com>

RUN mkdir /settings
RUN curl -o /settings/country.pbf http://download.openstreetmap.fr/extracts/africa/south_africa.osm.pbf
ADD mapping.yml /settings/mapping.yml
ADD clip /settings/clip
ADD qgis_style.sql /settings/qgis_style,sql
