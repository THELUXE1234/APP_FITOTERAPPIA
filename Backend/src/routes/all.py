from flask import Blueprint

from services.all import get_plants_services, create_plant


all = Blueprint('apí', __name__)


@all.route('/plantas', methods=['GET'])
def get_plants():
    return get_plants_services()


@all.route('/plantas', methods=['POST'])
def create_plant_route():
    return create_plant()