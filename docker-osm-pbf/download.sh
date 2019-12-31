#!/usr/bin/env bash

CONTINENT_LOCKFILE=/home/settings/.${CONTINENT}_lock
COUNTRY_LOCKFILE=/home/settings/.${COUNTRY}_lock

# Download OSM Mapping file and Associated data
if [ ! -f /home/settings/mapping.yml ]; then \
  wget -c ${MAPPING_URL}/mapping.yml -O /home/settings/mapping.yml
fi

if [ ! -f /home/settings/qgis_style.sql ]; then \
  wget -c ${MAPPING_URL}/qgis_style.sql -O /home/settings/qgis_style.sql
fi

if [[ ! -f /home/settings/clip.geojson && -z ${GEOJSON_URL} ]]; then \
  echo "We are not downloading any Geojson"
else
  wget -c ${GEOJSON_URL} -O /home/settings/clip.geojson
fi

# Download OSM PBF
if [[ ! -f ${CONTINENT_LOCKFILE} && -z ${COUNTRY} ]]; then \

  echo "${BASE_URL}/${CONTINENT}-latest.osm.pbf"
  wget  -c --no-check-certificate ${BASE_URL}/${CONTINENT}-latest.osm.pbf -O /home/settings/country.pbf
  touch ${CONTINENT_LOCKFILE}


elif [[ ! -f ${COUNTRY_LOCKFILE} ]]; then

  echo "${BASE_URL}/${CONTINENT}/${COUNTRY}-latest.osm.pbf"
  wget  -c --no-check-certificate ${BASE_URL}/${CONTINENT}/${COUNTRY}-latest.osm.pbf -O /home/settings/country.pbf
  touch ${COUNTRY_LOCKFILE}
fi

