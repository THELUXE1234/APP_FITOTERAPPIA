import 'package:flutter/material.dart';


class PlantProvider with ChangeNotifier {
  // Planta actual
  var _planta;

  // Getter para obtener la planta
  get planta => _planta;

  // Setter para establecer la planta y notificar a los listeners
  set planta(planta) {
    _planta = planta;
    notifyListeners();
  }
}