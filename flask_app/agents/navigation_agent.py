import logging
from .function_descriptions.navigation_function_descriptions import navigation_function_descriptions
import openai
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

    def __init__(self, model_version="gpt-3.5-turbo-0613"):
        self.model_version = model_version
        self.function_descriptions = navigation_function_descriptions
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

    def listen(self, message):
        logging.info(f"In NavigationAgent.listen()...message is: {message}")
        """Listen to a message from the user."""
        #remove the last item in self.messages
        if len(self.messages) > 1:
            self.messages.pop()
        self.messages.append({
            "role": "user",
            "content": message,
        })
        
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

            logging.info(f"Response from OpenAI in NavigationAgent: {response_message}")

            if response_message.get("function_call"):
                function_name = response_message["function_call"]["name"]
                logging.info(f"Function name: {function_name}")
                function_to_call = self.available_functions[function_name]
                logging.info(f"Function to call: {function_to_call}")
                function_args = json.loads(response_message["function_call"]["arguments"])
                logging.info(f"Function args: {function_args}")
                # determine the function to call
                function_response = function_to_call(**function_args)
                logging.info(f"Function response: {function_response}")

                return {"response": function_response}
            elif response_message.get("content"):
                return {"response": response_message["content"]}
            else:
                return {"response": "I'm sorry, I don't understand."}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in NavigationAgent: " + str(e)}, 500
        return {"response": function_response}