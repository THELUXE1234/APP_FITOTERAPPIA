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

def create_video_service():
    """
    Maneja la creación de un nuevo video.
    Recibe el link de YouTube, extrae título y autor, y guarda en MongoDB.
    """
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta página.")
        return redirect(url_for('admin.login_admin'))

    if request.method == 'POST':
        video_link = request.form['link'].strip()
        if not video_link:
            flash('El enlace del video no puede estar vacío.', 'error')
            return redirect(url_for('admin.create_video_form'))

        # Validar si el link ya existe
        existing_video = mongo.db.videos.find_one({'link': video_link})
        if existing_video:
            flash('Este video ya ha sido agregado.', 'warning')
            return redirect(url_for('admin.create_video_form'))

        # youtube_info = get_youtube_info(video_link)
        youtube_info = True
        if youtube_info:
            video_data = {
                'link': video_link,
                # 'title': youtube_info.get('title', 'Título no disponible'),
                # 'author': youtube_info.get('uploader', 'Autor no disponible')
            }
            print(video_data.get('link'))
            mongo.db.videos.insert_one(video_data)
            flash('Video agregado exitosamente.', 'success')
            return redirect(url_for('admin.listar_videos'))
        else:
            flash('No se pudo obtener la información del video. Verifica el enlace.', 'error')
            return redirect(url_for('admin.create_video_form'))

    return render_template('nuevo_video.html', username=session.get("admin_username"))

def delete_video_service(video_id):
    """
    Elimina un video de la base de datos.
    """
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta acción.", 'error')
        return redirect(url_for('admin.login_admin'))

    video = mongo.db.videos.find_one({"_id": ObjectId(video_id)})
    if not video:
        flash("No se encontró el video.", 'error')
        return redirect(url_for('admin.listar_videos'))

    result = mongo.db.videos.delete_one({"_id": ObjectId(video_id)})

    if result.deleted_count == 1:
        flash("Video eliminado exitosamente.", 'success')
    else:
        flash("No se pudo eliminar el video. Verifica el ID.", 'error')
    return redirect(url_for('admin.listar_videos'))

def listar_glosario_service():
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder.")
        return redirect(url_for('admin.login_admin'))

    terms = list(mongo.db.glosario.find().sort([("category", 1), ("term", 1)]))
    
    # Agrupar términos por categoría para una mejor visualización si es necesario en la plantilla
    grouped_terms = {}
    for term_data in terms:
        category = term_data.get('category')
        if category not in grouped_terms:
            grouped_terms[category] = []
        grouped_terms[category].append(term_data)
    return render_template('listar_glosario.html', grouped_terms=grouped_terms, username=session.get("admin_username"))

def create_glosario_term_service():
    """
    Maneja la creación de un nuevo término del glosario.
    """
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta página.")
        return redirect(url_for('admin.login_admin'))

    if request.method == 'POST':
        category = request.form['category'].strip()
        term = request.form['term'].strip()
        definition = request.form['definition'].strip()

        if not category or not term or not definition:
            flash('Todos los campos son obligatorios.', 'error')
            return redirect(url_for('admin.create_glosario_term'))

        # Opcional: Validar si el término ya existe en la misma categoría
        existing_term = mongo.db.glosario.find_one({'category': category, 'term': term})
        if existing_term:
            flash(f'El término "{term}" ya existe en la categoría "{category}".', 'warning')
            return redirect(url_for('admin.create_glosario_term'))

        glossary_data = {
            'category': category,
            'term': term,
            'definition': definition
        }
        mongo.db.glosario.insert_one(glossary_data)
        flash('Término del glosario agregado exitosamente.', 'success')
        return redirect(url_for('admin.listar_glosario'))

    categories = [
        "Propiedades Terapéuticas",
        "Preparaciones",
        "Condiciones de Salud",
        "Términos agronómicos y botánicos"
    ]
    return render_template('nuevo_termino_glosario.html', username=session.get("admin_username"), categories=categories)

def delete_glosario_term_service(term_id):
    """
    Elimina un término del glosario de la base de datos.
    """
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta acción.", 'error')
        return redirect(url_for('admin.login_admin'))

    term_data = mongo.db.glosario.find_one({"_id": ObjectId(term_id)})
    if not term_data:
        flash("No se encontró el término del glosario.", 'error')
        return redirect(url_for('admin.listar_glosario_terms'))

    result = mongo.db.glosario.delete_one({"_id": ObjectId(term_id)})

    if result.deleted_count == 1:
        flash("Término del glosario eliminado exitosamente.", 'success')
    else:
        flash("No se pudo eliminar el término del glosario. Verifica el ID.", 'error')
    return redirect(url_for('admin.listar_glosario'))



def edit_glosario_term_service():
    """
    Maneja la edición de un término del glosario existente.
    """
    if 'admin_id' not in session:
        flash("Debe iniciar sesión para acceder a esta página.")
        return redirect(url_for('admin.login_admin'))

    term_id = request.args.get('id')
    if not term_id:
        flash("ID de término no especificado.", 'error')
        return redirect(url_for('admin.listar_glosario'))

    term_data = mongo.db.glosario.find_one({'_id': ObjectId(term_id)})
    if not term_data:
        flash("Término no encontrado.", 'error')
        return redirect(url_for('admin.listar_glosario'))

    if request.method == 'POST':
        new_category = request.form['category'].strip()
        new_term = request.form['term'].strip()
        new_definition = request.form['definition'].strip()

        if not new_category or not new_term or not new_definition:
            flash('Todos los campos son obligatorios.', 'error')
            return redirect(url_for('admin.edit_glosario_term', id=term_id))

        # Opcional: Validar si el término ya existe con la nueva categoría/término para otro ID
        existing_term_with_new_data = mongo.db.glossary.find_one(
            {'category': new_category, 'term': new_term, '_id': {'$ne': ObjectId(term_id)}}
        )
        if existing_term_with_new_data:
            flash(f'El término "{new_term}" ya existe en la categoría "{new_category}" con otro ID.', 'warning')
            return redirect(url_for('admin.edit_glosario_term', id=term_id))

        updated_data = {
            'category': new_category,
            'term': new_term,
            'definition': new_definition
        }

        result = mongo.db.glosario.update_one(
            {'_id': ObjectId(term_id)},
            {'$set': updated_data}
        )
        if result.modified_count == 1:
            flash('Término del glosario actualizado exitosamente.', 'success')
        else:
            flash('No se realizaron cambios en el término.', 'info')
        return redirect(url_for('admin.listar_glosario'))

    categories = [
        "Propiedades Terapéuticas",
        "Preparaciones",
        "Condiciones de Salud",
        "Términos agronómicos y botánicos"
    ]
    return render_template('editar_termino_glosario.html', term=term_data, username=session.get("admin_username"), categories=categories)
