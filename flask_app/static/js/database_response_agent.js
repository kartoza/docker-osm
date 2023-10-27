class DatabaseResponseAgent extends ResponseAgent {
    handleResponse(userMessage, response_data) {
        console.log("In DatabaseResponseAgent.handleResponse...");
        console.log("response_data: " + JSON.stringify(response_data));
        // if (response_data.name === "get_info_from_database") {
        //     //...
        // } 
        return this.getResponseString(userMessage, response_data);
    }
}
