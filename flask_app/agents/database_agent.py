import json
import logging
import os
from utils.database import Database
from .function_descriptions.database_function_descriptions import database_function_descriptions

logger = logging.getLogger(__name__)

class DatabaseAgent:
    """An agent that has function descriptions dealing with a GIS database."""
    
    def get_geojson_from_database(self, query):
        return {"name": "get_geojson_from_database", "query": query}
    
    def get_table_from_database(self, query):
        return {"name": "get_table_from_database", "query": query}

    def __init__(self, client, model_version, schema=None):
        self.model_version = model_version
        self.client = client
        self.schema = schema
        self.tools = database_function_descriptions
        self.messages = [
            {
                "role": "system",
                "content": f"""You are a helpful assistant that answers questions about data in the 'osm' schema of a PostGIS database.

                When responding with sql queries, you must use the 'osm' schema desgignation. If the user is requesting map features such as buildings, roads, or airports, 
                you will construct a query that returns geojson.

                An example prompt from the user is: "Add buildings to the map. Ensure the query is restricted to the following bbox: 30, 50, 31, 51"

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
        """Listen to a message from the user."""
        #data = {'message': message}
        table_names = [table['table_name'] for table in self.schema]
        prefixed_message = f"Choose the most likely table the following text is referring to from this list:\m {table_names}.\n"
        final_message = prefixed_message + message

        # use openai to choose the most likely table name from the schema
        response = self.client.chat.completions.create(
            model=self.model_version,
            messages=[
                {"role": "system", "content": "You are a helpful assistant that chooses a table name from a list. Only respond with the table name."},
                {"role": "user", "content": final_message},
            ],
            temperature=0,
            max_tokens=32,
            frequency_penalty=0,
            presence_penalty=0,
        )
        table_name = response.choices[0].message.content
        logger.info(f"table_name in DatabaseAgent is: {table_name}")
        logger.info(f"bbox in DatabaseAgent is: {bbox}")
        map_context = f"Ensure the query is restricted to the following bbox: {bbox}"
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
        payload = message + "\n" + map_context + "\n" + table_name_context
        logger.info(f"payload in DatabaseAgent is: {payload}")
        self.messages.append({
            "role": "user",
            "content": payload,
        })

        # this will be the function gpt will call if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            logger.info("Calling OpenAI API in DatabaseAgent...")

            response = self.client.chat.completions.create(
                model=self.model_version,
                messages=self.messages,
                tools=self.tools,
                tool_choice="auto", 
            )
            logger.info(f"Response from OpenAI in DatabaseAgent: {response}")
            response_message = response.choices[0].message
            logger.info(f"Response_message in DatabaseAgent is: {response_message}")
            tool_calls = response_message.tool_calls

            if tool_calls:
                self.messages.append(response_message)
                for tool_call in tool_calls:
                    function_name = tool_call.function.name
                    function_to_call = self.available_functions[function_name]
                    function_args = json.loads(tool_call.function.arguments)
                    function_response = function_to_call(**function_args)
                    self.messages.append(
                        {
                            "tool_call_id": tool_call.id,
                            "role": "tool",
                            "name": function_name,
                            "content": json.dumps(function_response),
                        }
                    )
                logger.info("Sucessful StyleAgent task completion.")
                return {"response": function_response}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in NavigationAgent: " + str(e)}, 500
        return {"response": function_response}

    