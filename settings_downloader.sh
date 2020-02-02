#!/usr/bin/env bash



GEOJSON_URL=

if [ -n "$1" ]
then
    GEOJSON_URL=$1
fi

CONTINENT=africa
if [ -n "$2" ]
then
    CONTINENT=$2
fi

COUNTRY=south-africa

if [ -n "$3" ]
then
    COUNTRY=$3
fi

CONTINENT_LOCKFILE=./settings/.${CONTINENT}_lock
COUNTRY_LOCKFILE=./settings/.${COUNTRY}_lock
BASE_URL=http://download.geofabrik.de

# Download OSM Mapping file and Geojson data

if [[ ! -f ./settings/clip.geojson && -z ${GEOJSON_URL} ]]; then \
  echo "We are not downloading any Geojson"
else
  wget -c ${GEOJSON_URL} -O ./settings/clip.geojson
fi

# Download OSM PBF
if [[ ! -f ${CONTINENT_LOCKFILE} && -z ${COUNTRY} ]]; then \

  echo "${BASE_URL}/${CONTINENT}-latest.osm.pbf"
  wget  -c --no-check-certificate ${BASE_URL}/${CONTINENT}-latest.osm.pbf -O ./settings/country.pbf
  touch ${CONTINENT_LOCKFILE}


elif [[ ! -f ${COUNTRY_LOCKFILE} ]]; then

  echo "${BASE_URL}/${CONTINENT}/${COUNTRY}-latest.osm.pbf"
  wget  -c --no-check-certificate ${BASE_URL}/${CONTINENT}/${COUNTRY}-latest.osm.pbf -O ./settings/country.pbf
  touch ${COUNTRY_LOCKFILE}
fi

