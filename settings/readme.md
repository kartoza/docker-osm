This folder should contain a json file for the mapping. You can also put a
SQL file, it will be executed after the PBF import.

Optionally you can include a .poly file (see http://wiki.openstreetmap.org/wiki/Osmosis/Polygon_Filter_File_Format)
in this directory, which will be used as the clip extents for diffs. The
base name of the .poly file is not important - the first .poly file encountered
in this folder will be used.
