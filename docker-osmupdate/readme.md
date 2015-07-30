## Docker OSM Update

This docker image when run will fetch on a regular interval any new diff file
for all the changes that have happened in the world over the update interval.

You can also specify a custom url for fetching the diff if you wish to retrieve
regional diffs rather than the global one.

You can specify a polygonal area for the diff so that it will only apply features
from the diff that fall within that area. For example providing a polygon of the 
borders of Malawi will result in only Malawi features being extracted from the diff.

Note that the diff retrieved and options specified here are not related to the 
initial base map used - so for example if your initial base map is for Malawi and
you specify a diff area in Botswana, updated features in Botswana will be applied 
to your base map which only includes features from Malawi. For this reason, take
care to ensure that your diff area coincides with the region covered by your 
original base map.

Once the diff has been downloaded, it is placed into /home/import_queue where
it will be picked up by the long running imposm3 container, which will apply 
the diff to the database.

You should have 3 folders : osm_pbf, import_queue, import_done

Put a state file in base-pbf like this one :
http://download.openstreetmap.fr/extracts/africa/south_africa.state.txt

``docker build -t osmupdate .``
``docker run -v $('pwd')import-queue/:/home/import-queue -v $('pwd')base-pbf/:/home/base-pbf -v $('pwd')import-done/:/home/import-done -d osmupdate``

With -e, you can add some settings :
 - MAX_DAYS = 100, the maximum time range to assamble a cumulated changefile.
 - DIFF = sporadic, osmupdate uses a combination of minutely, hourly and daily changefiles. This value can be minute, hour, day or sporadic.
 - MAX_MERGE = 7, argument to determine the maximum number of parallely processed changefiles.
 - COMPRESSION_LEVEL = 1, define level for gzip compression. values between 1 (low compression but fast) and 9 (high compression but slow)
 - BASE_URL = http://planet.openstreetmap.org/replication/, change the URL to use a custom URL to fetch regional file updates.
 - IMPORT_QUEUE = import_queue
 - IMPORT_DONE = import_done
 - OSM_PBF = osm_pbf
 - TIME = 120, secondes between two executions of the script
