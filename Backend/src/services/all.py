from flask import request, Response
from config.mongodb import mongo
from bson import json_util
import pandas as pd


#obtener todos los usuarios
def get_plants_services():
    data = mongo.db.plants.find()
    result = json_util.dumps(data)
    return Response(result, mimetype='application/json')

#Crear una planta
def create_plants_dataset():

    df = pd.read_excel('Backend/src/PlantasMedicinalesDataset.xlsx')
    documents = []
    for index, row in df.iterrows():
        document = {
            "nombre_comun": row['Nombre Común'] if pd.notnull(row['Nombre Común']) else None,
            "nombre_cientifico": row['Nombre Científico'] if pd.notnull(row['Nombre Científico']) else None,
            "descripcion": row['Descripción'] if pd.notnull(row['Descripción']) else None,
            "instrucciones_de_cultivo": row['Instrucciones de cultivo'] if pd.notnull(row['Instrucciones de cultivo']) else None,
            "cuidado_y_cosecha": row['Cuidado y cosecha'] if pd.notnull(row['Cuidado y cosecha']) else None,
            "usos_tradicionales": row['Usos tradicionales'].split(' / ') if pd.notnull(row['Usos tradicionales']) else None,  # Convertir a lista o None
            "infusiones": row['Infusiones'].split(' / ') if pd.notnull(row['Infusiones']) else None,  # Convertir a lista o None
            "efectos": row['Efectos'].split(' / ') if pd.notnull(row['Efectos']) else None,  # Convertir en lista o None
            "Definicion_efectos": row['Definicion Efecto'].split(' / ') if pd.notnull(row['Definicion Efecto']) else None,  # Convertir en lista o None
            "precauciones": row['Precauciones'] if pd.notnull(row['Precauciones']) else None,  # Convertir en lista o None
            "otros_antecedentes": row['Otros antecedentes'] if pd.notnull(row['Otros antecedentes']) else None,
        }
        
        # Agregar documento a la lista
        documents.append(document)

    try:
        mongo.db.plants.insert_many(documents)
        print("Datos insertados exitosamente en MongoDB")
        return Response("Datos insertados exitosamente en MongoDB", status=201)
    except Exception as e:
        print(f"Error al insertar los datos en MongoDB: {e}")
        return Response("Error al insertar los datos en MongoDB", status=400)


