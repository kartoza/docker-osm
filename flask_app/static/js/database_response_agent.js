class DatabaseResponseAgent extends ResponseAgent {
    handleResponse(userMessage, response_data) {
        // ### Example response_data: {'name': 'ask_database', 'sql_query': "SELECT ST_AsGeoJSON(ST_Transform(way, 4326)) FROM planet_osm_polygon WHERE building = 'school';"}
        console.log("In DatabaseResponseAgent.handleResponse...")
        console.log(`DatabaseResponseAgent response_data: ${JSON.stringify(response_data)}`);
        if (response_data.name === "get_geojson_from_database") {
            console.log(`DatabaseResponseAgent response_data: ${JSON.stringify(response_data)}`);
            const geojson = fetch('/geojson', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(response_data)
            })
            .then(response => response.json())
            .then(data => {
                console.log("DatabaseResponseAgent data: ", data);
                if (data.features.length > 0) {
                    //remove the previous layer
                    if (this.map.getLayer('query_result')) {
                        this.map.removeLayer('query_result');
                        this.map.removeSource('geojson');
                    }
                    this.map.addSource('geojson', {
                        'type': 'geojson',
                        'data': data
                    });
                    this.map.addLayer({
                        "id": "query_result",
                        "type": "fill",
                        "source": "geojson",
                        'layout': {},
                        'paint': {
                          'fill-color': '#ff0000',
                          'fill-opacity': 0.4
                        }
                    });

                    //add the layer to the dropdown
                    const dropdown = document.getElementById('layerDropdown');
                    var option = document.createElement("option");
                    option.text = "query_result";
                    option.value = "query_result";
                    console.log("Dropdown: ");
                    console.log(dropdown);
                    dropdown.add(option);

                    //select the layer in the dropdown
                    dropdown.value = "query_result";
                    
                    //zoom to the new layer
                    var bounds = new maplibregl.LngLatBounds();
                    data.features.forEach(function(feature) {
                        feature.geometry.coordinates[0].forEach(function(coord) {
                            bounds.extend(coord);
                        });
                    });
                    this.map.fitBounds(bounds, {
                        padding: 20
                    });
                } else {
                    console.log("DatabaseResponseAgent: No features found.");
                    return this.getResponseString(userMessage, "No features found.");
                }
            })
            .catch(error => console.log(error));
        } else if (response_data.name === "get_table_from_database") {
            fetch('/table', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(response_data)
            })
            .then(response => response.json())
            .then(data => {
                console.log("DatabaseResponseAgent get_table_from_database data: ", data);
                if (data.length > 0) {
                    return this.getResponseString(userMessage, data[0][0]);
                } else {
                    console.log("DatabaseResponseAgent: Nothing found.");
                    return this.getResponseString(userMessage, "Nothing found.");
                }
            })
            console.log(`DatabaseResponseAgent General Info response_data: ${JSON.stringify(response_data)}`);
        }
        return this.getResponseString(userMessage, response_data);
    }
}