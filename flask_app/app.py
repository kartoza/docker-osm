from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import os
from openai import OpenAI, NotFoundError
from dotenv import load_dotenv
import json
import psycopg2
from psycopg2 import sql
from agents.marshall_agent import MarshallAgent
from agents.navigation_agent import NavigationAgent
from agents.style_agent import StyleAgent
from agents.map_info_agent import MapInfoAgent
from agents.database_agent import DatabaseAgent
from utils.database import Database
import logging

logging.basicConfig(level=logging.INFO,
                    format='%(levelname)s %(name)s : %(message)s',
                    handlers=[logging.StreamHandler()])

logger = logging.getLogger(__name__)

load_dotenv()
app = Flask(__name__)
CORS(app)

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
model_version = os.getenv("OPENAI_MODEL_VERSION")
UPLOAD_FOLDER = 'uploads/audio'

navigation_agent = NavigationAgent(client, model_version=model_version)
marshall_agent = MarshallAgent(client, model_version=model_version)
style_agent = StyleAgent(client, model_version=model_version)
map_info_agent = MapInfoAgent(client, model_version=model_version)

def get_database_schema():
    db = Database(
        database=os.getenv("POSTGRES_DBNAME"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASS"),
        host=os.getenv("POSTGRES_HOST"),
        port=os.getenv("POSTGRES_PORT")
    )
    schema = db.get_database_info()
    db.close()
    return schema

schema = get_database_schema()
database_agent = DatabaseAgent(client, model_version, schema=schema)

@app.route('/get_query', methods=['POST'])
def get_query():
    logger.info("In get_query route...")
    message = request.json.get('message', '')
    logger.info(f"Received message in /get_query route...: {message}")
    bbox = request.json.get('bbox', '')
    logger.info(f"Received bbox in /get_query route...: {bbox}")
    return jsonify(database_agent.listen(message, bbox))

@app.route('/get_table_name', methods=['GET'])
def get_table_name():
    message = request.json.get('message', '')
    table_names = [table['table_name'] for table in schema]
    prefixed_message = f"Choose the most likely table the following text is referring to from this list:\m {table_names}.\n"
    final_message = prefixed_message + message
    logging.info(f"Received message in /get_table_name route...: {final_message}")
    response = client.chat.completions.create(
        model=model_version,
        messages=[
            {"role": "system", "content": "You are a helpful assistant that chooses a table name from a list. Only respond with the table name."},
            {"role": "user", "content": final_message},
        ],
        temperature=0,
        max_tokens=32,
        frequency_penalty=0,
        presence_penalty=0,
    )
    logging.info(f"Response from OpenAI in /get_table_name route: {response}")
    #response_message = response["choices"][0]["message"]
    return response

@app.route('/table', methods=['POST'])
def table():
    query = request.json.get('query', '')
    logging.info(f"Received query in /table route...: {query}")
    db = Database(
        database=os.getenv("POSTGRES_DBNAME"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASS"),
        host=os.getenv("POSTGRES_HOST"),
        port=os.getenv("POSTGRES_PORT")
    )
    results = db.execute(query)
    if not results:
        return "No results"
    return jsonify(results)

@app.route('/geojson', methods=['POST'])
def geojson():
    query = request.json.get('query', '')
    logging.info(f"Received message in /geojson route...: {query}")
    db = Database(
        database=os.getenv("POSTGRES_DBNAME"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASS"),
        host=os.getenv("POSTGRES_HOST"),
        port=os.getenv("POSTGRES_PORT")
    )
    results = db.execute(query)
    if not results:
        return jsonify({"type": "FeatureCollection", "features": []})
    #results = results[:5000]
    features = []
    for result in results:
        geometry_dict = json.loads(result[0])
        feature = {
            "type": "Feature",
            "properties": {},
            "geometry": geometry_dict
        }
        features.append(feature)
    feature_collection = {
        "type": "FeatureCollection",
        "features": features
    }
    db.close()
    return jsonify(feature_collection)

@app.route('/')
def index():
    return render_template('index.html')
            
@app.route('/ask', methods=['POST'])
def ask():
    message = request.json.get('message', '')
    logging.info(f"Received message: {message}") 
    return jsonify(marshall_agent.listen(message))

@app.route('/navigate', methods=['POST'])
def navigate():
    message = request.json.get('message', '')
    logging.info(f"Received message: {message}") 
    return jsonify(navigation_agent.listen(message))

@app.route('/layer', methods=['POST'])
def layer():
    message = request.json.get('message', '')
    layer_names = request.json.get('layer_names', '')
    logging.debug(f"In layer endpoint, layer_names are {layer_names} and message is {message}")  
    return jsonify(map_info_agent.listen(message, layer_names))

@app.route('/style', methods=['POST'])
def style():
    message = request.json.get('message', '')
    layer_names = request.json.get('layer_names', '')
    #logging.debug(f"In style endpoint, layer_name is {layer_names} and message is {message}")  
    #prefixed_message = f"The following is referring to the layer {layer_name}."
    #prepended_message = prefixed_message + " " + message
    #logging.debug(f"In Style route, prepended_message is {prepended_message}")  
    return jsonify(style_agent.listen(message, layer_names))

@app.route('/audio', methods=['POST'])
def upload_audio():
    audio_file = request.files['audio']
    audio_file.save(os.path.join(UPLOAD_FOLDER, "user_audio.webm"))
    audio_file=open(os.path.join(UPLOAD_FOLDER, "user_audio.webm"), 'rb')
    transcript = client.audio.transcriptions.create(
        model="whisper-1", 
        file = audio_file
    )
    logging.info(f"Received transcript: {transcript}")  
    message = transcript.text
    #delete the audio
    os.remove(os.path.join(UPLOAD_FOLDER, "user_audio.webm"))
    return message



if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
