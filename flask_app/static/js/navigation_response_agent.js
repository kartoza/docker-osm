class NavigationResponseAgent extends ResponseAgent {
    handleResponse(userMessage, response_data) {
        console.log("In NavigationResponseAgent.handleResponse...")
        if (response_data.name === "go_to_location") {
            this.map.flyTo({
                center: [response_data.longitude, response_data.latitude],
                zoom: 12
            });
        } else if (response_data.name === "zoom_in") {
            this.map.zoomTo(this.map.getZoom() + response_data.zoom_levels);
        } else if (response_data.name === "zoom_out") {
            this.map.zoomTo(this.map.getZoom() - response_data.zoom_levels);
        } else if (response_data.name === "pan_in_direction") {
            const lnglat = this.map.getCenter();
            var distance = 1;
            if (response_data.distance_in_kilometers) {
                distance = response_data.distance_in_kilometers;
            }
            const bearing = getBearing(response_data.direction);
            if (bearing === null) {
                return response_message;
            }
            const new_point = turf.destination(turf.point([lnglat.lng, lnglat.lat]), distance, bearing);
            console.log(new_point);
            this.map.panTo(new_point.geometry.coordinates, {
                duration: 1000
            });
        }
        return this.getResponseString(userMessage, response_data);
    }
}