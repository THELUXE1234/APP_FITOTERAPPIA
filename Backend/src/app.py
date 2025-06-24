from flask import Flask, jsonify, request, render_template, redirect, url_for, send_from_directory
from flask_cors import CORS
from dotenv import load_dotenv
import os

from config.mongodb import mongo
from routes.all import all
from routes.admin import admin

load_dotenv()

app = Flask(__name__)
CORS(app)
app.config['MONGO_URI'] = os.getenv('MONGO_URI')
app.secret_key = os.getenv('SECRET_KEY')

# Ruta para subir imágenes
UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__),'static', 'img')
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

mongo.init_app(app)

@app.route('/')
def index():
    return redirect(url_for('admin.login_admin'))

app.register_blueprint(all, url_prefix='/api')
app.register_blueprint(admin)

if __name__ =="__main__":
    app.run(debug=True, host="0.0.0.0")