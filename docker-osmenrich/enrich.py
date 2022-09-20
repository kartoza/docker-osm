#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
/***************************************************************************
                              Docker-OSM Enrich
                    An enrich database of docker osm.
                        -------------------
        begin                : 2019-03-13
        email                : irwan at kartoza dot com
        contributor          : Irwan Fathurrahman
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

import sys
import gzip
from os import environ, listdir, mkdir
from os.path import join, exists, getsize
from sys import exit, stderr
from time import sleep
from urllib import request

import xmltodict
import yaml
from dateutil import parser
from psycopg2 import connect, OperationalError, ProgrammingError
from xmltodict import OrderedDict


class Enrich(object):
    mapping_type = {
        'point': 'node',
        'linestring': 'way',
        'polygon': 'way'
    }
    enriched_column = {
        'changeset_id': 'int',
        'changeset_version': 'int',
        'changeset_timestamp': 'datetime',
        'changeset_user': 'string'
    }
    latest_diff_file = None
    cache_folder = None
    out_of_scope_osm_folder = None

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
            'OSM_API_URL': 'https://api.openstreetmap.org/api/0.6/',
            'IMPORT_DONE': 'import_done',
            'CACHE': 'cache',
            'MAX_DIFF_FILE_SIZE': 100000000,
            'DBSCHEMA_PRODUCTION': 'public',
            'CACHE_MODIFY_CHECK': '',
            'SSL_MODE': 'disable',
            'SSL_CERT': None,
            'SSL_ROOT_CERT': None,
            'SSL_KEY': None
        }
        self.mapping_file = None
        self.mapping_database_schema = {}
        self.postgis_uri = None
        self.overwrite_environment()
        self.check_settings()

    def check_settings(self):
        """Perform various checking.

        This will run when the container is starting. If an error occurs, the
        container will stop.
        """
        # Test files
        try:
            for f in listdir(self.default['SETTINGS']):
                if f.endswith('.yml'):
                    self.mapping_file = join(self.default['SETTINGS'], f)
        except FileNotFoundError:
            pass

        if not self.mapping_file:
            self.error(
                'Mapping file *.yml is missing in %s' % self.default['SETTINGS']
            )
        else:
            self.info('Mapping: ' + self.mapping_file)

        # In docker-compose, we should wait for the DB is ready.
        self.check_mapping_file_data()
        self.info('The checkup is OK.')

        # enrich
        cache_folder = self.default['CACHE']
        if exists(cache_folder):
            cache_folder = join(cache_folder, 'enrich')
            if not exists(cache_folder):
                mkdir(cache_folder)

            # out_of_scope_osm
            out_of_scope_osm_folder = join(
                cache_folder, 'out_of_scope_osm')
            if not exists(out_of_scope_osm_folder):
                mkdir(out_of_scope_osm_folder)
            self.out_of_scope_osm_folder = out_of_scope_osm_folder

        self.cache_folder = cache_folder

        # check using not found cache for modify
        if self.default['CACHE_MODIFY_CHECK'].lower() == 'true':
            self.default['CACHE_MODIFY_CHECK'] = True
        else:
            self.default['CACHE_MODIFY_CHECK'] = False

    def get_cache_path(self):
        return join(self.cache_folder, 'cache')

    def get_cache_file(self):
        """ Return path of cache file
        return None if not found
        """
        if self.cache_folder:
            if exists(self.cache_folder):
                cache_file = self.get_cache_path()
                if exists(cache_file):
                    return cache_file
        return None

    def is_non_recognized_id(self, osm_type, osm_id):
        """ Return if osm id and type is unrecognized id
        """
        if not self.default['CACHE_MODIFY_CHECK']:
            return False

        if self.out_of_scope_osm_folder:
            if exists(
                    join(self.out_of_scope_osm_folder,
                         '%s-%s' % (osm_type, osm_id))):
                return True
        return False

    def get_or_create_non_recognized_id(self, osm_type, osm_id):
        """ Create file as cache for non recognized id
        """
        if not self.default['CACHE_MODIFY_CHECK']:
            return

        if self.out_of_scope_osm_folder:
            filename = join(
                self.out_of_scope_osm_folder,
                '%s-%s' % (osm_type, osm_id))
            if not exists(filename):
                try:
                    f = open(filename, 'w+')
                    f.close()
                except IOError:
                    self.info('%s can\'t be created' % filename)

    def check_mapping_file_data(self):
        """Perform converting yaml data into json
        that used for checking table on database
        """
        self.info('Load Mapping file data.')
        document = open(self.mapping_file, 'r')
        mapping_data = yaml.safe_load(document)
        try:
            for table, value in mapping_data['tables'].items():
                try:
                    type = value['type']
                    try:
                        osm_type = self.mapping_type[type]
                        osm_id_column = None
                        osm_id_column_index = None
                        columns = ['id']
                        for index, column in enumerate(value['columns']):
                            columns.append(column['name'])
                            try:
                                if column['type'] == 'id':
                                    osm_id_column = column['name']
                                    osm_id_column_index = index
                            except KeyError:
                                pass
                        columns.extend(self.enriched_column.keys())
                        self.mapping_database_schema['osm_%s' % table] = {
                            'osm_type': osm_type,
                            'osm_id_columnn': osm_id_column,
                            'osm_id_columnn_index': osm_id_column_index,
                            'columns': columns
                        }
                    except KeyError:
                        self.info('Type %s is not yet recognized by enrich.' % type)
                except KeyError:
                    self.info(
                        'Table %s doesn\'t has "type" attribute'
                    )

        except KeyError:
            self.error(
                'Mapping file %s doesn\'t has "tables" attribute' % self.mapping_file
            )

    def create_connection(self):
        if self.default['SSL_MODE'] == 'verify-ca' or self.default['SSL_MODE'] == 'verify-full':
            if self.default['SSL_CERT'] is None and self.default['SSL_KEY'] is None and self.default['SSL_ROOT_CERT'] \
                    is None:
                sys.exit()
            else:

                conn_parameters = "dbname='%s' user='%s' host='%s' port='%s' password='%s'" \
                                  " sslmode='%s' sslcert='%s' sslkey='%s' sslrootcert='%s' " % (
                                      self.default['POSTGRES_DBNAME'],
                                      self.default['POSTGRES_USER'],
                                      self.default['POSTGRES_HOST'],
                                      self.default['POSTGRES_PORT'],
                                      self.default['POSTGRES_PASS'],
                                      self.default['SSL_MODE'],
                                      self.default['SSL_CERT'],
                                      self.default['SSL_KEY'],
                                      self.default['SSL_ROOT_CERT'])
        else:
            conn_parameters = "dbname='%s' user='%s' host='%s' port='%s' password='%s' sslmode='%s'  " % (
                self.default['POSTGRES_DBNAME'],
                self.default['POSTGRES_USER'],
                self.default['POSTGRES_HOST'],
                self.default['POSTGRES_PORT'],
                self.default['POSTGRES_PASS'],
                self.default['SSL_MODE'])

        return connect(conn_parameters)

    def check_database(self):
        """Test connection to PostGIS and create the URI."""
        try:
            connection = self.create_connection()
            cursor = connection.cursor()
        except OperationalError as e:
            print(e)
        try:
            for table, table_data in self.mapping_database_schema.items():
                new_columns_postgis = []
                for enrich_key, enrich_type in self.enriched_column.items():
                    check_column = ''' SELECT EXISTS (SELECT 1 FROM information_schema.columns 
                                                                WHERE table_name='%s' and column_name='%s'); ''' % (
                        table, enrich_key)
                    cursor.execute(check_column)
                    column_existence = cursor.fetchone()[0]

                    if column_existence != 1:
                        if enrich_type == 'int':
                            new_columns_postgis.append('ADD COLUMN IF NOT EXISTS %s NUMERIC' % enrich_key)
                        elif enrich_type == 'string':
                            new_columns_postgis.append(
                                'ADD COLUMN IF NOT EXISTS %s CHARACTER VARYING (255)' % enrich_key)
                        elif enrich_type == 'datetime':
                            new_columns_postgis.append('ADD COLUMN IF NOT EXISTS %s TIMESTAMPTZ' % enrich_key)

                if len(new_columns_postgis) > 0:
                    query = 'ALTER TABLE %s."%s" %s;' % (
                        self.default['DBSCHEMA_PRODUCTION'], table, ','.join(new_columns_postgis))
                    cursor.execute(query)
                    connection.commit()
            connection.close()
            return True
        except (OperationalError, ProgrammingError):
            connection.rollback()
            connection.close()
            return False

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

    def check_data_on_dict(self, data, key):
        """ return data from dict with key
        return None if not found
        """
        try:
            return data[key]
        except KeyError:
            return None

    def get_osm_enrich_new_data(self, from_osm, from_database):
        """ Convert data from xml of osm into json
        and check if from osm is newer than from database

        :param from_osm: Data that got from osm
        :type from_osm: dict

        :param from_database: Data that in local database
        :type from_database: dict

        :return: Dictionary of new data that need to be inserted
        :rtype: dict
        """
        osm_id = self.check_data_on_dict(from_osm, '@id')
        row = from_database
        new_data = []
        if osm_id and row:
            allow_updated = False
            osm_timestamp = self.check_data_on_dict(from_osm, '@timestamp')
            osm_datetime = parser.parse(osm_timestamp).replace(tzinfo=None)
            if not row['changeset_timestamp'] or row['changeset_timestamp'] < osm_datetime:
                allow_updated = True
            if allow_updated:
                osm_version = self.check_data_on_dict(from_osm, '@version')
                osm_changeset = self.check_data_on_dict(from_osm, '@changeset')
                osm_user = self.check_data_on_dict(from_osm, '@user')
                self.info('Update for %s' % osm_id)
                new_data = {
                    'changeset_id': osm_changeset,
                    'changeset_timestamp': osm_datetime,
                    'changeset_version': osm_version,
                    'changeset_user': osm_user
                }
        return new_data

    def update_enrich_into_database(self, table_name, osm_id_column, osm_id, new_data):
        """ Update new data into data of osm id

        :param table_name: Table source of rows
        :type table_name: str

        :param osm_id_column: Column name of osm_id
        :type osm_id_column: str

        :param osm_id: osm id of data
        :type osm_id: str

        :param new_data: new data that will be updated
        :type new_data: Dict
        """
        if not new_data:
            return
        sets = []
        for field, value in new_data.items():
            try:
                value = value.replace('\'', '\'\'')
            except (TypeError, AttributeError):
                pass
            sets.append('%s=\'%s\'' % (field, value))
        connection = self.create_connection()
        cursor = connection.cursor()
        try:
            query = 'UPDATE %s.%s SET %s WHERE %s=%s' % (self.default['DBSCHEMA_PRODUCTION'],
                                                         table_name, ','.join(sets), osm_id_column, osm_id)
            cursor.execute(query)
            connection.commit()
        except ProgrammingError as e:
            connection.rollback()
            self.info('%s' % e)
        connection.close()

    # THIS PROCESS BELOW IS FOR EMPTY CHANGESET
    def update_osm_enrich_from_api_in_batch(
            self, osm_ids, osm_type, row_batch, table_name, osm_id_column):
        """ Get osm data from OSM API in Batch

        :param osm_ids: osm id in list
        :type osm_ids: list

        :param osm_type: feature type of this osm
        :type osm_type: str

        :param osm_type: feature type of this osm
        :type osm_type: str

        :param row_batch: Row data from local database in dictionary
        :type row_batch: Dict

        :param table_name: Table source of rows
        :type table_name: str

        :param osm_id_column: Column name of osm_id
        :type osm_id_column: str
        """
        if len(osm_ids) == 0:
            return
        osm_type_on_url = osm_type + 's'
        url = join(self.default['OSM_API_URL'], osm_type_on_url)
        url += '?%s=%s' % (osm_type_on_url, ','.join(osm_ids))
        self.info(url)
        content = None
        try:
            raw_content = request.urlopen(url).read()
            raw_content = xmltodict.parse(raw_content)
            if type(raw_content['osm'][osm_type]) == list:
                for osm in raw_content['osm'][osm_type]:
                    osm_id = self.check_data_on_dict(osm, '@id')
                    row = self.check_data_on_dict(row_batch, osm_id)
                    new_data = self.get_osm_enrich_new_data(
                        osm, row)
                    self.update_enrich_into_database(
                        table_name, osm_id_column, osm_id, new_data)

            else:
                osm_id = self.check_data_on_dict(
                    raw_content['osm'][osm_type], '@id')
                row = self.check_data_on_dict(row_batch, osm_id)
                new_data = self.get_osm_enrich_new_data(
                    raw_content['osm'][osm_type], row)
                self.update_enrich_into_database(
                    table_name, osm_id_column, osm_id, new_data)

        except Exception as e:
            self.info('%s' % e)
        return content

    def process_empty_changeset_from_table(self, table_name, table_columns, osm_id_column, osm_type):
        """ Processing all data from table

        :param table_name: Table source
        :type table_name: str

        :param table_columns: columns of tables
        :type table_columns: list

        :param osm_type: feature type of this osm
        :type osm_type: str

        :param osm_type: feature type of this osm
        :type osm_type: str

        :param osm_id_column: Column name of osm_id
        :type osm_id_column: str
        """
        # noinspection PyUnboundLocalVariable
        connection = self.create_connection()
        cursor = connection.cursor()
        row_batch = {}
        osm_ids = []
        try:
            check_sql = ''' select * from %s."%s" WHERE "changeset_timestamp" 
            IS NULL AND "osm_id" IS NOT NULL ORDER BY "osm_id" ''' % (self.default['DBSCHEMA_PRODUCTION'], table_name)
            cursor.execute(check_sql)
            row = True
            while row:
                # do something with row
                row = cursor.fetchone()
                if row:
                    row = dict(zip(table_columns, row))
                    row_batch['%s' % row[osm_id_column]] = row
                    osm_ids.append('%s' % row[osm_id_column])
                    if len(osm_ids) == 30:
                        self.update_osm_enrich_from_api_in_batch(
                            osm_ids, osm_type, row_batch, table_name, osm_id_column)
                        row_batch = {}
                        osm_ids = []

            self.update_osm_enrich_from_api_in_batch(
                osm_ids, osm_type, row_batch, table_name, osm_id_column)

        except ProgrammingError as e:
            connection.rollback()
            self.info('%s' % e)

    def enrich_empty_changeset(self):
        """Enrich database that has empty changeset by using OSM API URL
        """
        self.info('Enrich Database with empty changeset')
        for table, table_data in self.mapping_database_schema.items():
            osm_id_columnn = table_data['osm_id_columnn']
            osm_type = table_data['osm_type']
            columns = table_data['columns']
            if osm_id_columnn is not None:
                self.info('Checking data from table %s' % table)
                self.process_empty_changeset_from_table(
                    table, columns, osm_id_columnn, osm_type)
            else:
                self.info('Does not know osm_id column for %s.' % table)

    # THIS PROCESS BELOW IS FOR CHECKING DIFF FILES
    def enrich_database_from_osm_data(self, osm_data, osm_data_type):
        """ Convert data from xml of osm into json
        and check if from osm is newer than from database

        :param from_osm: Data that got from osm
        :type from_osm: dict

        :param from_database: Data that in local database
        :type from_database: dict

        :return: Dictionary of new data that need to be inserted
        :rtype: dict
        """
        osm_id = self.check_data_on_dict(
            osm_data, '@id')
        for table, table_data in self.mapping_database_schema.items():
            if osm_data_type == table_data['osm_type']:

                # check if this osm is not found on database
                if self.is_non_recognized_id(osm_data_type, osm_id):
                    continue

                connection = self.create_connection()
                cursor = connection.cursor()
                try:
                    validate_sql = ''' select * from %s."%s" WHERE "%s"=%s  ''' % (self.default['DBSCHEMA_PRODUCTION'],
                                                                                   table, table_data['osm_id_columnn'],
                                                                                   osm_id)
                    cursor.execute(validate_sql)
                    row = cursor.fetchone()
                    if row:
                        row = dict(zip(table_data['columns'], row))
                        new_data = self.get_osm_enrich_new_data(osm_data, row)
                        self.update_enrich_into_database(
                            table, table_data['osm_id_columnn'], osm_id, new_data)
                    else:
                        # if this id is not found add in cache
                        self.get_or_create_non_recognized_id(osm_data_type, osm_id)
                except Exception as e:
                    self.info('error when processing %s: %s' % (osm_id, e))
                connection.close()

    def enrich_database_from_diff_file(self):
        # check latest diff file
        if self.get_cache_file():
            self.latest_diff_file = open(self.get_cache_file(), "r").read()

        # get list diff file
        next_latest_diff_file = None
        target_folder = self.default['IMPORT_DONE']
        self.info('Enrich Database with diff file in %s' % self.default['IMPORT_DONE'])
        if not exists(target_folder):
            self.info('Folder %s is not ready yet' % target_folder)
            return
        for filename in sorted(listdir(target_folder)):
            try:
                if filename.endswith('.gz'):
                    if not self.latest_diff_file or self.latest_diff_file < filename:
                        self.info('Processing %s' % filename)
                        # if it is newest file
                        # process for getting this
                        gzip_file = join(target_folder, filename)
                        if getsize(gzip_file) > self.default['MAX_DIFF_FILE_SIZE']:
                            self.info('File is too big, skip it')
                            continue
                        f = gzip.open(gzip_file, 'rb')
                        file_content = f.read()
                        f.close()
                        raw_content = xmltodict.parse(file_content)
                        try:
                            modify_list = raw_content['osmChange']['modify']
                            for list in modify_list:
                                for key, value in list.items():
                                    if type(value) != OrderedDict:
                                        for osm_data in value:
                                            self.enrich_database_from_osm_data(
                                                osm_data, key
                                            )
                                    else:
                                        self.enrich_database_from_osm_data(
                                            value, key
                                        )
                        except KeyError:
                            self.info('%s can not be opened' % filename)
                        if not next_latest_diff_file or next_latest_diff_file < filename:
                            next_latest_diff_file = filename
            except Exception as e:
                self.info('Error when processing %s : %s' % (filename, e))

            if next_latest_diff_file:
                try:
                    cache_file = self.get_cache_path()
                    f = open(cache_file, 'w')
                    f.write(next_latest_diff_file)
                    f.close()
                except IOError:
                    self.info('cache file can\'t be created')

    def locate_table(self, name, schema):
        """Check for tables in the DB table exists in the DB"""
        connection = self.create_connection()
        cursor = connection.cursor()
        sql = """ SELECT EXISTS (SELECT 1 AS result from information_schema.tables 
              where table_name like  TEMP_TABLE and table_schema = 'TEMP_SCHEMA'); """
        cursor.execute(sql.replace('TEMP_TABLE', '%s' % name).replace('TEMP_SCHEMA', '%s' % schema))
        # noinspection PyUnboundLocalVariable
        return cursor.fetchone()[0]

    def run(self):
        """First checker."""
        while True:
            self.info('Run enrich process')

            osm_tables = self.locate_table("'osm_%'", self.default['DBSCHEMA_PRODUCTION'])
            if osm_tables != 1:
                self.info('Imposm is still running, wait a while and try again')
            else:
                if self.check_database():
                    self.enrich_empty_changeset()
                    self.enrich_database_from_diff_file()

            # sleep looping
            self.info('sleeping for %s' % self.default['TIME'])
            sleep(float(self.default['TIME']))


if __name__ == '__main__':
    enrich = Enrich()
    enrich.run()
