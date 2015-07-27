Next to ``docker-osm`` :

``git clone https://github.com/Gustry/docker-osmupdate.git``
``git clone https://github.com/Gustry/docker-imposm.git``
``git clone https://github.com/Gustry/docker-postgis.git``

``mkdir base-pbf``

Copy a OSM file and its state file(*.state.txt) into base-pbf. The state file contains the timestamp of the OSM file.

``docker-compose build``
``docker-compose up``