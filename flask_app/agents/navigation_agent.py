import logging
from .function_descriptions.navigation_function_descriptions import navigation_function_descriptions
#import client
import json

logger = logging.getLogger(__name__)

class NavigationAgent:
    """A navigation agent that uses function calling for navigating the map."""
    
    def go_to_location(self, latitude, longitude):
        return {"name": "go_to_location", "latitude": latitude, "longitude": longitude}

    def pan_in_direction(self, direction, distance_in_kilometers=1):
        return {"name": "pan_in_direction", "direction": direction, "distance_in_kilometers": distance_in_kilometers}

    def zoom_in(self, zoom_levels=1):
        return {"name": "zoom_in", "zoom_levels": zoom_levels}
    
    def zoom_out(self, zoom_levels=1):
        return {"name": "zoom_out", "zoom_levels": zoom_levels}

    def __init__(self, client, model_version):
        self.client = client
        self.model_version = model_version
        self.messages = [
            {
                "role": "system",
                "content": """You are a helpful assistant in navigating a maplibre map. When tasked to do something, you will call the appropriate function to navigate the map.

                Examples tasks to go to a location include: 'Go to Tokyo', 'Where is the Eiffel Tower?', 'Navigate to New York City'

                Examples tasks to pan in a direction include: 'Pan north 3 km', 'Pan ne 1 kilometer', 'Pan southwest', 'Pan east 2 kilometers', 'Pan south 5 kilometers', 'Pan west 1 kilometer', 'Pan northwest 2 kilometers', 'Pan southeast 3 kilometers'

                Examples tasks to zoom in or zoom out include: 'Zoom in 2 zoom levels.', 'Zoom out 3', 'zoom out', 'zoom in', 'move closer', 'move in', 'get closer', 'move further away', 'get further away', 'back out', 'closer' """,
            },
        ]
        self.available_functions = {
            "go_to_location": self.go_to_location,
            "pan_in_direction": self.pan_in_direction,
            "zoom_in": self.zoom_in,
            "zoom_out": self.zoom_out,
        }
        self.tools = navigation_function_descriptions

    def listen(self, message):
        logging.info(f"In NavigationAgent...message is: {message}")
        """Listen to a message from the user."""
        # #remove the last item in self.messages
        # if len(self.messages) > 1:
        #     self.messages.pop()
        self.messages.append({
            "role": "user",
            "content": message,
        })
        
        # this will be the function gpt will call if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            logger.info("Calling OpenAI API in NavigationAgent...")
            response = self.client.chat.completions.create(
                model=self.model_version,
                messages=self.messages,
                tools=self.tools,
                tool_choice="auto", 
            )
            response_message = response.choices[0].message
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
                logger.info("Sucessful NavigationAgent task completion.")
                return {"response": function_response}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in NavigationAgent: " + str(e)}, 500
        return {"response": function_response}