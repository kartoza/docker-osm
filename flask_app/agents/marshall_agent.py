import json
#import openai
import logging

logger = logging.getLogger(__name__)

class MarshallAgent:
    """A Marshall agent that has function descriptions for choosing the appropriate agent for a specified task."""
    def __init__(self, openai, model_version="gpt-3.5-turbo-0613"):
        self.model_version = model_version
        self.openai = openai
        self.tools = [
            {
                "type": "function",
                "function": {
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
                },
            },
        ]
        self.system_message = """You are a helpful assistant that decides which agent to use for a specified task.
                
                For tasks related to adding layers and other geospatial data to the map, use the DatabaseAgent.
                Examples include 'add buildings to the map' and 'get landuse polygons within this extent'.

                For tasks that ask to change the style of a map, such as opacity, color, or line width, you will 
                use the StyleAgent. Examples StyleAgent prompts include 'change color to green', 'opacity 45%'
                and 'line width 4'. 
                
                For tasks related to getting the name of a layer, you will use the MapInfoAgent. 
                Example MapInfoAgent prompts include 'select the water layer' and 'select buildings'. 
                
                For tasks that ask where something is, or task you with navigate the map, such as panning, zooming,
                or flying to a location, you will use the NavigationAgent. Example NavigationAgent prompts include 
                'go to Paris', 'show me the Statue of Liberty', and 'where is Houston, Texas?'
                
                If you can't find the appropriate agent, say that you didn't understand and ask 
                for a more specific description of the task."""

        #initialize the messages queue with the system message
        self.messages = [{"role": "system", "content": self.system_message}]
        self.available_functions = {
            "choose_agent": self.choose_agent,
        }
        self.logger = logging.getLogger(__name__)

    def choose_agent(self, agent_name):
        return {"name": "choose_agent", "agent_name": agent_name}

    def listen(self, message):
        self.logger.info(f"In MarshallAgent.listen()...message is: {message}")
        """Listen to a message from the user."""
        
        # # Remove the last item in self.messages. Our agent has no memory
        # if len(self.messages) > 1:
        #     self.messages.pop()

        self.messages.append({
            "role": "user",
            "content": message,
        })
        
        # this will be the function gpt will choose if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            response = self.openai.chat.completions.create(
                model=self.model_version,
                messages=self.messages,
                tools=self.tools,
                tool_choice={"type": "function", "function": {"name": "choose_agent"}}, 
            )
            response_message = response.choices[0].message
            tool_calls = response_message.tool_calls

            if tool_calls:
                available_functions = self.available_functions
                self.messages.append(response_message)
                for tool_call in tool_calls:
                    function_name = tool_call.function.name
                    function_to_call = available_functions[function_name]
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
                # second_response = self.openai.chat.completions.create(
                #     model=self.model_version,
                #     messages=self.messages,
                # )
                logger.info(f"Sucessful MarallAgent task completion: {function_response}")
                return {"response": function_response}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in MarshallAgent: " + str(e)}, 500
        return {"response": function_response}