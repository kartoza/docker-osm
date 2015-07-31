#!/usr/bin/python

import sys
from json import loads
from subprocess import call

URL = 'http://download.geofabrik.de/'

if len(sys.argv) < 2:
    print 'Not enough argument. "list" or a name (continent or country)'
    exit()

# The JSON file comes from https://gist.github.com/Gustry/4e14bf096cdec09a3e57
json_data = open('countries.json').read()
data = loads(json_data)

if sys.argv[1] == 'list':
    for continent, countries in data.items():
        print continent
        for country in countries:
            print '     ' + country
    exit()
else:
    area = sys.argv[1]
    url = None
    for continent, countries in data.items():
        if area == continent:
            url = URL + area
        else:
            if area in countries:
                url = URL + continent + '/' + area

if url:
    poly_file = url + '.poly'
    pbf_file = url + '-latest.osm.pbf'
    diff = url + '-updates/'
    state = diff + 'state.txt'
    print 'Polygon file : ' + poly_file
    print 'PBF file : ' + pbf_file
    print 'Diff URL : ' + diff
    print 'state : ' + state

    print 'Downloading PBF'
    commands = ['wget', '-c', '-O', 'settings/country.pbf', pbf_file]
    call(commands)

    print 'Downloading polygon'
    commands = ['wget', '-c', '-O', 'settings/country.poly', poly_file]
    call(commands)

    print 'Downloading state'
    commands = ['wget', '-c', '-O', 'settings/country.state.txt', state]
    call(commands)

    print 'Setting custom URL diff'
    with open('settings/custom_url_diff.txt', 'w') as f:
        f.write(diff)

else:
    print 'This area is unkown in geofabrik or in our script. Check with the list argument.'

