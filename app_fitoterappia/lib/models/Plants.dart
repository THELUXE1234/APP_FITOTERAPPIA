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
  
  // Nuevos atributos añadidos
  String? tipoDePlanta;
  String? altura;
  String? hojas;
  String? flores;
  String? periodoDeVida;
  String? temperaturaIdeal;
  String? exposicionSolar;
  String? suelo;
  String? propagacion;
  String? riego;
  String? cosecha;

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
    // Nuevos atributos añadidos
    this.tipoDePlanta,
    this.altura,
    this.hojas,
    this.flores,
    this.periodoDeVida,
    this.temperaturaIdeal,
    this.exposicionSolar,
    this.suelo,
    this.propagacion,
    this.riego,
    this.cosecha,
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
    
    // Nuevos atributos añadidos
    tipoDePlanta: json["tipo_de_planta"],
    altura: json["altura"],
    hojas: json["hojas"],
    flores: json["flores"],
    periodoDeVida: json["periodo_de_vida"],
    temperaturaIdeal: json["temperatura_ideal"],
    exposicionSolar: json["exposicion_solar"],
    suelo: json["suelo"],
    propagacion: json["propagacion"],
    riego: json["riego"],
    cosecha: json["cosecha"],
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
    
    // Nuevos atributos añadidos
    "tipo_de_planta": tipoDePlanta,
    "altura": altura,
    "hojas": hojas,
    "flores": flores,
    "periodo_de_vida": periodoDeVida,
    "temperatura_ideal": temperaturaIdeal,
    "exposicion_solar": exposicionSolar,
    "suelo": suelo,
    "propagacion": propagacion,
    "riego": riego,
    "cosecha": cosecha,
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
