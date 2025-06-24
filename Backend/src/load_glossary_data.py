# load_glossary_data.py
import os
from flask import Flask
from config.mongodb import mongo  # Asegúrate de que esta importación sea correcta
from bson.objectid import ObjectId # Necesario para manejar IDs de MongoDB
from dotenv import load_dotenv
# 1. Configura tu aplicación Flask mínimamente para acceder a MongoDB
# Esto simula un contexto de aplicación Flask para que `mongo.db` esté disponible.
load_dotenv()

app = Flask(__name__)

app.config['MONGO_URI'] = os.getenv('MONGO_URI')
app.secret_key = os.getenv('SECRET_KEY')

# Inicializa Flask-PyMongo con la aplicación
mongo.init_app(app)

# Lista de términos del glosario extraídos de tu archivo .docx
# Asegúrate de que esta lista sea una representación exacta de tu glosario.
glossary_terms = [
    # Propiedades Terapéuticas
    {"category": "Propiedades Terapéuticas", "term": "Analgésico", "definition": "Reduce o elimina el dolor."},
    {"category": "Propiedades Terapéuticas", "term": "Antibacteriano", "definition": "Mata bacterias o impide su crecimiento."},
    {"category": "Propiedades Terapéuticas", "term": "Antiespasmódico", "definition": "Alivia o previene espasmos musculares, especialmente en el tracto digestivo."},
    {"category": "Propiedades Terapéuticas", "term": "Antiinflamatorio", "definition": "Reduce o previene la inflamación."},
    {"category": "Propiedades Terapéuticas", "term": "Antiséptico", "definition": "Elimina o impide el crecimiento de microorganismos en tejidos vivos."},
    {"category": "Propiedades Terapéuticas", "term": "Antitusivo", "definition": "Calma o suprime la tos."},
    {"category": "Propiedades Terapéuticas", "term": "Astringente", "definition": "Contrae tejidos, reduce secreciones y puede ayudar a controlar hemorragias y diarreas."},
    {"category": "Propiedades Terapéuticas", "term": "Balsámico", "definition": "Suaviza y calma las mucosas respiratorias; expectorante suave."},
    {"category": "Propiedades Terapéuticas", "term": "Carminativo", "definition": "Facilita la expulsión de gases intestinales."},
    {"category": "Propiedades Terapéuticas", "term": "Cicatrizante", "definition": "Favorece la regeneración de tejidos dañados."},
    {"category": "Propiedades Terapéuticas", "term": "Demulcente", "definition": "Forma una película protectora sobre mucosas irritadas."},
    {"category": "Propiedades Terapéuticas", "term": "Depurativo", "definition": "Ayuda a eliminar toxinas del cuerpo, principalmente a través de la orina."},
    {"category": "Propiedades Terapéuticas", "term": "Digestivo", "definition": "Facilita la digestión."},
    {"category": "Propiedades Terapéuticas", "term": "Diurético", "definition": "Aumenta la producción de orina."},
    {"category": "Propiedades Terapéuticas", "term": "Emenagogo", "definition": "Estimula o favorece el flujo menstrual."},
    {"category": "Propiedades Terapéuticas", "term": "Emoliente", "definition": "Suaviza, hidrata o protege la piel y mucosas."},
    {"category": "Propiedades Terapéuticas", "term": "Expectorante", "definition": "Favorece la expulsión de mucosidades de las vías respiratorias."},
    {"category": "Propiedades Terapéuticas", "term": "Febrífugo", "definition": "Disminuye la fiebre."},
    {"category": "Propiedades Terapéuticas", "term": "Galactógeno", "definition": "Estimula la producción de leche materna."},
    {"category": "Propiedades Terapéuticas", "term": "Hemostático", "definition": "Detiene o disminuye el sangrado."},
    {"category": "Propiedades Terapéuticas", "term": "Rubefaciente", "definition": "Provoca enrojecimiento de la piel aumentando la circulación sanguínea en la zona."},
    {"category": "Propiedades Terapéuticas", "term": "Sedante", "definition": "Calma el sistema nervioso, reduce ansiedad o insomnio."},
    {"category": "Propiedades Terapéuticas", "term": "Tocolítico", "definition": "Disminuye las contracciones uterinas."},
    {"category": "Propiedades Terapéuticas", "term": "Vermífugo", "definition": "Elimina parásitos intestinales."},

    # Preparaciones
    {"category": "Preparaciones", "term": "Infusión", "definition": "Preparación líquida al verter agua a alta temperatura sobre la parte útil de la planta, reposar y filtrar."},
    {"category": "Preparaciones", "term": "Decocción", "definition": "Cocinar partes útiles de la planta en agua hirviendo por varios minutos."},
    {"category": "Preparaciones", "term": "Maceración", "definition": "Remojar el vegetal en agua (u otro solvente) a temperatura ambiente durante varias horas."},
    {"category": "Preparaciones", "term": "Tintura", "definition": "Maceración de la planta en alcohol para extraer sus principios activos."},
    {"category": "Preparaciones", "term": "Vahos", "definition": "Inhalación de vapor caliente con principios activos disueltos en agua."},
    {"category": "Preparaciones", "term": "Compresa", "definition": "Paño humedecido con una infusión aplicado sobre la piel."},
    {"category": "Preparaciones", "term": "Friegas/Frotaciones", "definition": "Aplicación de una preparación sobre la piel mediante fricción."},
    {"category": "Preparaciones", "term": "Gargarismo", "definition": "Hacer enjuagues con una infusión, sin tragarla."},
    {"category": "Preparaciones", "term": "Pomada", "definition": "Preparación semisólida para aplicar en piel o mucosas."},

    # Condiciones de Salud
    {"category": "Condiciones de Salud", "term": "Afecciones nerviosas", "definition": "Trastornos del sistema nervioso como ansiedad, insomnio o depresión, entre otras."},
    {"category": "Condiciones de Salud", "term": "Alteraciones del ciclo menstrual", "definition": "Irregularidades en la menstruación, como retrasos, ausencia o menstruación abundante o dolorosa."},
    {"category": "Condiciones de Salud", "term": "Arritmias cardíacas", "definition": "Trastornos en el ritmo del corazón (latidos irregulares)."},
    {"category": "Condiciones de Salud", "term": "Catarros", "definition": "Infección leve de las vías respiratorias con mucosidad (resfrío común)."},
    {"category": "Condiciones de Salud", "term": "Cicatrizante", "definition": "Favorece la regeneración de tejidos y la curación de heridas."},
    {"category": "Condiciones de Salud", "term": "Colitis", "definition": "Inflamación del colon, suele causar dolor abdominal, gases y diarrea."},
    {"category": "Condiciones de Salud", "term": "Dermatitis", "definition": "Inflamación de la piel que puede producir picazón, enrojecimiento o descamación."},
    {"category": "Condiciones de Salud", "term": "Dispepsia", "definition": "Dificultad de la digestión; incluye síntomas como pesadez, dolor estomacal o gases."},
    {"category": "Condiciones de Salud", "term": "Dismenorrea", "definition": "Dolor menstrual intenso."},
    {"category": "Condiciones de Salud", "term": "Eccemas", "definition": "Lesiones inflamatorias de la piel, que generan enrojecimiento, picor y descamación."},
    {"category": "Condiciones de Salud", "term": "Fotodermatitis", "definition": "Inflamación de la piel causada por una reacción de sensibilidad a la radiación solar."},
    {"category": "Condiciones de Salud", "term": "Flatulencia", "definition": "Exceso de gases en el intestino."},
    {"category": "Condiciones de Salud", "term": "Gingivitis", "definition": "Inflamación de las encías."},
    {"category": "Condiciones de Salud", "term": "Hemorroides", "definition": "Venas inflamadas en la zona del recto o ano."},
    {"category": "Condiciones de Salud", "term": "Hiperhidrosis", "definition": "Sudoración excesiva, más allá de lo necesario para regular la temperatura corporal."},
    {"category": "Condiciones de Salud", "term": "Hiperplasia prostática benigna", "definition": "Agrandamiento no canceroso de la próstata, que dificulta la micción."},
    {"category": "Condiciones de Salud", "term": "Indigestión", "definition": "Malestar general en el aparato digestivo después de comer."},
    {"category": "Condiciones de Salud", "term": "Meteorismo", "definition": "Acumulación excesiva de gases en el intestino."},
    {"category": "Condiciones de Salud", "term": "Nicturia", "definition": "Necesidad de orinar varias veces durante la noche."},
    {"category": "Condiciones de Salud", "term": "Poliuria", "definition": "Aumento anormal del volumen de orina."},
    {"category": "Condiciones de Salud", "term": "Resfrío", "definition": "Infección leve del tracto respiratorio superior."},
    {"category": "Condiciones de Salud", "term": "Tos seca", "definition": "Tos sin expectoración o mucosidad."},

    # Términos agronómicos y botánicos
    {"category": "Términos agronómicos y botánicos", "term": "Ápice", "definition": "Extremo superior de un órgano de la planta (ápice de la hoja, del fruto, etc.)."},
    {"category": "Términos agronómicos y botánicos", "term": "Achenio", "definition": "Tipo de fruto seco, pequeño, que no se abre al madurar y contiene una sola semilla."},
    {"category": "Términos agronómicos y botánicos", "term": "Axila (de la hoja)", "definition": "Parte de la planta entre la hoja y el tallo, de donde pueden surgir brotes o flores."},
    {"category": "Términos agronómicos y botánicos", "term": "Basal", "definition": "Que se encuentra en la base de la planta."},
    {"category": "Términos agronómicos y botánicos", "term": "Calcáreo", "definition": "Suelo que contiene alto contenido de carbonato de calcio; suele ser seco y con pH alcalino."},
    {"category": "Términos agronómicos y botánicos", "term": "Cosecha", "definition": "Recolección de las partes útiles de una planta, como hojas, flores o raíces."},
    {"category": "Términos agronómicos y botánicos", "term": "Dentado", "definition": "Se refiere al borde de las hojas que presenta pequeñas hendiduras o dientes."},
    {"category": "Términos agronómicos y botánicos", "term": "División de matas / plantas", "definition": "Método de propagación que consiste en separar una planta en varias partes para generar nuevos individuos."},
    {"category": "Términos agronómicos y botánicos", "term": "Encharcamiento", "definition": "Acumulación excesiva de agua en el suelo, que puede dañar las raíces."},
    {"category": "Términos agronómicos y botánicos", "term": "Envés", "definition": "Cara inferior de la hoja."},
    {"category": "Términos agronómicos y botánicos", "term": "Espiga (floral)", "definition": "Inflorescencia con flores agrupadas a lo largo de un tallo central."},
    {"category": "Términos agronómicos y botánicos", "term": "Esqueje", "definition": "Fragmento de planta (generalmente un tallo) que se utiliza para reproducir una nueva planta."},
    {"category": "Términos agronómicos y botánicos", "term": "Estolón", "definition": "Tallo rastrero que produce raíces y brotes para formar una nueva planta."},
    {"category": "Términos agronómicos y botánicos", "term": "Floración", "definition": "Periodo en que una planta produce flores."},
    {"category": "Términos agronómicos y botánicos", "term": "Fructificación", "definition": "Etapa del desarrollo en la que la planta forma frutos."},
    {"category": "Términos agronómicos y botánicos", "term": "Herboristería", "definition": "Actividad relacionada con el cultivo, recolección y uso de plantas medicinales."},
    {"category": "Términos agronómicos y botánicos", "term": "Hierba anual", "definition": "Planta que cumple su ciclo de vida en un solo año."},
    {"category": "Términos agronómicos y botánicos", "term": "Hierba perenne", "definition": "Planta herbácea que vive varios años."},
    {"category": "Términos agronómicos y botánicos", "term": "Inflorescencia", "definition": "Conjunto de flores agrupadas en una estructura común."},
    {"category": "Términos agronómicos y botánicos", "term": "Leñoso", "definition": "Que tiene consistencia similar a la madera; se refiere comúnmente a tallos o ramas."},
    {"category": "Términos agronómicos y botánicos", "term": "Margen (de hoja)", "definition": "Borde de la hoja."},
    {"category": "Términos agronómicos y botánicos", "term": "Nervadura", "definition": "Conjunto de venas o nervios de una hoja."},
    {"category": "Términos agronómicos y botánicos", "term": "Parte útil", "definition": "Parte de la planta que contiene principios activos de interés."},
    {"category": "Términos agronómicos y botánicos", "term": "Peciolado", "definition": "Hojas unidas al tallo por un pecíolo (tallo delgado)."},
    {"category": "Términos agronómicos y botánicos", "term": "Permeable", "definition": "Que permite el paso del agua fácilmente; referido comúnmente al suelo."},
    {"category": "Términos agronómicos y botánicos", "term": "Piloso", "definition": "Cubierto de pequeños pelos."},
    {"category": "Términos agronómicos y botánicos", "term": "Pivotante (raíz)", "definition": "Tipo de raíz principal, gruesa y profunda."},
    {"category": "Términos agronómicos y botánicos", "term": "Propagación", "definition": "Reproducción o multiplicación de una planta."},
    {"category": "Términos agronómicos y botánicos", "term": "Ramillete", "definition": "Agrupación de flores con disposición compacta y ramificada."},
    {"category": "Términos agronómicos y botánicos", "term": "Riego", "definition": "Acción de proporcionar agua a las plantas."},
    {"category": "Términos agronómicos y botánicos", "term": "Rizoma", "definition": "Tallo subterráneo horizontal que emite raíces y brotes."},
    {"category": "Términos agronómicos y botánicos", "term": "Roseta (de hojas)", "definition": "Disposición circular de las hojas en la base de la planta."},
    {"category": "Términos agronómicos y botánicos", "term": "Semisombra", "definition": "Lugar donde la luz solar llega parcialmente."},
    {"category": "Términos agronómicos y botánicos", "term": "Subarbusto", "definition": "Planta de pequeño tamaño, con base leñosa y partes superiores herbáceas."},
    {"category": "Términos agronómicos y botánicos", "term": "Suelo fértil", "definition": "Tierra rica en nutrientes, adecuada para el crecimiento de plantas."},
    {"category": "Términos agronómicos y botánicos", "term": "Temperatura óptima", "definition": "Rango de temperatura ideal para el desarrollo de una planta."},
    {"category": "Términos agronómicos y botánicos", "term": "Tolerancia a sequía / heladas", "definition": "Capacidad de una planta para resistir la falta de agua o temperaturas bajo cero."},
    {"category": "Términos agronómicos y botánicos", "term": "Vilano (o papus)", "definition": "Estructura plumosa en los frutos del diente de león, ayuda a la dispersión por el viento"}
]

# 2. Ejecuta la inserción dentro del contexto de la aplicación Flask
with app.app_context():
    print("Iniciando la carga de datos del glosario...")
    try:
        inserted_count = 0
        skipped_count = 0
        # Iterar sobre cada término y verificar si ya existe antes de insertar
        for term_data in glossary_terms:
            # Buscar un término con la misma categoría y el mismo término
            existing_term = mongo.db.glosario.find_one(
                {'category': term_data['category'], 'term': term_data['term']}
            )
            if not existing_term:
                # Si no existe, insertarlo
                mongo.db.glosario.insert_one(term_data)
                print(f"Insertado: Categoría: '{term_data['category']}', Término: '{term_data['term']}'")
                inserted_count += 1
            else:
                print(f"Saltando (ya existe): Categoría: '{term_data['category']}', Término: '{term_data['term']}'")
                skipped_count += 1
        
        print("\n--- Resumen de la Carga ---")
        print(f"Términos insertados: {inserted_count}")
        print(f"Términos saltados (ya existían): {skipped_count}")
        print("Carga de datos del glosario completada.")

    except Exception as e:
        print(f"Error al cargar datos del glosario: {e}")