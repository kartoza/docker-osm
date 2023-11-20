import json
import logging

logger = logging.getLogger(__name__)

class MarshallAgent:
    """A Marshall agent that has function descriptions for choosing the appropriate agent for a specified task."""
    def __init__(self, client, model_version):
        self.model_version = model_version
        self.client = client
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
                                "description": "The name of the agent to choose. One of 'NavigationAgent', 'StyleAgent', 'DatabaseAgent'.",
                            },
                        },
                        "required": ["agent_name"],
                    },
                },
            },
        ]
        self.system_message = """You are a helpful assistant that decides which agent to use for a specified task.
                
                For tasks related to adding layers and other geospatial data to the map, use the DatabaseAgent.
                Examples include 'add buildings to the map', 'show industrial buildings', and 'get landuse polygons within this extent'.

                For tasks that change the style of a map, such as selecting a layer to style, changing the opacity, color, 
                or line width of a layer, you will use the StyleAgent. Example StyleAgent prompts include 'change color to green', 
                'select the buildings layer', 'opacity 45%', 'select water', and 'line width 4'. 
                
                For tasks to navigate the map, such as panning, zooming, or flying to a location, you will use the NavigationAgent. 
                Example NavigationAgent prompts include 'go to Paris', 'show me the Statue of Liberty', and 'fly to Houston, Texas'
                
                If you can't find the appropriate agent, say that you didn't understand and ask 
                for a more specific description of the task."""

        #initialize the messages queue with the system message
        self.messages = [{"role": "system", "content": self.system_message}]
        self.available_functions = {
            "choose_agent": self.choose_agent,
        }
        

    def choose_agent(self, agent_name):
        return {"name": "choose_agent", "agent_name": agent_name}

    def listen(self, message):
        logger.info(f"In MarshallAgent.listen()...message is: {message}")
        """Listen to a message from the user."""

        self.messages.append({
            "role": "user",
            "content": message,
        })
        
        # this will be the function gpt will choose if it 
        # determines that the user wants to call a function
        function_response = None

        try:
            response = self.client.chat.completions.create(
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
                logger.info(f"Sucessful MarshallAgent task completion: {function_response}")
                return {"response": function_response}
        
        except Exception as e:
            return {"error": "Failed to get response from OpenAI in MarshallAgent: " + str(e)}, 500
        return {"response": function_response}