import openai
import json
from .function_descriptions.map_info_function_descriptions import map_info_function_descriptions
import logging

logger = logging.getLogger(__name__)

class MapInfoAgent:
    """An agent that has function descriptions dealing with information about at GIS map and it's data (e.g. a MapLibre map)."""
    
    def select_layer_name(self, layer_name):
        return {"name": "select_layer_name", "layer_name": layer_name}

    def __init__(self, model_version="gpt-3.5-turbo-0613", layers=[]):
        self.model_version = model_version
        self.function_descriptions = map_info_function_descriptions
        self.messages = [
            {
                "role": "system",
                "content": """You are a helpful assistant that selects layers on a GIS map, e.g. a MapLibre map.
                When asked to select, choose, or work on a layer, you will call the appropriate function.
                Examples iclude:
                'Select the layer named "Buildings"'
                'Select the Roads layer'
                'select contours'
                'Select water-level-2'
                'Work on highways'
                'Work with Forests'
                'Choose the Landuse layer'
                'Choose the layer named Woods'
                """,
            },
        ]
        self.available_functions = {
            "select_layer_name": self.select_layer_name,
        }

    def listen(self, message, layer_names=[]):
        logger.info(f"In MapInfoAgent.listen()...message is: {message}")
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
        logger.info(f"MapInfoAgent self.messages: {self.messages}")
        # this will be the function gpt will call if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            response = openai.ChatCompletion.create(
                model=self.model_version,
                messages=self.messages,
                functions=self.function_descriptions,
                function_call="auto",
                temperature=0.1,
                max_tokens=256,
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0
            )

            response_message = response["choices"][0]["message"]

            logger.info(f"First response from OpenAI in MapInfoAgent: {response_message}")

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

                # if the function name is select_layer_name, we need OpenAI to select the proper layer name instead of whatever the user said.
                # They may have used lower case or a descriptive designation instead of the actual layer name. We hope OpenAI can figure out
                # what they meant.
                if function_name == "select_layer_name":
                    logger.info(f"Sending layer name retrieval request to OpenAI...")
                    prompt = f"Please select a layer name from the following list that is closest to the text '{function_response['layer_name']}': {str(layer_names)}\n Only state the layer name in your response."
                    logger.info(f"Prompt to OpenAI: {prompt}")
                    messages = [
                        {
                            "role": "user",
                            "content": prompt,
                        },
                    ]
                    second_response = openai.ChatCompletion.create(
                        model=self.model_version,
                        messages=messages,
                    )
                    logger.info(f"Second response from OpenAI in MapInfoAgent: {second_response}")
                    second_response_message = second_response["choices"][0]["message"]["content"]
                    logger.info(f"Second response message from OpenAI in MapInfoAgent: {second_response_message}")
                    logger.info(f"Function Response bofore setting the layer name: {function_response}")
                    function_response['layer_name'] = second_response_message
                    logger.info(f"Function response after call to select a layername: {function_response}")
                return {"response": function_response}
            elif response_message.get("content"):
                return {"response": response_message["content"]}
            else:
                return {"response": "I'm sorry, I don't understand."}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in NavigationAgent: " + str(e)}, 500
        return {"response": function_response}