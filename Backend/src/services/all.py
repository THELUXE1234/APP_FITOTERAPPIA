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
            "tipo_de_planta": row['Tipo de planta'] if pd.notnull(row['Tipo de planta']) else None,
            "altura": row['Altura'] if pd.notnull(row['Altura']) else None,
            "hojas": row['Hojas'] if pd.notnull(row['Hojas']) else None,
            "flores": row['flores'] if pd.notnull(row['flores']) else None,
            "periodo_de_vida": row['Periodo de vida'] if pd.notnull(row['Periodo de vida']) else None,
            "temperatura_ideal": row['Temperatura ideal'] if pd.notnull(row['Temperatura ideal']) else None,
            "exposicion_solar": row['Exposición solar'] if pd.notnull(row['Exposición solar']) else None,
            "suelo": row['Suelo'] if pd.notnull(row['Suelo']) else None,
            "propagacion": row['Propagación'] if pd.notnull(row['Propagación']) else None,
            "riego": row['Riego'] if pd.notnull(row['Riego']) else None,
            "cosecha": row['Cosecha'] if pd.notnull(row['Cosecha']) else None,
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


