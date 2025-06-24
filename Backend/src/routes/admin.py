from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from services.admin import create_glosario_term_service, create_video_service, delete_glosario_term_service, delete_video_service, edit_glosario_term_service, listar_glosario_service, listar_videos_service, login_admin_service, register_admin_service, create_plant_service, logout_admin_service, listar_plantas_service, editar_planta_service, eliminar_planta_por_id

admin = Blueprint('admin', __name__)  # SIN url_prefix, así accedes con /login directamente

@admin.route('/login', methods=['GET', 'POST'])
def login_admin():
    return login_admin_service()

@admin.route('/register', methods=['GET', 'POST'])
def register_admin():
    return register_admin_service()

@admin.route('/logout')
def logout_admin():
    return logout_admin_service()

@admin.route('/admin/crear-planta', methods=['GET', 'POST'])
def create_plant_form():
    return create_plant_service()

@admin.route('/admin/plantas', methods=["GET"])
def listar_plantas():
    return listar_plantas_service()

@admin.route('/admin/editar-planta', methods=['GET', 'POST'])
def editar_planta_form():

    return editar_planta_service()


@admin.route('/admin/eliminar_planta/<string:planta_id>', methods=['POST'])
def eliminar_planta(planta_id):
      # esta función debe estar en /services/all.py
    return eliminar_planta_por_id(planta_id)


@admin.route('/admin/videos', methods=['GET'])
def listar_videos():
    return listar_videos_service()

@admin.route('/admin/crear-video', methods=['GET', 'POST'])
def create_video_form():
    return create_video_service()

@admin.route('/admin/eliminar_video/<string:video_id>', methods=['POST'])
def delete_video(video_id):
    return delete_video_service(video_id)


@admin.route('/admin/glosario', methods=['GET'])
def listar_glosario():
    return listar_glosario_service()

@admin.route('/admin/crear-term-glosario', methods=['GET', 'POST'])
def create_glosario_term():
    return create_glosario_term_service()


@admin.route('/admin/eliminar_termino_glosario/<string:term_id>', methods=['POST'])
def delete_glosario_term(term_id):
    return delete_glosario_term_service(term_id)

@admin.route('/glosario/editar', methods=['GET', 'POST'])
def edit_glosario_term():
    return edit_glosario_term_service()