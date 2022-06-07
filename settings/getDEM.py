# This code is adapted from https://dwtkns.com/srtm30m/


# Load the necessary packages.
import os
import geopandas as gpd
import glob
from zipfile import ZipFile
from osgeo import gdal
import getpass

## Set up a .wgetrc file to store your NASA Earthdata login username and password,
# https://lpdaac.usgs.gov/documents/195/HowtoAccessLPDAACDatafromtheCommandLine_FINAL_CK.docx
print("Please enter your NASA Earthdata credentials!")
earthdata_username = input("Enter NASA Earthdata username: ")
earthdata_password = getpass.getpass("Enter your NASA Earthdata password: ")
# Check if the login credentials already exist and add the login credentials
# if they don't.
wgetrc_fp = '~/.wgetrc'
full_wgetrc_fp = os.path.expanduser(wgetrc_fp)

try:
    file = open(full_wgetrc_fp)
except FileNotFoundError:
    os.system("touch ~/.wgetrc | chmod og-rw ~/.wgetrc")

with open(full_wgetrc_fp) as myfile:
    if f'http-user={earthdata_username}' and f'http-password={earthdata_password}' in myfile.read():
        print("The NASA Earthdata credentials provided already exist.")
    else:
        os.system(
            f"echo http-user={earthdata_username} >> ~/.wgetrc | echo http-password={earthdata_password} >> ~/.wgetrc")

## Get the SRTM_30m DEM for the osm clip area.
# Load the clip.geojson file.
clip_fp = 'settings/clip.geojson'
clip_gdf = gpd.read_file(clip_fp)

# Create the output directory to store the  elevation data if it does not exist.
output_dir = "settings/SRTM_DEM"
os.system(f"mkdir -p {output_dir}")

# Download and load the GeoJSON indexing DEM file names.
strm30m_tile_index_fp = os.path.join(output_dir, "srtm30m_bounding_boxes.geojson")
os.system(
    f"wget -nc -O {strm30m_tile_index_fp} https://dwtkns.com/srtm30m/srtm30m_bounding_boxes.json")
srtm30m_tile_index = gpd.read_file(strm30m_tile_index_fp)

# Get the SRTM tiles that intersect with the clip.geojson.
# For each SRTM tile, check if it intersects with the clip.geojson.
srtm30m_tile_index['intersect'] = srtm30m_tile_index.geometry.map(
    lambda x: x.intersects(clip_gdf.geometry.any()))

# Get the indices for the tiles intersect with the clip.geojson.
index = srtm30m_tile_index.index
condition = srtm30m_tile_index['intersect'] == True
intersection_indices = index[condition]
intersection_indices_list = intersection_indices.tolist()

# Get a list of the file names for the tiles that intersect with the clip.geojson.
tile_names = srtm30m_tile_index.iloc[intersection_indices_list]['dataFile'].to_list(
)

# Download the tiles into the output directory.
# Tiles come as zipped SRTMHGT files at # 1-arcsecond resolution (3601x3601 pixels)
# in a latitude/longitude projection (EPSG:4326), downloaded from NASA servers.
for tile in tile_names:
    base_url = "http://e4ftl01.cr.usgs.gov/MEASURES/SRTMGL1.003/2000.02.11/"
    download_url = base_url + tile
    download_command = f"wget -nc -P {output_dir} " + download_url
    os.system(download_command)

# Get the list of downloaded zipfiles in the output directory.
zip_search_criteria = "*.zip"
zip_query = os.path.join(output_dir, zip_search_criteria)
srtm30m_zipfiles = glob.glob(zip_query)

# Extract the SRTMHGT files from the downloaded zipfiles.
for srtm30m_zipfile in srtm30m_zipfiles:
    # Create a ZipFile Object and load the zipfile into it.
    with ZipFile(f'{srtm30m_zipfile}', 'r') as zipObj:
        # Extract all the contents of the zip file in the output directory.
        zipObj.extractall(output_dir)

# Get the list of extracted SRTMHGT files.
hgt_search_criteria = "*.hgt"
hgt_query = os.path.join(output_dir, hgt_search_criteria)
hgt_files = glob.glob(hgt_query)

# Merge the SRTMHGT files into a single TIF file.
merged_tif = 'merged_SRTM_30m_DEM.tif'
merged_tif_fp = os.path.join(output_dir, merged_tif)
files_string = " ".join(hgt_files)
command = f"gdal_merge.py -o {merged_tif_fp} -of GTiff -co COMPRESS=DEFLATE -co TILED=YES -co PREDICTOR=2 -co ZLEVEL=9 -ot Int16 " + files_string
os.system(command)

# Clip the merged TIF file using the clip.geojson vector.
srtm30m_tif = 'SRTM_30m_DEM.tif'
srtm30m_tif_fp = os.path.join(output_dir, srtm30m_tif)
clip_command = f"gdalwarp -overwrite -t_srs EPSG:4326 -of GTiff -tr 0.0002777777777777777 -0.0002777777777777778 -tap -cutline {clip_fp} -crop_to_cutline -dstnodata -9999.0 -co COMPRESS=DEFLATE -co PREDICTOR=2 -co ZLEVEL=9 {merged_tif_fp} {srtm30m_tif_fp}"
os.system(clip_command)

# Generate contours from the clipped TIF file. 
contours_fn = 'countours.shp'
contours_fp = os.path.join(output_dir, contours_fn)
generate_contours_command = f'gdal_contour -b 1 -a ELEV -i 20.0 -f "ESRI Shapefile" {srtm30m_tif_fp} {contours_fp}'
os.system(generate_contours_command)

## File clean up.
# Remove the GeoJSON indexing DEM file names.
os.remove(strm30m_tile_index_fp)

# Delete the downloaded zipfiles.
for srtm30m_zipfile in srtm30m_zipfiles:
    os.remove(srtm30m_zipfile)

# Delete the SRTMHGT files.
for hgt_file in hgt_files:
    os.remove(hgt_file)

# Remove the merged TIF file.
os.remove(merged_tif_fp)
