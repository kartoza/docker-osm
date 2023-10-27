class Database:
    def __init__(self, conn):
        self.conn = conn

    def get_table_names(self):
        table_names = []
        query = "SELECT name FROM sqlite_schema WHERE type='table';"
        tables = self.execute(query)
        for table in tables:
            table_names.append(table[0])
        return table_names

    def get_column_names(self, table_name):
        column_names = []
        query = f"PRAGMA table_info({table_name});"
        columns = self.execute(query)
        for column in columns:
            column_names.append(column[1])
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
        res = self.conn.execute(query)
        return res.fetchall()

    def close(self):
        self.conn.close()