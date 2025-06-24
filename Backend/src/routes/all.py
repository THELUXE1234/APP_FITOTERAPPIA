from flask import Blueprint

from services.all import get_glosario_services, get_plants_services, create_plants_dataset, get_videos_services


all = Blueprint('apí', __name__)


@all.route('/plantas', methods=['GET'])
def get_plants():
    return get_plants_services()


@all.route('/plantas/create', methods=['GET'])
def create_plant_route():
    return create_plants_dataset()


@all.route('/videos', methods=['GET'])
def get_videos():
    return get_videos_services()

@all.route('/glosario', methods=['GET'])
def get_glosario():
    return get_glosario_services()