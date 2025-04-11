from flask import Blueprint

from services.all import get_plants_services, create_plants_dataset


all = Blueprint('apí', __name__)


@all.route('/plantas', methods=['GET'])
def get_plants():
    return get_plants_services()


@all.route('/plantas/create', methods=['GET'])
def create_plant_route():
    return create_plants_dataset()