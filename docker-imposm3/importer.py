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

from sys import exit, stderr
from os import environ, listdir
from shutil import move
from os.path import join, exists, abspath, isabs
from psycopg2 import connect, OperationalError
from subprocess import call
from time import sleep


class Importer(object):

    def __init__(self):
        # Default values which can be overwritten by environment variable.
        self.default = {
            'TIME': 120,
            'POSTGRES_USER': 'docker',
            'POSTGRES_PASS': 'docker',
            'POSTGRES_DBNAME': 'gis',
            'POSTGRES_HOST': 'db',
            'POSTGRES_PORT': '5432',
            'SETTINGS': 'settings',
            'CACHE': 'cache',
            'IMPORT_DONE': 'import_done',
            'IMPORT_QUEUE': 'import_queue',
            'SRID': '4326',
            'OPTIMIZE': 'false',
            'DBSCHEMA_PRODUCTION': 'public',
            'DBSCHEMA_IMPORT': 'import',
            'DBSCHEMA_BACKUP': 'backup',
            'CLIP': 'no',
            'QGIS_STYLE': 'yes'
        }
        self.osm_file = None
        self.mapping_file = None
        self.post_import_file = None
        self.clip_shape_file = None
        self.clip_sql_file = None
        self.qgis_style = None

        self.cursor = None
        self.postgis_uri = None

    @staticmethod
    def info(message):
        print(message)

    @staticmethod
    def error(message):
        print(stderr.write(message))
        exit()

    def overwrite_environment(self):
        """Overwrite default values from the environment."""
        for key in list(environ.keys()):
            if key in list(self.default.keys()):
                self.default[key] = environ[key]

    def check_settings(self):
        """Perform various checking.

        This will run when the container is starting. If an error occurs, the
        container will stop.
        """
        # Check valid SRID.
        if self.default['SRID'] not in ['4326', '3857']:
            msg = 'SRID not supported : %s' % self.default['SRID']
            self.error(msg)
        else:
            self.info('Detect SRID: ' + self.default['SRID'])

        # Check valid CLIP.
        if self.default['CLIP'] not in ['yes', 'no']:
            msg = 'CLIP not supported : %s' % self.default['CLIP']
            self.error(msg)
        else:
            self.info('Clip: ' + self.default['CLIP'])

        # Check valid QGIS_STYLE.
        if self.default['QGIS_STYLE'] not in ['yes', 'no']:
            msg = 'QGIS_STYLE not supported : %s' % self.default['QGIS_STYLE']
            self.error(msg)
        else:
            self.info('Qgis style: ' + self.default['QGIS_STYLE'])

        # Check folders.
        folders = ['IMPORT_QUEUE', 'IMPORT_DONE', 'SETTINGS', 'CACHE']
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

            # JSON first then YML (YML is the new format)
            if f.endswith('.json'):
                self.mapping_file = join(self.default['SETTINGS'], f)

            if f.endswith('.yml'):
                self.mapping_file = join(self.default['SETTINGS'], f)

            if f == 'post-pbf-import.sql':
                self.post_import_file = join(self.default['SETTINGS'], f)

            if f == 'qgis_style.sql':
                self.qgis_style = join(self.default['SETTINGS'], f)

            if f == 'clip':
                clip_folder = join(self.default['SETTINGS'], f)
                for clip_file in listdir(clip_folder):
                    if clip_file == 'clip.shp':
                        self.clip_shape_file = join(clip_folder, clip_file)
                    if clip_file == 'clip.sql':
                        self.clip_sql_file = join(clip_folder, clip_file)

        if not self.osm_file:
            msg = 'OSM file *.pbf is missing in %s' % self.default['SETTINGS']
            self.error(msg)
        else:
            self.info('OSM PBF file: ' + self.osm_file)

        if not self.mapping_file:
            msg = 'Mapping file *.yml is missing in %s' % self.default['SETTINGS']
            self.error(msg)
        else:
            self.info('Mapping: ' + self.osm_file)

        if not self.post_import_file:
            self.info('No custom SQL files *.sql detected in %s' % self.default['SETTINGS'])
        else:
            self.info('SQL Post Import: ' + self.post_import_file)

        if not self.qgis_style and self.default['QGIS_STYLE'] == 'yes':
            msg = 'qgis_style.sql is missing in %s and QGIS_STYLE = yes.' % self.default['SETTINGS']
            self.error(msg)
        elif self.qgis_style and self.default['QGIS_STYLE']:
            self.info('QGIS Style file: ' + self.qgis_style)
        else:
            self.info('Not using QGIS default styles.')

        if not self.clip_shape_file and self.default['CLIP'] == 'yes':
            msg = 'clip.shp is missing and CLIP = yes.'
            self.error(msg)
        elif self.clip_shape_file and self.default['QGIS_STYLE']:
            self.info('Shapefile for clipping: ' + self.clip_shape_file)
            self.info('SQL Clipping function: ' + self.clip_sql_file)
        else:
            self.info('No *.shp detected in %s, so no clipping.' % self.default['SETTINGS'])

        # In docker-compose, we should wait for the DB is ready.
        self.info('The checkup is OK.')

    def create_timestamp(self):
        """Create the timestamp with the undefined value until the real one."""
        file_path = join(self.default['SETTINGS'], 'timestamp.txt')
        timestamp_file = open(file_path, 'w')
        timestamp_file.write('UNDEFINED\n')
        timestamp_file.close()

    def update_timestamp(self, database_timestamp):
        """Update the current timestamp of the database."""
        file_path = join(self.default['SETTINGS'], 'timestamp.txt')
        timestamp_file = open(file_path, 'w')
        timestamp_file.write('%s\n' % database_timestamp)
        timestamp_file.close()

    def check_postgis(self):
        """Test connection to PostGIS and create the URI."""
        try:
            connection = connect(
                "dbname='%s' user='%s' host='%s' password='%s'" % (
                    self.default['POSTGRES_DBNAME'],
                    self.default['POSTGRES_USER'],
                    self.default['POSTGRES_HOST'],
                    self.default['POSTGRES_PASS']))
            self.cursor = connection.cursor()
        except OperationalError as e:
            print(stderr.write(e))

            exit()

        self.postgis_uri = 'postgis://%s:%s@%s/%s' % (
            self.default['POSTGRES_USER'],
            self.default['POSTGRES_PASS'],
            self.default['POSTGRES_HOST'],
            self.default['POSTGRES_DBNAME'])

    def import_custom_sql(self):
        """Import the custom SQL file into the database."""
        self.info('Running the post import SQL file.')
        command = ['psql']
        command += ['-h', self.default['POSTGRES_HOST']]
        command += ['-U', self.default['POSTGRES_USER']]
        command += ['-d', self.default['POSTGRES_DBNAME']]
        command += ['-f', self.post_import_file]
        call(command)

    def import_qgis_styles(self):
        """Import the QGIS styles into the database."""
        self.info('Installing QGIS styles.')
        command = ['psql']
        command += ['-h', self.default['POSTGRES_HOST']]
        command += ['-U', self.default['POSTGRES_USER']]
        command += ['-d', self.default['POSTGRES_DBNAME']]
        command += ['-f', self.qgis_style]
        call(command)

    def _import_clip_function(self):
        """Create function clean_tables().

        The user must import the clip shapefile to the database!
        """
        self.info('Import clip SQL function.')
        command = ['psql']
        command += ['-h', self.default['POSTGRES_HOST']]
        command += ['-U', self.default['POSTGRES_USER']]
        command += ['-d', self.default['POSTGRES_DBNAME']]
        command += ['-f', self.clip_sql_file]
        call(command)
        self.info('!! Be sure to run \'make import_clip\' to import the shapefile into the DB !!')

    def perform_clip_in_db(self):
        """Perform clipping if the clip table is here."""
        if self.count_table('clip') == 1:
            self.info('Clipping')
            command = ['psql']
            command += ['-h', self.default['POSTGRES_HOST']]
            command += ['-U', self.default['POSTGRES_USER']]
            command += ['-d', self.default['POSTGRES_DBNAME']]
            command += ['-c', 'SELECT clean_tables();']
            call(command)

    def count_table(self, name):
        """Check if there is a table starting with name."""
        sql = 'select count(*) ' \
              'from information_schema.tables ' \
              'where table_name like \'%s\';' % name
        # noinspection PyUnboundLocalVariable
        self.cursor.execute(sql)
        return self.cursor.fetchone()[0]

    def run(self):
        """First checker."""
        osm_tables = self.count_table('osm_%')
        if osm_tables < 1:
            # It means that the DB is empty. Let's import the PBF file.
            self._first_pbf_import()
        else:
            self.info(
                'The database is not empty. Let\'s import only diff files.')

        if self.default['TIME'] != '0':
            self._import_diff()
        else:
            self.info('No more update to the database. Leaving.')

    def _first_pbf_import(self):
        """Run the first PBF import into the database."""
        command = ['imposm', 'import', '-diff', '-deployproduction']
        command += ['-overwritecache', '-cachedir', self.default['CACHE']]
        command += ['-srid', self.default['SRID']]
        command += ['-dbschema-production',
                    self.default['DBSCHEMA_PRODUCTION']]
        command += ['-dbschema-import', self.default['DBSCHEMA_IMPORT']]
        command += ['-dbschema-backup', self.default['DBSCHEMA_BACKUP']]
        command += ['-diffdir', self.default['SETTINGS']]
        command += ['-mapping', self.mapping_file]
        command += ['-read', self.osm_file]
        command += ['-write', '-connection', self.postgis_uri]
        self.info('The database is empty. Let\'s import the PBF : %s' % self.osm_file)
        self.info(' '.join(command))
        if not call(command) == 0:
            msg = 'An error occured in imposm with the original file.'
            self.error(msg)
        else:
            self.info('Import PBF successful : %s' % self.osm_file)

        if self.post_import_file or self.qgis_style:
            # Set the password for psql
            environ['PGPASSWORD'] = self.default['POSTGRES_PASS']

        if self.post_import_file:
            self.import_custom_sql()

        if self.clip_shape_file:
            self._import_clip_function()
            self.perform_clip_in_db()

        if self.qgis_style:
            self.import_qgis_styles()

    def _import_diff(self):
        # Finally launch the listening process.
        while True:
            import_queue = sorted(listdir(self.default['IMPORT_QUEUE']))
            if len(import_queue) > 0:
                for diff in import_queue:
                    self.info('Importing diff %s' % diff)
                    command = ['imposm', 'diff']
                    command += ['-cachedir', self.default['CACHE']]
                    command += ['-dbschema-production', self.default['DBSCHEMA_PRODUCTION']]
                    command += ['-dbschema-import', self.default['DBSCHEMA_IMPORT']]
                    command += ['-dbschema-backup', self.default['DBSCHEMA_BACKUP']]
                    command += ['-srid', self.default['SRID']]
                    command += ['-diffdir', self.default['SETTINGS']]
                    command += ['-mapping', self.mapping_file]
                    command += ['-connection', self.postgis_uri]
                    command += [join(self.default['IMPORT_QUEUE'], diff)]

                    self.info(' '.join(command))

                    if call(command) == 0:
                        move(
                            join(self.default['IMPORT_QUEUE'], diff),
                            join(self.default['IMPORT_DONE'], diff))

                        # Update the timestamp in the file.
                        database_timestamp = diff.split('.')[0].split('->-')[1]
                        self.update_timestamp(database_timestamp)

                        if self.clip_shape_file:
                            self.perform_clip_in_db()

                        self.info('Import diff successful : %s' % diff)
                    else:
                        msg = 'An error occured in imposm with a diff.'
                        self.error(msg)

            if len(listdir(self.default['IMPORT_QUEUE'])) == 0:
                self.info('Sleeping for %s seconds.' % self.default['TIME'])
                sleep(float(self.default['TIME']))


if __name__ == '__main__':
    importer = Importer()
    importer.overwrite_environment()
    importer.check_settings()
    importer.create_timestamp()
    importer.check_postgis()
    importer.run()
