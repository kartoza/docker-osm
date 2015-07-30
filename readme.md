Copy an OSM file (*.pbf) and its state file(*.state.txt) into base-pbf. 
The state file contains the timestamp of the OSM file. You can add a 
[polygon file](http://wiki.openstreetmap.org/wiki/Osmosis/Polygon_Filter_File_Format) 
for the clipping.
Check that a *.json is present in 'settings' for the mapping.

``docker-compose build``
``docker-compose up``

You should read the documentation about [docker-imposm]
(https://github.com/gustry/docker-imposm3) and 
[docker-osmupdate](https://github.com/Gustry/docker-osmupdate) for 
settings.


# Example usage

In this example we will set up an OSM database for South Africa that 
will poll for updates every hour.

First fetch the latest South Africa osm binary dump file (.pbf) and state file.
I will write the example as generically as possible so that you can substitute
your own country or region here.

```
mkdir osm
cd osm
wget -c -O country.pbf http://download.openstreetmap.fr/extracts/africa/south_africa.osm.pbf
wget -c -O country.state.txt http://download.openstreetmap.fr/extracts/africa/south_africa.state.txt
```


