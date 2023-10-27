import openai
import json
import logging

logger = logging.getLogger(__name__)

class DatabaseAgent:
    """An agent that has function descriptions dealing with a GIS database."""
    
    def get_info_from_database(self, query):
        return {"name": "get_info_from_database", "query": query}

    def __init__(self, model_version="gpt-3.5-turbo-0613", schema=None):
        self.model_version = model_version
        self.schema = schema
        self.function_descriptions = self.get_function_descriptions(schema)
        self.messages = [
            {
                "role": "system",
                "content": f"""You are a helpful assistant that answers questions about data in the 'osm' schema of a PostGIS database.
                When responding with sql queries, you must use the 'osm' schema desgignation. An example prompt from the user is 
                'Get all buildings within a 1 degree by 1 degree bounding box around Kiev, Ukraine' and the resulting query should be
                'SELECT * FROM osm.osm_buildings WHERE ST_Intersects(geometry, ST_MakeEnvelope(30, 50, 31, 51, 4326))'.""",
            },
        ]
        self.available_functions = {
            "get_info_from_database": self.get_info_from_database,
        }

    def listen(self, message):
        logger.info(f"In DatabaseAgent.listen()...message is: {message}")
        """Listen to a message from the user."""
        #map_context = f"The following layers are in the map: {layer_names}"
        #remove the last item in self.messages
        if len(self.messages) > 1:
            self.messages.pop()
        self.messages.append({
            "role": "user",
            "content": message,
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
                function_call={"name": "get_info_from_database"},
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
                logger.info(f"Type of function_name: {type(function_name)}")
                function_name = function_name.strip()
                logger.info(f"Function name: {function_name}")
                function_to_call = self.available_functions[function_name]
                logger.info(f"Function to call: {function_to_call}")
                function_args = json.loads(response_message["function_call"]["arguments"])
                logger.info(f"Function args: {function_args}")
                # determine the function to call
                function_response = function_to_call(**function_args)
                self.messages.append(response_message)
                self.messages.append({
                    "role": "function",
                    "name": function_name,
                    "content": function_response,
                })
                logger.info(f"Function response: {function_response}")

                return {"response": function_response}
            elif response_message.get("content"):
                return {"response": response_message["content"]}
            else:
                return {"response": "I'm sorry, I don't understand."}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in NavigationAgent: " + str(e)}, 500
        return {"response": function_response}

    def get_function_descriptions(self, schema):
        return [
            {
            "name": "get_info_from_database",
            "description": """Use this function to answer questions about geospatial data in a PostGIS database that uses the schema 'osm'. Arguments shall be a
            fully formed SQL query.""",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": f"""SQL query extracting info from the database to answer the user's question.
                        The database schema is as follows:
                        {schema}
                        The query shall be returned in string format as a single command."""
                    },
                },
                "required": ["query"],
            }
        }]