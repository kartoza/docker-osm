class ResponseAgent {
    constructor(map) {
        this.map = map;
    }

    getResponseString(userMessage, response_data) {
        console.log("In ResponseAgent.getResponseString...")
        console.log(response_data)
        return "You: " + userMessage + "\nAI: " + JSON.stringify(response_data) + "\n" 
    }
}
