// To parse this JSON data, do
//
//     final plants = plantsFromJson(jsonString);

import 'dart:convert';

Plants plantsFromJson(String str) => Plants.fromJson(json.decode(str));

String plantsToJson(Plants data) => json.encode(data.toJson());

class Plants {
    Id? id;
    String? nombreComun;
    String? nombreCientifico;

    Plants({
        this.id,
        this.nombreComun,
        this.nombreCientifico,
    });

    factory Plants.fromJson(Map<String, dynamic> json) => Plants(
        id: Id.fromJson(json["_id"]),
        nombreComun: json["nombre_comun"],
        nombreCientifico: json["nombre_cientifico"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id?.toJson(),
        "nombre_comun": nombreComun,
        "nombre_cientifico": nombreCientifico,
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
