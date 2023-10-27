class StyleResponseAgent extends ResponseAgent {
    handleResponse(userMessage, response_data) {
        console.log("In StyleResponseAgent.handleResponse...")
        const layer_type = this.map.getLayer(response_data.layer_name).type;
        switch (response_data.name) {
            case "set_color":
                if (layer_type === "fill") {
                    this.map.setPaintProperty(response_data.layer_name, 'fill-color', response_data.color);
                } else if (layer_type === "line") {
                    this.map.setPaintProperty(response_data.layer_name, 'line-color', response_data.color);
                }
                break;
            case "set_width":
                if (layer_type === "line") {
                    this.map.setPaintProperty(response_data.layer_name, 'line-width', response_data.width);
                }
                break;
            case "set_opacity":
                if (layer_type === "line") {
                    this.map.setPaintProperty(response_data.layer_name, 'line-opacity', response_data.opacity);
                } else if (layer_type === "fill") {
                    this.map.setPaintProperty(response_data.layer_name, 'fill-opacity', response_data.opacity);
                }
                break;
            case "set_visibility":
                if (response_data.visibility === "visible") {
                    this.map.setLayoutProperty(response_data.layer_name, 'visibility', 'visible');
                } else if (response_data.visibility === "none") {
                    this.map.setLayoutProperty(response_data.layer_name, 'visibility', 'none');
                }
                break;
            default:
                break;
        }
        return this.getResponseString(userMessage, response_data);
    }
}
