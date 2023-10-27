
set_color = {
    "name": "set_color",
    "description": "Set the maplibre paint property color of a layer.",
    "parameters": {
        "type": "object",
        "properties": {
            "layer_name": {
                "type": "string",
                "description": "The name of the layer.",
            },
            "color": {
                "type": "string", 
                "description": "The color to set in hex format.",
            },
        },
        "required": ["layer_name", "color"],
    },
}

set_opacity = {
    "name": "set_opacity",
    "description": "Set the maplibre paint property opacity of a layer.",
    "parameters": {
        "type": "object",
        "properties": {
            "layer_name": {
                "type": "string",
                "description": "The name of the layer.",
            },
            "opacity": {
                "type": "number",
                "description": "The opacity to set between 0 and 1.",
            },
        },
        "required": ["layer_name", "opacity"],
    },
}

set_width = {
    "name": "set_width",
    "description": "Set the maplibre paint property width.",
    "parameters": {
        "type": "object",
        "properties": {
            "layer_name": {
                "type": "string",
                "description": "The name of the layer to get the paint property for.",
            },
            "width": {
                "type": "number",
                "description": "The width to set.",
            },
        },
        "required": ["layer_name", "width"],
    },
}

set_visibility = {
    "name": "set_visibility",
    "description": "Set the visibility of a layer (turning it on or off).",
    "parameters": {
        "type": "object",
        "properties": {
            "layer_name": {
                "type": "string",
                "description": "The name of the layer to get the layout property for.",
            },
            "visibility": {
                "type": "string",
                "description": "Either 'visible' or 'none'. Set to 'none' to hide the layer.",
            },
        },
        "required": ["layer_name", "visible"],
    },
}

style_function_descriptions = [
    set_color,
    set_opacity,
    set_width,
    set_visibility,
]