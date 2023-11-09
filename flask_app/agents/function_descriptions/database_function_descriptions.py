get_geojson_from_database = {
    "type": "function",
    "function": {
        "name": "get_geojson_from_database",
        "description": """Retrieve geojson spatial data using PostGIS SQL.""",
        "parameters": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": """SQL query to get geojson from the database.
                    The query shall be returned in string format as a single command."""
                },
            },
            "required": ["query"],
        },
    },
}

get_table_from_database = {
    "type": "function",
    "function": {
        "name": "get_table_from_database",
        "description": """Retrieve a non-spatial table using PostgreSQL SQL.""",
        "parameters": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": """SQL query that gets the answer to the user's question or task.
                    The query shall be returned in string format as a single command.""",
                },
            },
            "required": ["query"],
        },
    },
}

database_function_descriptions = [
    get_geojson_from_database,
    get_table_from_database,
]