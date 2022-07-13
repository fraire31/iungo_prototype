class Servicio {
  final String id;
  final String nombre;
  final bool usado;
  final bool servicio;
  final String descripcion;
  final bool urgente;

  Servicio({
    required this.id,
    required this.nombre,
    required this.usado,
    required this.servicio,
    required this.descripcion,
    required this.urgente,
  });

  Servicio.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id']! as String,
          nombre: json['nombre']! as String,
          usado: json['usado']! as bool,
          servicio: json['servicio']! as bool,
          descripcion: json['descripcion']! as String,
          urgente: json['urgente']! as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'usado': usado,
      'servicio': servicio,
      'descripcion': descripcion,
      'urgente': urgente,
    };
  }
}
