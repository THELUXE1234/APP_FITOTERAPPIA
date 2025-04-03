from flask import request, Response
from config.mongodb import mongo
from bson import json_util


#obtener todos los usuarios
def get_plants_services():
    data = mongo.db.plants.find()
    result = json_util.dumps(data)
    return Response(result, mimetype='application/json')

#Crear una planta
def create_plant():
    data = request.get_json()
    print("La data es:",data)
    return 'Sussesfull', 200


