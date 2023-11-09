import json
from .function_descriptions.map_info_function_descriptions import map_info_function_descriptions
import logging

logger = logging.getLogger(__name__)

class MapInfoAgent:
    """An agent that has function descriptions dealing with information about at GIS map and it's data (e.g. a MapLibre map)."""
    
    def select_layer_name(self, layer_name):
        return {"name": "select_layer_name", "layer_name": layer_name}

    def __init__(self, client, model_version):
        self.client = client
        self.model_version = model_version
        self.tools = map_info_function_descriptions
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
        """Listen to a message from the user."""
        logger.info(f"In MapInfoAgent...message is: {message}")
        
        self.messages.append({
            "role": "user",
            "content": message,
        })
        
        # this will be the function gpt will call if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            response = self.client.chat.completions.create(
                model=self.model_version,
                messages=self.messages,
                tools=self.tools,
                tool_choice={"type": "function", "function": {"name": "select_layer_name"}}, 
            )
            response_message = response.choices[0].message
            logger.info(f"Response from OpenAI in MapInfoAgent: {response_message}")
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

                # if the function name is select_layer_name, we need OpenAI to select the proper layer name instead of whatever the user said.
                # They may have used lower case or a descriptive designation instead of the actual layer name. We hope OpenAI can figure out
                # what they meant. In general, it's pretty good at this unless there are multiple layers with similar names, in which case
                # it just chooses one.
                if function_name == "select_layer_name":

                    prompt = f"""Please select a layer name from the following list that is closest to the 
                    text '{function_response['layer_name']}': {str(layer_names)}\n 
                    Only state the layer name in your response."""

                    messages = [
                        {
                            "role": "user",
                            "content": prompt,
                        },
                    ]
                    second_response = self.client.chat.completions.create(
                        model=self.model_version,
                        messages=messages,
                    )
                    second_response_message = second_response.choices[0].message.content
                    function_response['layer_name'] = second_response_message
                return {"response": function_response}
            elif response_message.get("content"):
                return {"response": response_message["content"]}
            else:
                return {"response": "I'm sorry, I don't understand."}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in NavigationAgent: " + str(e)}, 500
        return {"response": function_response}