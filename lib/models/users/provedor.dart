import './base_user.dart';

class Provedor extends BaseUsuario {
  String uid;
  String correoElectronico;
  String? nombreDeNegocio;
  String? nombreDeGerente;
  Map? servicios;
  List? serviciosDisponible; //being persisted to the db but not read
  Map? horario;
  //---base
  String? calle;
  String? colonia;
  String? ciudad;
  String? estado;
  String? codigoPostal;
  Map? latLng;

  Provedor({
    required this.uid,
    required this.correoElectronico,
    this.nombreDeNegocio,
    this.nombreDeGerente,
    this.servicios,
    this.serviciosDisponible,
    this.horario,
    this.calle,
    this.colonia,
    this.ciudad,
    this.estado,
    this.codigoPostal,
    this.latLng,
  }) : super(
          uid: uid,
          correoElectronico: correoElectronico,
          calle: calle,
          colonia: colonia,
          ciudad: ciudad,
          estado: estado,
          codigoPostal: codigoPostal,
        );

  Provedor.fromJson(Map<String, dynamic?> json)
      : this(
          uid: json['uid'],
          correoElectronico: json['correoElectronico'],
          nombreDeNegocio: json['nombreDeNegocio'],
          nombreDeGerente: json['nombreDeGerente'],
          calle: json['calle'],
          colonia: json['colonia'],
          ciudad: json['ciudad'],
          estado: json['estado'],
          codigoPostal: json['codigoPostal'],
          latLng: json['latLng'],
          servicios: json['servicios'],
          serviciosDisponible: json['serviciosDisponible'],
          horario: json['horario'],
        );

  Map<String, dynamic?> toJson() {
    return {
      'uid': uid,
      'correoElectornico': correoElectronico,
      'nombreDeNegocio': nombreDeNegocio,
      'nombreDeGerente': nombreDeGerente,
      'calle': calle,
      'colonia': colonia,
      'ciudad': ciudad,
      'estado': estado,
      'codigoPostal': codigoPostal,
      'latLng': latLng,
      'servicios': servicios,
      'serviciosDisponible': serviciosDisponible,
      'horario': horario
    };
  }
}
