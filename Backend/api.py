from flask import Flask, jsonify, request

app = Flask(__name__)

# Datos de ejemplo
usuarios = [
    {"id": 1, "nombre": "Juan", "edad": 28},
    {"id": 2, "nombre": "Ana", "edad": 32},
    {"id": 3, "nombre": "Pedro", "edad": 22}
]

# Ruta para obtener todos los usuarios
@app.route('/api/usuarios', methods=['GET'])
def obtener_usuarios():
    return jsonify(usuarios)


if __name__ =="__main__":
    app.run(debug=True)