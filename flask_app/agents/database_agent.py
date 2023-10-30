import openai
import json
import logging
import os
import requests
from utils.database import Database

logger = logging.getLogger(__name__)

class DatabaseAgent:
    """An agent that has function descriptions dealing with a GIS database."""
    
    def get_geojson_from_database(self, query):
        return {"name": "get_geojson_from_database", "query": query}
    
    def get_table_from_database(self, query):
        return {"name": "get_table_from_database", "query": query}

    def __init__(self, model_version="gpt-3.5-turbo-0613", schema=None):
        self.model_version = model_version
        self.schema = schema
        self.function_descriptions = self.get_function_descriptions()
        self.messages = [
            {
                "role": "system",
                "content": f"""You are a helpful assistant that answers questions about data in the 'osm' schema of a PostGIS database.

                When responding with sql queries, you must use the 'osm' schema desgignation.

                Favor SQL queries that return polygons first, then lines, then points.

                An example prompt from the user is:
                
                'add buildings to the map
                Ensure the query is restricted to the following bbox: 30, 50, 31, 51'

                You would respond with:
                'SELECT ST_AsGeoJSON(geometry) FROM osm.osm_buildings WHERE ST_Intersects(geometry, ST_MakeEnvelope(30, 50, 31, 51, 4326))'.
                
                Other example prompts include:\n
                'add airports to the map that are military'\n
                'show school buildings'\n
                'add primary roads to the map'\n
                'get the 10 most recently changed military structures'\n""",
            },
        ]
        self.available_functions = {
            "get_geojson_from_database": self.get_geojson_from_database,
            "get_table_from_database": self.get_table_from_database,
        }

    def listen(self, message, bbox):
        logger.info(f"In DatabaseAgent.listen()...message is: {message}")
        logger.info(f"In DatabaseAgent.listen()...bbox is: {bbox}")
        data = {'message': message}
        response = requests.get("http://localhost:5000/get_table_name", json=data)
        """Listen to a message from the user."""
        map_context = f"Ensure the query is restricted to the following bbox: {bbox}"
        table_name_context = ""

        # attempt to get the tablename from the user message
        # we do this to avoid sending the entire schema to openai
        if response.status_code == 200:
            logger.info(f"Response from /get_table_name route: {response}")
            response_data = response.json()
            logger.info(f"Response message from /get_table_name route: {response_data}")
            table_name = response_data.get('choices', [{}])[0].get('message', {}).get('content', '')
            if table_name:
                logger.info(f"Table name: {table_name}")
                db = Database(
                    database=os.getenv("POSTGRES_DBNAME"),
                    user=os.getenv("POSTGRES_USER"),
                    password=os.getenv("POSTGRES_PASS"),
                    host=os.getenv("POSTGRES_HOST"),
                    port=os.getenv("POSTGRES_PORT")
                )
                column_names = db.get_column_names(table_name)
                db.close()
                table_name_context = f"Generate your query using the following table name: {table_name} and the appropriate column names: {column_names}" 
               
        #remove the last item in self.messages
        if len(self.messages) > 1:
            self.messages.pop()
        self.messages.append({
            "role": "user",
            "content": message + "\n" + map_context + "\n" + table_name_context,
        })
        # self.messages.append({
        #     "role": "user",
        #     "content": map_context,
        # })
        logger.info(f"DatabaseAgent self.messages: {self.messages}")
        logger.info(f"DatabaseAgent self.function_descriptions: {self.function_descriptions}")
        # this will be the function gpt will call if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            response = openai.ChatCompletion.create(
                model=self.model_version,
                messages=self.messages,
                functions=self.function_descriptions,
                function_call="auto",
                temperature=0,
                max_tokens=256,
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0
            )

            response_message = response["choices"][0]["message"]

            logger.info(f"Response from OpenAI in DatabaseAgent: {response_message}")

            if response_message.get("function_call"):
                function_name = response_message["function_call"]["name"]
                function_name = function_name.strip()
                logger.info(f"Function name: {function_name}")
                function_to_call = self.available_functions[function_name]
                logger.info(f"Function to call: {function_to_call}")
                function_args = json.loads(response_message["function_call"]["arguments"])
                logger.info(f"Function args: {function_args}")
                # determine the function to call
                function_response = function_to_call(**function_args)

                ### This is blowing up my context window
                # self.messages.append(response_message)
                # self.messages.append({
                #     "role": "function",
                #     "name": function_name,
                #     "content": function_response,
                # })
                
                return {"response": function_response}
            elif response_message.get("content"):
                return {"response": response_message["content"]}
            else:
                return {"response": "I'm sorry, I don't understand."}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in NavigationAgent: " + str(e)}, 500
        return {"response": function_response}

    def get_function_descriptions(self):
        return [
            {
                "name": "get_geojson_from_database",
                "description": """Retrieve geojson sptatial data using PostGIS SQL.""",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "query": {
                            "type": "string",
                            "description": f"""SQL query to get geojson from the database.
                            The query shall be returned in string format as a single command."""
                        },
                    },
                    "required": ["query"],
                }
            },
            {
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
        ]