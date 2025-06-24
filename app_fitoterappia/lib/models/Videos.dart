import 'dart:convert';

// Función para decodificar una lista de videos desde un string JSON.
// Es más útil que decodificar un solo video, ya que la API usualmente devuelve una lista.
List<Video> videosFromJson(String str) => List<Video>.from(json.decode(str).map((x) => Video.fromJson(x)));

// Función para codificar una lista de objetos Video a un string JSON.
String videosToJson(List<Video> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Video {
  Id? id;
  String? titulo;
  String? autor;
  String? link;

  Video({
    this.id,
    this.titulo,
    this.autor,
    this.link,
  });

  // Factory constructor para crear una instancia de Video desde un mapa (JSON).
  // Es el corazón de la conversión de datos de la API a objetos Dart.
  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["_id"] == null ? null : Id.fromJson(json["_id"]),
    titulo: json["titulo"], // Si la clave no existe, Dart asignará null.
    autor: json["autor"],
    link: json["link"],
  );

  // Método para convertir la instancia del objeto Video a un mapa (JSON).
  // Útil si necesitaras enviar datos a una API o guardarlos en un formato específico.
  Map<String, dynamic> toJson() => {
    "_id": id?.toJson(),
    "titulo": titulo,
    "autor": autor,
    "link": link,
  };
}

// La clase Id es idéntica a la de tu modelo Plants,
// ya que maneja el formato estándar de _id de MongoDB.
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