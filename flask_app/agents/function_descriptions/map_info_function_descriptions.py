select_layer_name = {
    "type": "function",
    "function": {
        "name": "select_layer_name",
        "description": "Gets a layer name from the text of a given task related to selecting layers on a map.",
        "parameters": {
            "type": "object",
            "properties": {
                "layer_name": {
                    "type": "string",
                    "description": "The name of the layer.",
                },
            },
            "required": ["layer_name"],
        },
    },
}

map_info_function_descriptions = [
    select_layer_name,
]
