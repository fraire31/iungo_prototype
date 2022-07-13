import './base_user.dart';

class Usuario extends BaseUsuario {
  String uid;
  String correoElectronico;
  String? nombre;
  String? apellido;
  String? calle;
  String? colonia;
  String? codigoPostal;
  String? ciudad;
  String? estado;
  int? telefono;
  int? whatsapp;
  Map<String, String>? vehiculos;
  Map<String, dynamic>? peticiones;
  Map<String, dynamic>? cotizas;

  Usuario({
    required this.uid,
    required this.correoElectronico,
    this.nombre,
    this.apellido,
    this.calle,
    this.colonia,
    this.codigoPostal,
    this.ciudad,
    this.estado,
    this.telefono,
    this.whatsapp,
    this.vehiculos,
    this.peticiones,
    this.cotizas,
  }) : super(
          uid: uid,
          correoElectronico: correoElectronico,
          nombre: nombre,
          apellido: apellido,
          calle: calle,
          colonia: colonia,
          codigoPostal: codigoPostal,
          ciudad: ciudad,
          estado: estado,
          telefono: telefono,
          whatsapp: whatsapp,
        );

  Usuario.fromJson(Map<String, dynamic?> json)
      : this(
          uid: json['uid'],
          correoElectronico: json['correoElectronico'],
          vehiculos: json['vehiculos'],
          peticiones: json['peticiones'],
          cotizas: json['cotizas'],
          nombre: json['nombre'],
          apellido: json['apellido'],
          calle: json['calle'],
          colonia: json['colonia'],
          codigoPostal: json['codigoPostal'],
          ciudad: json['ciudad'],
          estado: json['estado'],
          telefono: json['telefono'],
          whatsapp: json['whatsapp'],
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'correoElectronico': correoElectronico,
      'nombre': nombre,
      'apellido': apellido,
      'calle': calle,
      'colonia': colonia,
      'codigoPostal': codigoPostal,
      'ciudad': ciudad,
      'estado': estado,
      'telefono': telefono,
      'whatsapp': whatsapp,
      'vehiculos': vehiculos,
      'peticiones': peticiones,
      'cotizas': cotizas,
    };
  }
}
