Next to ``docker-osm`` :

``git clone https://github.com/Gustry/docker-osmupdate.git``
``git clone https://github.com/Gustry/docker-imposm.git``
``git clone https://github.com/Gustry/docker-postgis.git``

``mkdir base-pbf import-queue import-done cache``

Copy a OSM file and its state file into base-pbf.

``docker-compose build``
``docker-compose up``