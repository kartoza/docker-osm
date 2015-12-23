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

from os.path import exists, join, isabs, abspath
from os import listdir, environ
from sys import exit
from subprocess import call, Popen, PIPE
from datetime import datetime
from time import sleep
from sys import stderr

# Default values which can be overwritten.
default = {
    'MAX_DAYS': '100',
    'DIFF': 'sporadic',
    'MAX_MERGE': '7',
    'COMPRESSION_LEVEL': '1',
    'BASE_URL': 'http://planet.openstreetmap.org/replication/',
    'IMPORT_QUEUE': 'import_queue',
    'IMPORT_DONE': 'import_done',
    'SETTINGS': 'settings',
    'TIME': 120,
}

for key in environ.keys():
    if key in default.keys():
        default[key] = environ[key]

# Folders
folders = ['IMPORT_QUEUE', 'IMPORT_DONE', 'SETTINGS']
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
for f in listdir(default['SETTINGS']):

    if f.endswith('.pbf'):
        osm_file = join(default['SETTINGS'], f)

    """
    # Todo : need fix custom URL and sporadic diff : daily, hourly and minutely
    if f == 'custom_url_diff.txt':
        with open(join(default['SETTINGS'], f), 'r') as content_file:
            default['BASE_URL'] = content_file.read()
    """

if not osm_file:
    print >> stderr, 'OSM file *.osm.pbf is missing in %s' % default['SETTINGS']
    exit()

# In docker-compose, we should wait for the DB is ready.
print 'The checkup is OK. The container will continue soon, after the database.'
sleep(45)

# Finally launch the listening process.
while True:
    # Check if diff to be imported is empty. If not, take the latest diff.
    diff_to_be_imported = sorted(listdir(default['IMPORT_QUEUE']))
    if len(diff_to_be_imported):
        file_name = diff_to_be_imported[-1].split('.')[0]
        timestamp = file_name.split('->-')[1]
        print 'Timestamp from the latest not imported diff : %s' % timestamp
    else:
        # Check if imported diff is empty. If not, take the latest diff.
        imported_diff = sorted(listdir(default['IMPORT_DONE']))
        if len(imported_diff):
            file_name = imported_diff[-1].split('.')[0]
            timestamp = file_name.split('->-')[1]
            print 'Timestamp from the latest imported diff : %s' % timestamp

        else:
            # Take the timestamp from original file.
            command = ['osmconvert', osm_file, '--out-timestamp']
            processus = Popen(command, stdin=PIPE, stdout=PIPE, stderr=PIPE)
            timestamp, err = processus.communicate()

            # Remove new line
            timestamp = timestamp.strip()

            print 'Timestamp from the original state file : %s' % timestamp

    # Removing some \ in the timestamp.
    timestamp = timestamp.replace('\\', '')

    # Save time
    current_time = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
    print 'Old time     : %s' % timestamp
    print 'Current time : %s' % current_time

    # Destination
    file_name = '%s->-%s.osc.gz' % (timestamp, current_time)
    file_path = join(default['IMPORT_QUEUE'], file_name)

    # Command
    command = ['osmupdate', '-v']
    command += ['--max-days=' + default['MAX_DAYS']]
    command += [default['DIFF']]
    command += ['--max-merge=' + default['MAX_MERGE']]
    command += ['--compression-level=' + default['COMPRESSION_LEVEL']]
    command += ['--base-url=' + default['BASE_URL']]
    command.append(timestamp)
    command.append(file_path)

    print ' '.join(command)
    if call(command) != 0:
        print >> stderr, 'An error occured in osmupdate. Let\'s try again.'
        # Sleep less.
        print 'Sleeping for 2 seconds.'
        sleep(2.0)
    else:
        # Everything was fine, let's sleeping.
        print 'Sleeping for %s seconds.' % default['TIME']
        sleep(float(default['TIME']))
