# Download Docker OSM Files

This image is used to facilitate downloading of docker-osm files which are required to get the image 
running. The image will download OSM PBF file, Mapping file, Clip Geojson and QGIS Style file.

Environment variables


**BASE_URL='http://download.geofabrik.de'** 

This is used to download the OSM PBF file. Currently points to Geofabrik

**CONTINENT=''**

Used to specify what continent you need to download pbf from. This is mandatory eg `CONTINENT=africa`

**COUNTRY=''** 

Used to specify which country you need to download pbf from. This is optional if you intent
to only use continent pbf. Eg `COUNTRY=lesotho`

**MAPPING_URL='https://raw.githubusercontent.com/kartoza/docker-osm/develop/settings'**
  
This currently points to the docker-osm repository to enable downloading of the mapping file, qgis_style
 file. These files are mandatory in the running of docker-osm

**GEOJSON_URL=''** 

This points to the geojson file that is used for clipping data in OSM. This can be empty if you do 
not intent to use the clip functionality in docker-osm

