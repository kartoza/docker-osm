go_to_location = {
    "type": "function",
    "function": {
        "name": "go_to_location",
        "description": "Go to a given location.",
        "parameters": {
            "type": "object",
            "properties": {
                "latitude": {
                    "type": "number",
                    "description": "The latitude to go to.",
                },
                "longitude": {
                    "type": "number",
                    "description": "The longitude to go to.",
                },
            },
            "required": ["latitude", "longitude"],
        },
    },
}

pan_in_direction = {
    "type": "function",
    "function": {
        "name": "pan_in_direction",
        "description": "Pan in a given direction and distance in kilometers.",
        "parameters": {
            "type": "object",
            "properties": {
                "direction": {
                    "type": "string",
                    "description": "The direction to pan in. One of 'north', 'south', 'east', 'west', 'northwest', 'northeast', 'southwest', 'southeast'.",
                },
                "distance_in_kilometers": {
                    "type": "number",
                    "description": "The distance to pan in kilometers. If not provided, defaults to 1.",
                },
            },
            "required": ["direction"],
        },
    },
}

zoom_in = {
    "type": "function",
    "function": {
        "name": "zoom_in",
        "description": "Zoom in by a given number of zoom levels.",
        "parameters": {
            "type": "object",
            "properties": {
                "zoom_levels": {
                    "type": "number",
                    "description": "The number of zoom levels to zoom in. If not provided, defaults to 1.",
                },
            },
            "required": ["zoom_levels"],
        },
    },
}

zoom_out = {
    "type": "function",
    "function": {
        "name": "zoom_out",
        "description": "Zoom out by a given number of zoom levels.",
        "parameters": {
            "type": "object",
            "properties": {
                "zoom_levels": {
                    "type": "number",
                    "description": "The number of zoom levels to zoom out. If not provided, defaults to 1.",
                },
            },
            "required": ["zoom_levels"],
        },
    },
}

navigation_function_descriptions = [
    go_to_location,
    pan_in_direction,
    zoom_in,
    zoom_out,
]