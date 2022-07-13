import 'package:cloud_firestore/cloud_firestore.dart';

class Peticion {
  String? id;
  Timestamp? fecha; //time it was created /  sent
  //if user hasnt had a response in 30mins, otherwise in 30 mins it will be closed
  //realizado logic will come from here too
  bool? abierto = true;

  String? userUid; //for now make sure its required and update files
  String? nombreDeUsuario; //for now make sure its required and update files

  List? fotos;

  String? tipoDeServicio; //serviceType
  String? nombreDeParte; //name
  int? cantidad; //quantity
  String? marca; //brand
  String? numeroDeParte; //number
  String? descripcion;

  Map? preferencias;

  List? providers;

  Map<String, dynamic?>? vehiculo;

  Peticion({
    this.id,
    this.fecha,
    this.abierto,
    this.userUid,
    this.nombreDeUsuario,
    this.fotos,
    this.tipoDeServicio,
    this.nombreDeParte,
    this.cantidad,
    this.marca,
    this.numeroDeParte,
    this.descripcion,
    this.preferencias,
    this.providers,
    this.vehiculo,
  });

  Peticion copyWith({
    String? id,
    Timestamp? fecha,
    bool? abierto = true,
    String? userUid,
    String? nombreDeUsuario,
    List? fotos,
    String? tipoDeServicio,
    String? nombreDeParte,
    int? cantidad,
    String? marca,
    String? numeroDeParte,
    String? descripcion,
    Map? preferencias,
    List? providers,
    Map<String, dynamic?>? vehiculo,
  }) {
    return Peticion(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      abierto: abierto ?? this.abierto,
      userUid: userUid ?? this.userUid,
      nombreDeUsuario: nombreDeUsuario ?? this.nombreDeUsuario,
      fotos: fotos ?? this.fotos,
      tipoDeServicio: tipoDeServicio ?? this.tipoDeServicio,
      nombreDeParte: nombreDeParte ?? this.nombreDeParte,
      cantidad: cantidad ?? this.cantidad,
      marca: marca ?? this.marca,
      numeroDeParte: numeroDeParte ?? this.numeroDeParte,
      descripcion: descripcion ?? this.descripcion,
      preferencias: preferencias ?? this.preferencias,
      providers: providers ?? this.providers,
      vehiculo: vehiculo ?? this.vehiculo,
    );
  }

  Peticion.fromJson(Map<String, dynamic?> json)
      : this(
          id: json['id'],
          fecha: json['fecha'],
          abierto: json['abierto'],
          userUid: json['userUid'],
          nombreDeUsuario: json['nombreDeUsuario'],
          fotos: json['fotos'],
          tipoDeServicio: json['tipoDeServicio'],
          nombreDeParte: json['nombreDeParte'],
          cantidad: json['cantidad'],
          marca: json['marca'],
          numeroDeParte: json['numeroDeParte'],
          descripcion: json['descripcion'],
          providers: json['providers'],
          preferencias: json['preferencias'],
          vehiculo: json['vehiculo'],
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'userUid': userUid,
      'nombreDeUsuario': nombreDeUsuario,
      'fotos': fotos,
      'fecha': fecha,
      'abierto': abierto,
      'tipoDeServicio': tipoDeServicio,
      'nombreDeParte': nombreDeParte,
      'cantidad': cantidad,
      'marca': marca,
      'numeroDeParte': numeroDeParte,
      'descripcion': descripcion,
      'vehiculo': vehiculo,
      'providers': providers,
      'preferencias': preferencias,
      'vehiculo': vehiculo,
    };
  }
}
