import logging
from .function_descriptions.style_function_descriptions import style_function_descriptions
import json


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
    
    def __init__(self, openai, model_version="gpt-3.5-turbo-0613"):
        self.openai = openai
        self.model_version = model_version
        
        self.tools = style_function_descriptions

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
        """Listen to a message from the user."""
        logging.info(f"In StyleAgent...message is: {message}")

        self.messages.append({
            "role": "user",
            "content": message,
        })
        
        # this will be the function gpt will call if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            logger.info("Calling OpenAI API in StyleAgent...")
            response = self.openai.chat.completions.create(
                model=self.model_version,
                messages=self.messages,
                tools=self.tools,
                tool_choice="auto", 
            )
            logger.info(f"response in StyleAgent is: {response}")
            response_message = response.choices[0].message
            logger.info(f"response_message in StyleAgent is: {response_message}")
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
            return {"error": "Failed to get response from OpenAI in StyleAgent: " + str(e)}, 500
        return {"response": function_response}