import logging
from .function_descriptions.style_function_descriptions import style_function_descriptions
import json
import openai

logger = logging.getLogger(__name__)

class StyleAgent:
    """A styling agent that has function descriptions for styling the map."""
    def set_color(self, layer_name, color):
        return {"name": "set_color", "layer_name": layer_name, "color": color}

    def set_opacity(self, layer_name, opacity):
        return {"name": "set_opacity", "layer_name": layer_name, "opacity": opacity}

    def set_width(self, layer_name, width):
        return {"name": "set_width", "layer_name": layer_name, "width": width}

    def set_visibility(self, layer_name, visibility):
        return {"name": "set_visibility", "layer_name": layer_name, "visibility": visibility}
    
    def __init__(self, model_version="gpt-3.5-turbo-0613"):
        self.model_version = model_version
        
        self.function_descriptions = style_function_descriptions

        self.messages = [
            {
                "role": "system",
                "content": """You are a helpful assistant in styling a maplibre map. 
                When asked to do something, you will call the appropriate function to style the map. Example: text mentioning 'color' should call
                a function with 'color' in the name, or text containing the word 'opacity' or 'transparency' will refer to a function with 'opacity' in the name.
                If you can't find the appropriate function, you will notify the user and ask them to provide 
                text to instruct you to style the map.""",
            },
        ]
        self.available_functions = {
            "set_color": self.set_color,
            "set_opacity": self.set_opacity,
            "set_width": self.set_width,
            "set_visibility": self.set_visibility,
        }

    def listen(self, message):
        logging.info(f"In StyleAgent.listen()...message is: {message}")
        
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

            logging.info(f"Response from OpenAI in StyleAgent: {response_message}")

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
            return {"error": "Failed to get response from OpenAI in StyleAgent: " + str(e)}, 500
        return {"response": function_response}