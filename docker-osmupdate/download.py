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


class Downloader(object):

    def __init__(self):
        # Default values which can be overwritten.
        self.default = {
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
        self.osm_file = None

    @staticmethod
    def info(message):
        print message

    @staticmethod
    def error(message):
        print >> stderr, message
        exit()

    def overwrite_environment(self):
        """Overwrite default values from the environment."""
        for key in environ.keys():
            if key in self.default.keys():
                self.default[key] = environ[key]

    def check_settings(self):
        """Perform various checking."""
        # Folders
        folders = ['IMPORT_QUEUE', 'IMPORT_DONE', 'SETTINGS']
        for folder in folders:
            if not isabs(self.default[folder]):
                # Get the absolute path.
                self.default[folder] = abspath(self.default[folder])

            # Test the folder
            if not exists(self.default[folder]):
                msg = 'The folder %s does not exist.' % self.default[folder]
                self.error(msg)

        # Test files
        for f in listdir(self.default['SETTINGS']):

            if f.endswith('.pbf'):
                self.osm_file = join(self.default['SETTINGS'], f)

        if not self.osm_file:
            msg = 'OSM file *.osm.pbf is missing in %s' % self.default['SETTINGS']
            self.error(msg)

        self.info('The checkup is OK. The container will continue soon, after the database.')
        sleep(45)

    def _check_latest_timestamp(self):
        """Fetch the latest timestamp."""
        # Check if diff to be imported is empty. If not, take the latest diff.
        diff_to_be_imported = sorted(listdir(self.default['IMPORT_QUEUE']))
        if len(diff_to_be_imported):
            file_name = diff_to_be_imported[-1].split('.')[0]
            timestamp = file_name.split('->-')[1]
            self.info('Timestamp from the latest not imported diff : %s' % timestamp)
        else:
            # Check if imported diff is empty. If not, take the latest diff.
            imported_diff = sorted(listdir(self.default['IMPORT_DONE']))
            if len(imported_diff):
                file_name = imported_diff[-1].split('.')[0]
                timestamp = file_name.split('->-')[1]
                self.info('Timestamp from the latest imported diff : %s' % timestamp)

            else:
                # Take the timestamp from original file.
                command = ['osmconvert', self.osm_file, '--out-timestamp']
                processus = Popen(
                    command, stdin=PIPE, stdout=PIPE, stderr=PIPE)
                timestamp, err = processus.communicate()

                # Remove new line
                timestamp = timestamp.strip()

                self.info('Timestamp from the original state file : %s' % timestamp)

        # Removing some \ in the timestamp.
        timestamp = timestamp.replace('\\', '')
        return timestamp

    def download(self):
        """Infinite loop to download diff files on a regular interval."""
        while True:
            timestamp = self._check_latest_timestamp()

            # Save time
            current_time = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
            self.info('Old time     : %s' % timestamp)
            self.info('Current time : %s' % current_time)

            # Destination
            file_name = '%s->-%s.osc.gz' % (timestamp, current_time)
            file_path = join(self.default['IMPORT_QUEUE'], file_name)

            # Command
            command = ['osmupdate', '-v']
            command += ['--max-days=' + self.default['MAX_DAYS']]
            command += [self.default['DIFF']]
            command += ['--max-merge=' + self.default['MAX_MERGE']]
            command += ['--compression-level=' + self.default['COMPRESSION_LEVEL']]
            command += ['--base-url=' + self.default['BASE_URL']]
            command.append(timestamp)
            command.append(file_path)

            self.info(' '.join(command))
            if call(command) != 0:
                self.info('An error occured in osmupdate. Let\'s try again.')
                # Sleep less.
                self.info('Sleeping for 2 seconds.')
                sleep(2.0)
            else:
                # Everything was fine, let's sleeping.
                self.info('Creating diff successful : %s' % file_name)
                self.info('Sleeping for %s seconds.' % self.default['TIME'])
                sleep(float(self.default['TIME']))

if __name__ == '__main__':
    downloader = Downloader()
    downloader.overwrite_environment()
    downloader.check_settings()
    downloader.download()
