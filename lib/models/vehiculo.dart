class Vehiculo {
  String id;
  String marca;
  String modelo;
  String? version;
  int ano;
  String numeroDeMotor;
  String tipoDeMotor;
  String transmission;
  String traccion;
  String? vin;

  Vehiculo({
    required this.id,
    required this.marca,
    required this.modelo,
    this.version,
    required this.ano,
    required this.numeroDeMotor,
    required this.tipoDeMotor,
    required this.transmission,
    required this.traccion,
    this.vin,
  });

  Map<String, dynamic?> toJson() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'version': version,
      'ano': ano,
      'numeroDeMotor': numeroDeMotor,
      'marca': marca,
      'tipoDeMotor': tipoDeMotor,
      'transmission': transmission,
      'traccion': traccion,
      'vin': vin,
    };
  }

  Vehiculo.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          marca: json['marca'],
          modelo: json['modelo'],
          version: json['version'],
          ano: json['ano'],
          numeroDeMotor: json['numeroDeMotor'],
          tipoDeMotor: json['tipoDeMotor'],
          transmission: json['transmission'],
          traccion: json['traccion'],
          vin: json['vin'],
        );
}
