import psycopg2

class Database:
    def __init__(self, database, user, password, host, port):
        self.conn = psycopg2.connect(
            database=database,
            user=user,
            password=password,
            host=host,
            port=port
        )
        self.cur = self.conn.cursor()

    def get_table_names(self):
        table_names = []
        query = """
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'osm';
        """
        tables = self.execute(query)
        for table in tables:
            table_names.append(table[0])
        return table_names

    def get_column_names(self, table_name):
        column_names = []
        query = f"""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = '{table_name}';
        """
        columns = self.execute(query)
        for column in columns:
            column_names.append(column[0])
        return column_names

    def get_database_info(self):
        database_info = []
        for table_name in self.get_table_names():
            column_names = self.get_column_names(table_name)
            database_info.append(
                {"table_name": table_name, "column_names": column_names}
            )
        return database_info

    def execute(self, query):
        self.cur.execute(query)
        return self.cur.fetchall()

    def close(self):
        self.cur.close()
        self.conn.close()
