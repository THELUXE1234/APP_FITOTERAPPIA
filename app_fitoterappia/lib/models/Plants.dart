import 'dart:convert';

// To parse this JSON data, do
//
//     final plants = plantsFromJson(jsonString);

Plants plantsFromJson(String str) => Plants.fromJson(json.decode(str));

String plantsToJson(Plants data) => json.encode(data.toJson());

class Plants {
  Id? id;
  String? nombreComun;
  String? nombreCientifico;
  String? descripcion;
  String? instruccionesDeCultivo;
  String? cuidadoYCosecha;
  List<String>? usosTradicionales;
  List<String>? infusiones;
  List<String>? efectos;
  List<String>? definicionEfectos;
  String? precauciones;
  String? otrosAntecedentes;

  Plants({
    this.id,
    this.nombreComun,
    this.nombreCientifico,
    this.descripcion,
    this.instruccionesDeCultivo,
    this.cuidadoYCosecha,
    this.usosTradicionales,
    this.infusiones,
    this.efectos,
    this.definicionEfectos,
    this.precauciones,
    this.otrosAntecedentes,
  });

  factory Plants.fromJson(Map<String, dynamic> json) => Plants(
    id: Id.fromJson(json["_id"]),
    nombreComun: json["nombre_comun"],
    nombreCientifico: json["nombre_cientifico"],
    descripcion: json["descripcion"],
    instruccionesDeCultivo: json["instrucciones_de_cultivo"],
    cuidadoYCosecha: json["cuidado_y_cosecha"],
    usosTradicionales: List<String>.from(json["usos_tradicionales"].map((x) => x)),
    infusiones: List<String>.from(json["infusiones"].map((x) => x)),
    efectos: List<String>.from(json["efectos"].map((x) => x)),
    definicionEfectos: List<String>.from(json["Definicion_efectos"].map((x) => x)),
    precauciones: json["precauciones"],
    otrosAntecedentes: json["otros_antecedentes"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id?.toJson(),
    "nombre_comun": nombreComun,
    "nombre_cientifico": nombreCientifico,
    "descripcion": descripcion,
    "instrucciones_de_cultivo": instruccionesDeCultivo,
    "cuidado_y_cosecha": cuidadoYCosecha,
    "usos_tradicionales": List<dynamic>.from(usosTradicionales!.map((x) => x)),
    "infusiones": List<dynamic>.from(infusiones!.map((x) => x)),
    "efectos": List<dynamic>.from(efectos!.map((x) => x)),
    "Definicion_efectos": List<dynamic>.from(definicionEfectos!.map((x) => x)),
    "precauciones": precauciones,
    "otros_antecedentes": otrosAntecedentes,
  };
}

class Id {
  String? oid;

  Id({
    this.oid,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    oid: json["\u0024oid"],
  );

  Map<String, dynamic> toJson() => {
    "\u0024oid": oid,
  };
}
