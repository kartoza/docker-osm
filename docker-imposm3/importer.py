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


class Importer(object):

    def __init__(self):
        # Default values which can be overwritten.
        self.default = {
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

        # Check valid SRID.
        if self.default['SRID'] not in ['4326', '3857']:
            msg = 'SRID not supported : %s' % self.default['SRID']
            self.error(msg)

        # Check valid CLIP.
        if self.default['CLIP'] not in ['yes', 'no']:
            msg = 'CLIP not supported : %s' % self.default['CLIP']
            self.error(msg)

        # Check valid QGIS_STYLE.
        if self.default['QGIS_STYLE'] not in ['yes', 'no']:
            msg = 'QGIS_STYLE not supported : %s' % self.default['QGIS_STYLE']
            self.error(msg)

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

            if f.endswith('.json'):
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

        if not self.mapping_file:
            msg = 'Mapping file *.json is missing in %s' % self.default['SETTINGS']
            self.error(msg)

        if not self.post_import_file:
            self.info('No custom SQL files *.sql detected in %s' % self.default['SETTINGS'])
        else:
            self.info('%s detected for post import.' % self.post_import_file)

        if not self.qgis_style and self.default['QGIS_STYLE'] == 'yes':
            msg = 'qgis_style.sql is missing in %s and QGIS_STYLE = yes.' % self.default['SETTINGS']
            self.error(msg)
        elif self.qgis_style and self.default['QGIS_STYLE']:
            self.info('%s detected for QGIS styling.' % self.qgis_style)
        else:
            self.info('Not using QGIS default styles.')

        if not self.clip_shape_file and self.default['CLIP'] == 'yes':
            msg = 'clip.shp is missing and CLIP = yes.'
            self.error(msg)
        elif self.clip_shape_file and self.default['QGIS_STYLE']:
            self.info('%s detected for clipping.' % self.clip_shape_file)
            self.info('%s detected for clipping.' % self.clip_sql_file)
        else:
            self.info('No *.shp detected in %s, so no clipping.' % self.default['SETTINGS'])

        # In docker-compose, we should wait for the DB is ready.
        self.info('The checkup is OK. The container will continue soon, after the database.')
        sleep(45)

    def create_timestamp(self):
        file_path = join(self.default['SETTINGS'], 'timestamp.txt')
        timestamp_file = open(file_path, 'w')
        timestamp_file.write('UNDEFINED\n')
        timestamp_file.close()

    def update_timestamp(self, database_timestamp):
        file_path = join(self.default['SETTINGS'], 'timestamp.txt')
        timestamp_file = open(file_path, 'w')
        timestamp_file.write('%s\n' % database_timestamp)
        timestamp_file.close()

    def check_postgis(self):
        try:
            connection = connect(
                "dbname='%s' user='%s' host='%s' password='%s'" % (
                    self.default['DATABASE'],
                    self.default['USER'],
                    self.default['HOST'],
                    self.default['PASSWORD']))
            self.cursor = connection.cursor()
        except OperationalError as e:
            print >> stderr, e
            exit()

        self.postgis_uri = 'postgis://%s:%s@%s/%s' % (
            self.default['USER'],
            self.default['PASSWORD'],
            self.default['HOST'],
            self.default['DATABASE'])

    def import_custom_sql(self):
        self.info('Running the post import SQL file.')
        command = ['psql']
        command += ['-h', self.default['HOST']]
        command += ['-U', self.default['USER']]
        command += ['-d', self.default['DATABASE']]
        command += ['-f', self.post_import_file]
        call(command)

    def import_qgis_styles(self):
        self.info('Installing QGIS styles.')
        command = ['psql']
        command += ['-h', self.default['HOST']]
        command += ['-U', self.default['USER']]
        command += ['-d', self.default['DATABASE']]
        command += ['-f', self.qgis_style]
        call(command)

    def _import_clip_function(self):
        """Create function clean_tables()."""
        command = ['psql']
        command += ['-h', self.default['HOST']]
        command += ['-U', self.default['USER']]
        command += ['-d', self.default['DATABASE']]
        command += ['-f', self.clip_sql_file]
        call(command)

    def clip(self):
        """Perform clipping if the clip table is here."""
        if self.count_table('clip') == 1:
            self.info('Clipping')
            command = ['psql']
            command += ['-h', self.default['HOST']]
            command += ['-U', self.default['USER']]
            command += ['-d', self.default['DATABASE']]
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
        osm_tables = self.count_table('osm_%')
        if osm_tables < 1:
            # It means that the DB is empty. Let's import the PBF file.
            self._first_pbf_import()
        else:
            self.info('The database is not empty. Let\'s import only diff files.')

        self._import_diff()

    def _first_pbf_import(self):
        command = ['imposm3', 'import', '-diff', '-deployproduction']
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
            environ['PGPASSWORD'] = self.default['PASSWORD']

        if self.post_import_file:
            self.import_custom_sql()

        if self.clip_shape_file:
            self._import_clip_function()
            self.clip()

        if self.qgis_style:
            self.import_qgis_styles()

    def _import_diff(self):
        # Finally launch the listening process.
        while True:
            import_queue = sorted(listdir(self.default['IMPORT_QUEUE']))
            if len(import_queue) > 0:
                for diff in import_queue:
                    self.info('Importing diff %s' % diff)
                    command = ['imposm3', 'diff']
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
                            self.clip()

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
