from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import os
import openai
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

logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s',
                    handlers=[logging.StreamHandler()])

load_dotenv()
app = Flask(__name__)
CORS(app)

#openai.organization = os.getenv("OPENAI_ORGANIZATION")
openai.api_key = os.getenv("OPENAI_API_KEY")
model_version = os.getenv("OPENAI_MODEL_VERSION")
UPLOAD_FOLDER = 'uploads/audio'

navigation_agent = NavigationAgent(model_version=model_version)
marshall_agent = MarshallAgent(model_version=model_version)
style_agent = StyleAgent(model_version=model_version)
map_info_agent = MapInfoAgent(model_version=model_version)

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
database_agent = DatabaseAgent(model_version=model_version, schema=schema)

@app.route('/database', methods=['POST'])
def database():
    message = request.json.get('message', '')
    logging.info(f"Received message: {message}") 
    return jsonify(database_agent.listen(message))

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
    layer_name = request.json.get('layer_name', '')
    logging.debug(f"In style endpoint, layer_name is {layer_name} and message is {message}")  
    prefixed_message = f"The following is referring to the layer {layer_name}."
    prepended_message = prefixed_message + " " + message
    logging.debug(f"In Style route, prepended_message is {prepended_message}")  
    return jsonify(style_agent.listen(prepended_message))

@app.route('/audio', methods=['POST'])
def upload_audio():
    audio_file = request.files['audio']
    audio_file.save(os.path.join(UPLOAD_FOLDER, "user_audio.webm"))
    audio_file=open(os.path.join(UPLOAD_FOLDER, "user_audio.webm"), 'rb')
    transcript = openai.Audio.transcribe("whisper-1", audio_file)
    logging.info(f"Received transcript: {transcript}")  
    message = transcript['text']
    #delete the audio
    os.remove(os.path.join(UPLOAD_FOLDER, "user_audio.webm"))
    return message



if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
