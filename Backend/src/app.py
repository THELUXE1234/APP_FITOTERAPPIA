from flask import Flask, jsonify, request
from dotenv import load_dotenv
import os

from config.mongodb import mongo
from routes.all import all

load_dotenv()

app = Flask(__name__)

app.config['MONGO_URI'] = os.getenv('MONGO_URI')
mongo.init_app(app)

@app.route('/')
def index():
    return 0

app.register_blueprint(all, url_prefix='/api')

if __name__ =="__main__":
    app.run(debug=True, host="0.0.0.0", port=3000)