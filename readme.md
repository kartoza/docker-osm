Copy an OSM file (*.pbf) and its state file(*.state.txt) into base-pbf. The state file contains the timestamp of the OSM file. You can add a [polygon file](http://wiki.openstreetmap.org/wiki/Osmosis/Polygon_Filter_File_Format) for the clipping.
Check that a *.json is present in 'settings' for the mapping.

``docker-compose build``
``docker-compose up``

You should read the documentation about [docker-imposm](https://github.com/gustry/docker-imposm3) and [docker-osmupdate](https://github.com/Gustry/docker-osmupdate) for settings.
