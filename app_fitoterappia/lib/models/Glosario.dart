import 'dart:convert';

// To parse this JSON data, do
//
//     final plants = plantsFromJson(jsonString);

Glosario plantsFromJson(String str) => Glosario.fromJson(json.decode(str));

String GlosarioToJson(Glosario data) => json.encode(data.toJson());

class Glosario {
  Id? id;
  String? term;
  String? definition;
  String? category;


  Glosario({
    this.id,
    this.term,
    this.definition,
    this.category,

  });

  factory Glosario.fromJson(Map<String, dynamic> json) => Glosario(
    id: Id.fromJson(json["_id"]),
    term: json["term"],
    definition: json["definition"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id?.toJson(),
    "term": term,
    "definition": definition,
    "category": category,
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
