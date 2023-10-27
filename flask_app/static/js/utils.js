function get_layer_names(map) {
    var layer_names = [];
    var layers = map.getStyle().layers;
    for (var i = 0; i < layers.length; i++) {
        layer_names.push(layers[i].id);
    }
    return layer_names;
} 

function getBearing(direction) {
    if (direction == 'north') {
        return 0;
    } 
    else if (direction == 'east') {
        return 90;
    } 
    else if (direction == 'south') {
        return 180;
    }
    else if (direction == 'west') {
        return -90;
    }
    else if (direction == 'northeast') {
        return 45;
    }
    else if (direction == 'southeast') {
        return 135;
    }
    else if (direction == 'southwest') {
        return -135;
    } else if (direction == 'northwest') {
        return -45;
    } else {
        return null;
    }
}

function getResponseString(userMessage, response_data) {
    console.log("In getResponseString...")
    console.log(typeof response_data)
    console.log(response_data)
    return "You: " + userMessage + "\nAI: " + JSON.stringify(response_data) + "\n" 
}