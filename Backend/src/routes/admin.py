from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from services.admin import listar_videos_service, login_admin_service, register_admin_service, create_plant_service, logout_admin_service, listar_plantas_service, editar_planta_service, eliminar_planta_por_id

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

