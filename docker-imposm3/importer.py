#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
/***************************************************************************
                              Docker-OSM
                    An ImpOSM database up-to-date.
                        -------------------
        begin                : 2015-07-15
        email                : etienne at kartoza dot com
        contributor          : Etienne Trimaille
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""

from sys import exit
from os import environ, listdir
from shutil import move
from os.path import join, exists, abspath, isabs
from psycopg2 import connect, OperationalError
from subprocess import call
from time import sleep
from sys import stderr

# All these default values can be overwritten by env vars
default = {
    'TIME': 120,
    'USER': 'docker',
    'PASSWORD': 'docker',
    'DATABASE': 'gis',
    'HOST': 'db',
    'PORT': '5432',
    'SETTINGS': 'settings',
    'CACHE': 'cache',
    'IMPORT_DONE': 'import_done',
    'IMPORT_QUEUE': 'import_queue',
    'SRID': '4326',
    'OPTIMIZE': 'false',
    'DBSCHEMA_PRODUCTION': 'public',
    'DBSCHEMA_IMPORT': 'import',
    'DBSCHEMA_BACKUP': 'backup',
    'CLIP': 'yes',
    'QGIS_STYLE': 'yes'
}

# Check if we overwrite default values.
for key in environ.keys():
    if key in default.keys():
        default[key] = environ[key]

# Check valid SRID.
if default['SRID'] not in ['4326', '3857']:
    print >> stderr, 'SRID not supported : %s' % default['SRID']
    exit()

# Check valid QGIS_STYLE.
if default['QGIS_STYLE'] not in ['yes', 'no']:
    print >> stderr, 'QGIS_STYLE not supported : %s' % default['QGIS_STYLE']
    exit()

# Check valid CLIP.
if default['CLIP'] not in ['yes', 'no']:
    print >> stderr, 'CLIP not supported : %s' % default['CLIP']
    exit()

# Check folders.
folders = ['IMPORT_QUEUE', 'IMPORT_DONE', 'SETTINGS', 'CACHE']
for folder in folders:
    if not isabs(default[folder]):
        # Get the absolute path.
        default[folder] = abspath(default[folder])

    # Test the folder
    if not exists(default[folder]):
        print >> stderr, 'The folder %s does not exist.' % default[folder]
        exit()

# Test files
osm_file = None
mapping_file = None
post_import_file = None
qgis_style = None
clip_shapefile = None
clip_sql = None
for f in listdir(default['SETTINGS']):

    if f.endswith('.pbf'):
        osm_file = join(default['SETTINGS'], f)

    if f.endswith('.json'):
        mapping_file = join(default['SETTINGS'], f)

    if f == 'post-pbf-import.sql':
        post_import_file = join(default['SETTINGS'], f)

    if f == 'qgis_style.sql':
        qgis_style = join(default['SETTINGS'], f)

    if f == 'clip':
        clip_folder = join(default['SETTINGS'], f)
        for clip_file in listdir(clip_folder):
            if clip_file == 'clip.shp':
                clip_shapefile = join(clip_folder, clip_file)
            if clip_file == 'clip.sql':
                clip_sql = join(clip_folder, clip_file)

if not osm_file:
    print >> stderr, 'OSM file *.pbf is missing in %s' % default['SETTINGS']
    exit()

if not mapping_file:
    print >> stderr, 'Mapping file *.json is missing in %s' % default['SETTINGS']
    exit()

if not post_import_file:
    print 'No *.sql detected in %s' % default['SETTINGS']
else:
    print '%s detected for post import.' % post_import_file

if not qgis_style and default['QGIS_STYLE'] == 'yes':
    print >> stderr, 'qgis_style.sql is missing in %s and QGIS_STYLE = yes.' % default['SETTINGS']
    exit()
elif qgis_style and default['QGIS_STYLE']:
    print '%s detected for QGIS styling.' % qgis_style
else:
    print 'Not using QGIS default styles.'

# Create the timestamp file
file_path = join(default['SETTINGS'], 'timestamp.txt')
timestamp_file = open(file_path, 'w')
timestamp_file.write('UNDEFINED\n')
timestamp_file.close()

# In docker-compose, we should wait for the DB is ready.
print 'The checkup is OK. The container will continue soon, after the database.'
sleep(45)

# Check postgis.
try:
    connection = connect(
        "dbname='%s' user='%s' host='%s' password='%s'" % (
            default['DATABASE'],
            default['USER'],
            default['HOST'],
            default['PASSWORD']))
    cursor = connection.cursor()
except OperationalError as e:
    print >> stderr, e
    exit()

postgis_uri = 'postgis://%s:%s@%s/%s' % (
    default['USER'],
    default['PASSWORD'],
    default['HOST'],
    default['DATABASE'])



# Check if there is a table starting with 'osm_'
sql = 'select count(*) ' \
      'from information_schema.tables ' \
      'where table_name like \'osm_%\';'
# noinspection PyUnboundLocalVariable
cursor.execute(sql)
osm_tables = cursor.fetchone()[0]
if osm_tables < 1:
    # It means that the DB is empty. Let's import the PBF file.
    command = ['imposm3', 'import', '-diff', '-deployproduction']
    command += ['-overwritecache', '-cachedir', default['CACHE']]
    command += ['-srid', default['SRID']]
    command += ['-dbschema-production', default['DBSCHEMA_PRODUCTION']]
    command += ['-dbschema-import', default['DBSCHEMA_IMPORT']]
    command += ['-dbschema-backup', default['DBSCHEMA_BACKUP']]
    command += ['-diffdir', default['SETTINGS']]
    command += ['-mapping', mapping_file]
    command += ['-read', osm_file]
    command += ['-write', '-connection', postgis_uri]

    print 'The database is empty. Let\'s import the PBF : %s' % osm_file
    print ' '.join(command)
    if not call(command) == 0:
        print >> stderr, 'An error occured in imposm with the original file.'
        exit()
    else:
        print 'Import PBF successful : %s' % osm_file

    if post_import_file or qgis_style:
        # Set the password for psql
        environ['PGPASSWORD'] = default['PASSWORD']

    if post_import_file:
        print 'Running the post import SQL file.'
        command = ['psql']
        command += ['-h', default['HOST']]
        command += ['-U', default['USER']]
        command += ['-d', default['DATABASE']]
        command += ['-f', post_import_file]
        call(command)

    if qgis_style:
        print 'Installing QGIS styles.'
        command = ['psql']
        command += ['-h', default['HOST']]
        command += ['-U', default['USER']]
        command += ['-d', default['DATABASE']]
        command += ['-f', qgis_style]
        call(command)

    if clip_shapefile:
        # Create function clean_tables()
        command = ['psql']
        command += ['-h', default['HOST']]
        command += ['-U', default['USER']]
        command += ['-d', default['DATABASE']]
        command += ['-f', clip_sql]
        call(command)

        sql = 'select count(*) ' \
              'from information_schema.tables ' \
              'where table_name like \'clip\';'
        # noinspection PyUnboundLocalVariable
        cursor.execute(sql)
        clip_tables = cursor.fetchone()[0]
        if clip_tables == 1:
            print 'Clipping.'
            command = ['psql']
            command += ['-h', default['HOST']]
            command += ['-U', default['USER']]
            command += ['-d', default['DATABASE']]
            command += ['-c', 'SELECT clean_tables();']
            call(command)
else:
    print 'The database is not empty. Let\'s import only diff files.'

# Finally launch the listening process.
while True:
    import_queue = sorted(listdir(default['IMPORT_QUEUE']))
    if len(import_queue) > 0:
        for diff in import_queue:
            print 'Importing diff %s' % diff
            command = ['imposm3', 'diff']
            command += ['-cachedir', default['CACHE']]
            command += ['-dbschema-production', default['DBSCHEMA_PRODUCTION']]
            command += ['-dbschema-import', default['DBSCHEMA_IMPORT']]
            command += ['-dbschema-backup', default['DBSCHEMA_BACKUP']]
            command += ['-srid', default['SRID']]
            command += ['-diffdir', default['SETTINGS']]
            command += ['-mapping', mapping_file]
            command += ['-connection', postgis_uri]
            command += [join(default['IMPORT_QUEUE'], diff)]

            print ' '.join(command)
            if call(command) == 0:
                move(
                    join(default['IMPORT_QUEUE'], diff),
                    join(default['IMPORT_DONE'], diff))

                # Update the timestamp in the file.
                database_timestamp = diff.split('.')[0].split('->-')[1]
                file_path = join(default['SETTINGS'], 'timestamp.txt')
                timestamp_file = open(file_path, 'w')
                timestamp_file.write('%s\n' % database_timestamp)
                timestamp_file.close()

                if clip_shapefile:
                    sql = 'select count(*) ' \
                          'from information_schema.tables ' \
                          'where table_name like \'clip\';'
                    # noinspection PyUnboundLocalVariable
                    cursor.execute(sql)
                    clip_tables = cursor.fetchone()[0]
                    if clip_tables == 1:
                        print 'Clipping.'
                        command = ['psql']
                        command += ['-h', default['HOST']]
                        command += ['-U', default['USER']]
                        command += ['-d', default['DATABASE']]
                        command += ['-c', 'SELECT clean_tables();']
                        call(command)

                print 'Import diff successful : %s' % diff
            else:
                print >> stderr, 'An error occured in imposm with a diff.'
                exit()

    if len(listdir(default['IMPORT_QUEUE'])) == 0:
        print 'Sleeping for %s seconds.' % default['TIME']
        sleep(float(default['TIME']))
