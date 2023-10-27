class MapInfoResponseAgent extends ResponseAgent {
    handleResponse(userMessage, response_data) {
        console.log("In MapInfoResponseAgent.handleResponse...");
        console.log("response_data: " + JSON.stringify(response_data));
        if (response_data.name === "select_layer_name") {
            const dropdown = document.getElementById('layerDropdown');
            dropdown.value = response_data.layer_name;
        } 
        return this.getResponseString(userMessage, response_data);
    }
}
