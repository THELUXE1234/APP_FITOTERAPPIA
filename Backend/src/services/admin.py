import os
from flask import request, render_template, redirect, url_for, session, flash, current_app
from config.mongodb import mongo
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename
from bson.objectid import ObjectId

def extraer_lista_desde_textarea(texto):
    """Convierte un texto con saltos de línea en una lista, eliminando elementos vacíos."""
    if texto:
        return [item.strip() for item in texto.split('\n') if item.strip()]
    return []

def login_admin_service():
    if 'admin_id' in session:
        return redirect(url_for('admin.listar_plantas'))
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        # print("email",email )
        # print("password",password )

        admin = mongo.db.users.find_one({'email': email})
        if admin and check_password_hash(admin['password'], password):
            session['admin_id'] = str(admin['_id'])
            session["admin_username"] = admin["name"]
            flash('Inicio de sesión exitoso')
            return redirect(url_for('admin.listar_plantas'))  # Redirigir a página de plantas o dashboard
        else:
            flash('Credenciales inválidas')
    
    return render_template('login.html')

def register_admin_service():
    if 'admin_id' in session:
        return redirect(url_for('admin.listar_plantas'))
    if request.method == 'POST':
        email = request.form['email']
        name = request.form['name']
        password = request.form['password']
        hashed_password = generate_password_hash(password)
        # print("password:",name)
        # print("email:",email)
        # print("password:",password)
        # print("hashed_password:", hashed_password)

        existing = mongo.db.users.find_one({'email': email})
        if existing:
            flash('El correo ya está registrado')
            return redirect(url_for('admin.register_admin'))

        mongo.db.users.insert_one({'name': name, 'email': email, 'password': hashed_password})
        flash('Administrador registrado exitosamente')
        return redirect(url_for('admin.login_admin'))

    return render_template('register.html')

def logout_admin_service():
    session.pop('admin_id', None)
    return redirect('/login')

def create_plant_service():
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta página.")
        return redirect(url_for('admin.login_admin'))

    if request.method == 'POST':

        usos_tradicionales = extraer_lista_desde_textarea(request.form.get("usos_tradicionales"))
        infusiones = extraer_lista_desde_textarea(request.form.get("infusiones"))
        efectos = extraer_lista_desde_textarea(request.form.get("efectos"))
        definiciones = extraer_lista_desde_textarea(request.form.get("Definicion_efectos"))


        nombre_comun = request.form['nombre_comun'].strip()

        data = {
            'nombre_comun': nombre_comun,
            'nombre_cientifico': request.form['nombre_cientifico'],
            'descripcion': request.form['descripcion'],
            'instrucciones_de_cultivo': request.form['instrucciones_de_cultivo'],
            'cuidado_y_cosecha': request.form['cuidado_y_cosecha'],
            "usos_tradicionales": usos_tradicionales,
            "infusiones": infusiones,
            "efectos": efectos,
            "Definicion_efectos": definiciones,
            'precauciones': request.form['precauciones'],
            'otros_antecedentes': request.form['otros_antecedentes'],
            'tipo_de_planta': request.form['tipo_de_planta'],
            'altura': request.form['altura'],
            'hojas': request.form['hojas'],
            'flores': request.form['flores'],
            'periodo_de_vida': request.form['periodo_de_vida'],
            'temperatura_ideal': request.form['temperatura_ideal'],
            'exposicion_solar': request.form['exposicion_solar'],
            'suelo': request.form['suelo'],
            'propagacion': request.form['propagacion'],
            'riego': request.form['riego'],
            'cosecha': request.form['cosecha'],
        }

        # Insertar la planta primero para tener el _id si se requiere
        result = mongo.db.plants.insert_one(data)

        # SUBIR IMÁGENES IGUAL QUE EN editar_planta_service
        imagenes = {
            'main_image': f"{nombre_comun.lower()}.jpg",
            'side_image_1': f"{nombre_comun.lower()}_1.jpg",
            'side_image_2': f"{nombre_comun.lower()}_2.jpg",
            'side_image_3': f"{nombre_comun.lower()}_3.jpg"
        }
        upload_folder = current_app.config['UPLOAD_FOLDER']
        for field, filename in imagenes.items():
            file = request.files.get(field)
            if file and allowed_file(file.filename):
                filename_seguro = secure_filename(filename)
                filepath = os.path.join(upload_folder, filename_seguro)
                file.save(filepath)

        flash('Planta registrada exitosamente')
        return redirect(url_for('admin.listar_plantas'))

    # GET: renderizar formulario para nueva planta
    return render_template('nueva_planta.html', username=session.get("admin_username"))


def listar_plantas_service():
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta página.")
        return redirect(url_for('admin.login_admin'))

    plantas = list(mongo.db.plants.find())
    return render_template('listar_plantas.html', plantas=plantas, username=session.get("admin_username"))


def editar_planta_service():
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta página.")
        return redirect(url_for('admin.login_admin'))

    planta_id = request.args.get('id')  # Captura el ID de la URL
    if not planta_id:
        flash("ID de planta no especificado")
        return redirect(url_for('admin.listar_plantas'))

    planta = mongo.db.plants.find_one({'_id': ObjectId(planta_id)})
    if not planta:
        flash("Planta no encontrada")
        return redirect(url_for('admin.listar_plantas'))


    if request.method == 'POST':
        # Extraer datos del formulario
        usos_tradicionales = extraer_lista_desde_textarea(request.form.get('usos_tradicionales'))
        infusiones = extraer_lista_desde_textarea(request.form.get('infusiones'))
        efectos = extraer_lista_desde_textarea(request.form.get('efectos'))
        definiciones_efectos = extraer_lista_desde_textarea(request.form.get('Definicion_efectos')) # ¡Cuidado aquí! El nombre del campo en tu HTML es 'Definicion_efectos' (con mayúscula al inicio de "Definicion") y en tu DB es "Definicion_efectos"

        updated_data = {
            'nombre_comun': request.form['nombre_comun'],
            'nombre_cientifico': request.form['nombre_cientifico'],
            'descripcion': request.form['descripcion'],
            'instrucciones_de_cultivo': request.form['instrucciones_de_cultivo'],
            'cuidado_y_cosecha': request.form['cuidado_y_cosecha'],
            "usos_tradicionales": usos_tradicionales,
            "infusiones": infusiones,
            "efectos": efectos,
            "Definicion_efectos": definiciones_efectos, # Asegúrate de que el nombre del campo coincida con tu DB
            'precauciones': request.form['precauciones'],
            'otros_antecedentes': request.form['otros_antecedentes'],
            'tipo_de_planta': request.form['tipo_de_planta'],
            'altura': request.form['altura'],
            'hojas': request.form['hojas'],
            'flores': request.form['flores'],
            'periodo_de_vida': request.form['periodo_de_vida'],
            'temperatura_ideal': request.form['temperatura_ideal'],
            'exposicion_solar': request.form['exposicion_solar'],
            'suelo': request.form['suelo'],
            'propagacion': request.form['propagacion'],
            'riego': request.form['riego'],
            'cosecha': request.form['cosecha'],
        }

        # Actualizar la planta en la base de datos
        result = mongo.db.plants.update_one(
            {'_id': ObjectId(planta_id)},
            {'$set': updated_data}
        )

        #SUBIR IMAGENES
        imagenes = {
            'main_image': f"{planta['nombre_comun'].lower()}.jpg",
            'side_image_1': f"{planta['nombre_comun'].lower()}_1.jpg",
            'side_image_2': f"{planta['nombre_comun'].lower()}_2.jpg",
            'side_image_3': f"{planta['nombre_comun'].lower()}_3.jpg"
        }
        hay_imagenes_cambiadas = False
        for field, filename in imagenes.items():
            file = request.files.get(field)
            if file and allowed_file(file.filename):
                filename_seguro = secure_filename(filename)
                upload_folder = current_app.config['UPLOAD_FOLDER']
                filepath = os.path.join(upload_folder, filename_seguro)
                file.save(filepath)
                hay_imagenes_cambiadas = True
        if result.modified_count == 1 or hay_imagenes_cambiadas:
            flash("Planta actualizada exitosamente.")
            return redirect(url_for('admin.listar_plantas'))
        else:
            flash("No se realizaron cambios o la planta no pudo ser actualizada.")
            # Si no se modificó nada, podría ser porque los datos enviados son idénticos a los existentes.
            # Ocurre un problema, se redirige al formulario de edición con los datos actuales.
            return redirect(url_for('admin.editar_planta_form', id=planta_id))

    main_image = f"{planta['nombre_comun'].lower()}.jpg"
    side_images = [
        f"{planta['nombre_comun'].lower()}_1.jpg",
        f"{planta['nombre_comun'].lower()}_2.jpg",
        f"{planta['nombre_comun'].lower()}_3.jpg"
    ]
    # Chequea si el archivo realmente existe en static/img/
    upload_folder = current_app.config['UPLOAD_FOLDER']
    image_folder = upload_folder
    print(image_folder)
    main_image_path = os.path.join(image_folder, main_image)
    side_image_paths = [os.path.join(image_folder, img) for img in side_images]
    
    # Usa None si la imagen no existe
    if not os.path.exists(main_image_path):
        main_image = None
        print("no existe")

    for i, path in enumerate(side_image_paths):
        if not os.path.exists(path):
            side_images[i] = None
            print("no existe")

    return render_template(
        'editar_planta.html',
        planta=planta,
        username=session.get("admin_username"),
        main_image=main_image,
        side_images=side_images
    )


def eliminar_planta_por_id(planta_id):
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta acción.")
        return redirect(url_for('admin.login_admin'))

    planta = mongo.db.plants.find_one({"_id": ObjectId(planta_id)})
    if not planta:
        flash("No se encontró la planta.")
        return redirect(url_for('admin.listar_plantas'))

    nombre_comun = planta.get('nombre_comun', '').lower()
    upload_folder = current_app.config['UPLOAD_FOLDER']

    # Lista con los nombres de las imágenes que quieres borrar
    imagenes = [
        f"{nombre_comun}.jpg",
        f"{nombre_comun}_1.jpg",
        f"{nombre_comun}_2.jpg",
        f"{nombre_comun}_3.jpg"
    ]

    # Borrar imágenes físicas si existen
    for imagen in imagenes:
        ruta_imagen = os.path.join(upload_folder, imagen)
        if os.path.exists(ruta_imagen):
            try:
                os.remove(ruta_imagen)
            except Exception as e:
                print(f"Error al eliminar la imagen {ruta_imagen}: {e}")

    # Finalmente elimina la planta de la base de datos
    result = mongo.db.plants.delete_one({"_id": ObjectId(planta_id)})

    if result.deleted_count == 1:
        flash("Planta e imágenes eliminadas exitosamente.")
    else:
        flash("No se pudo eliminar la planta. Verifica el ID.")
    return redirect(url_for('admin.listar_plantas'))


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'jpg', 'jpeg', 'png', 'gif'}

def listar_videos_service():
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder.")
        return redirect(url_for('admin.login_admin'))

    videos = list(mongo.db.videos.find())
    return render_template('listar_videos.html', videos=videos, username=session.get("admin_username"))
