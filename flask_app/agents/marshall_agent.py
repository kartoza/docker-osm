import json
import openai
import logging

logger = logging.getLogger(__name__)

class MarshallAgent:
    """A Marshall agent that has function descriptions for choosing the appropriate agent for a specified task."""
    def __init__(self, model_version="gpt-3.5-turbo-0613"):
        self.model_version = model_version

        #we only need one function description for this agent
        function_description = {
            "name": "choose_agent",
            "description": """Chooses an appropriate agent for a given task.""",
            "parameters": {
                "type": "object",
                "properties": {
                    "agent_name": {
                        "type": "string",
                        "description": "The name of the agent to choose. One of 'NavigationAgent', 'StyleAgent', 'MapInfoAgent', 'DatabaseAgent'.",
                    },
                },
                "required": ["agent_name"],
            },
        }
        
        self.function_descriptions = [function_description]

        self.messages = [
            {
                "role": "system",
                "content": """You are a helpful assistant that decides which agent to use for a specified task. For tasks related to getting information from 
                a database, use the DatabaseAgent. Examples include 'How many buildings are in this extent?' and 'Get geojson for all landuse polygons within this extent.'. 
                For tasks that ask to change the style of a map, such as opacity, color, or line width, you will use the StyleAgent. For tasks that ask to manipulate layers on the map,
                such as reordering, turning on and off, or getting the name of a layer, you will use the MapInfoAgent. For tasks that ask where something is, or to navigate
                the map, such as panning, zooming, or flying to a location, you will use the NavigationAgent. If you can't find the appropriate agent, say that you didn't 
                understand and ask for a more specific description of the task.""",
            },
        ]
        self.logger = logging.getLogger(__name__)

    def choose_agent(self, agent_name):
        return {"name": "choose_agent", "agent_name": agent_name}

    def listen(self, message):
        self.logger.info(f"In MarshallAgent.listen()...message is: {message}")
        """Listen to a message from the user."""
        
        # Remove the last item in self.messages. Our agent has no memory
        if len(self.messages) > 1:
            self.messages.pop()

        self.messages.append({
            "role": "user",
            "content": message,
        })
        
        # this will be the function gpt will choose if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            response = openai.ChatCompletion.create(
                model=self.model_version,
                messages=self.messages,
                functions=self.function_descriptions,
                function_call={"name": "choose_agent"},
                temperature=0,
                max_tokens=256,
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0
            )
            response_message = response["choices"][0]["message"]

            self.logger.info(f"Response from OpenAI in MarshallAgent: {response_message}")

            if response_message.get("function_call"):
                function_args = json.loads(response_message["function_call"]["arguments"])
                self.logger.info(f"Function args: {function_args}")

                # call choose agent
                function_response = self.choose_agent(**function_args)
                self.logger.info(f"Function response: {function_response}")

                return {"response": function_response}
            elif response_message.get("content"):
                return {"response": response_message["content"]}
            else:
                return {"response": "I'm sorry, I don't understand."}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in MarshallAgent: " + str(e)}, 500
        return {"response": function_response}