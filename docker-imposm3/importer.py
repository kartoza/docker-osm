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

# In docker-compose, we should wait for the DB is ready.
sleep(45)

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
    'OSM_PBF': 'osm_pbf',
    'IMPORT_DONE': 'import_done',
    'IMPORT_QUEUE': 'import_queue',
    'SRID': '4326',
    'OPTIMIZE': 'false',
    'DBSCHEMA_PRODUCTION': 'public',
    'DBSCHEMA_IMPORT': 'import',
    'DBSCHEMA_BACKUP': 'backup'
}

# Check if we overwrite default values.
# env = [var.lower() for var in environ]
for key in default.keys():
    if key in environ:
        default[key] = environ[key]

# Check valid SRID.
if default['SRID'] not in ['4326', '3857']:
    print >> stderr, 'SRID not supported : %s' % default['srid']
    exit()

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

# Check folders.
folders = ['IMPORT_QUEUE', 'IMPORT_DONE', 'OSM_PBF', 'SETTINGS', 'CACHE']
for folder in folders:
    if not isabs(default[folder]):
        # Get the absolute path.
        default[folder] = abspath(default[folder])

    # Test the folder
    if not exists(default[folder]):
        print >> stderr, 'The folder %s does not exist.' % default[folder]
        exit()

# Test files
state_file = None
osm_file = None
mapping_file = None
post_import_file = None
for f in listdir(default['OSM_PBF']):
    if f.endswith('.state.txt'):
        state_file = join(default['OSM_PBF'], f)

    if f.endswith('.pbf'):
        osm_file = join(default['OSM_PBF'], f)

if not osm_file:
    print >> stderr, 'OSM file *.pbf is missing in %s' % default['OSM_PBF']
    exit()

if not state_file:
    print >> stderr, 'State file *.state.txt is missing in %s' % default['OSM_PBF']
    exit()

for f in listdir(default['SETTINGS']):
    if f.endswith('.json'):
        mapping_file = join(default['SETTINGS'], f)

    if f.endswith('.sql'):
        post_import_file = join(default['SETTINGS'], f)

if not mapping_file:
    print >> stderr, 'Mapping file *.json is missing in %s' % default['SETTINGS']
    exit()

if not post_import_file:
    print 'No *.sql detected in %s' % default['SETTINGS']
else:
    print '%s detected for post import.' % post_import_file

# Check if there is a table starting with 'osm_'
sql = 'select count(*) ' \
      'from information_schema.tables ' \
      'where table_name like \'osm_%\';'
# noinspection PyUnboundLocalVariable
cursor.execute(sql)
osm_tables = cursor.fetchone()[0]
if osm_tables < 1:
    # It means that the DB is empty. Let's import the file.
    commands = ['imposm3', 'import', '-diff', '-deployproduction']
    commands += ['-overwritecache', '-cachedir', default['CACHE']]
    commands += ['-srid', default['SRID']]
    commands += ['-dbschema-production', default['DBSCHEMA_PRODUCTION']]
    commands += ['-dbschema-import', default['DBSCHEMA_IMPORT']]
    commands += ['-dbschema-backup', default['DBSCHEMA_BACKUP']]
    commands += ['-diffdir', default['SETTINGS']]
    commands += ['-mapping', mapping_file]
    commands += ['-read', osm_file]
    commands += ['-write', '-connection', postgis_uri]

    if not call(commands) == 0:
        print >> stderr, 'An error occured in imposm with the original file.'
        exit()

    if post_import_file:
        for sql in open(post_import_file):
            cursor.execute(sql)

# Finally launch the listening process.
while True:
    import_queue = sorted(listdir(default['IMPORT_QUEUE']))
    if len(import_queue) > 0:
        for diff in import_queue:
            print 'Importing diff %s' % diff
            commands = ['imposm3', 'diff']
            commands += ['-cachedir', default['CACHE']]
            commands += ['-dbschema-production', default['DBSCHEMA_PRODUCTION']]
            commands += ['-dbschema-import', default['DBSCHEMA_IMPORT']]
            commands += ['-dbschema-backup', default['DBSCHEMA_BACKUP']]
            commands += ['-srid', default['SRID']]
            commands += ['-diffdir', default['SETTINGS']]
            commands += ['-mapping', mapping_file]
            commands += ['-connection', postgis_uri]
            commands += [join(default['IMPORT_QUEUE'], diff)]

            if call(commands) == 0:
                move(
                    join(default['IMPORT_QUEUE'], diff),
                    join(default['IMPORT_DONE'], diff))
            else:
                print >> stderr, 'An error occured in imposm with a diff.'
                exit()

    if len(listdir(default['IMPORT_QUEUE'])) == 0:
        print 'Sleeping for %s seconds.' % default['TIME']
        sleep(float(default['TIME']))
