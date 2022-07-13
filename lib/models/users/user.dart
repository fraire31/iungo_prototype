class IungoUser {
  //---all users
  String uid;
  String correoElectronico;
  String? profileImageUrl;
  List? rol;
  String? loggedInAs;
  String? calle;
  String? colonia;
  String? ciudad;
  String? estado;
  String? codigoPostal;
  int? telefono;
  int? whatsapp;

  //--providers
  String? nombreDeNegocio;
  String? nombreDeGerente;
  List? serviciosDisponible;
  Map? horario;
  Map? latLng;
  Map<String, dynamic>? cotizas;

  //--user
  String? nombre;
  String? apellido;
  Map<String, String>? vehiculos;
  Map<String, dynamic>? peticiones;
  Map<String, dynamic>? cotizaciones;

  IungoUser({
    required this.uid,
    required this.correoElectronico,
    this.profileImageUrl,
    this.rol,
    this.loggedInAs,
    this.calle,
    this.colonia,
    this.codigoPostal,
    this.ciudad,
    this.estado,
    this.telefono,
    this.whatsapp,
    //--providers
    this.nombreDeNegocio,
    this.nombreDeGerente,
    this.serviciosDisponible,
    this.horario,
    this.latLng,
    this.cotizas,
    //users

    this.nombre,
    this.apellido,
    this.vehiculos,
    this.peticiones,
    this.cotizaciones,
  });

  IungoUser copyWith({
    String? uid,
    String? correoElectronico,
    String? profileImageUrl,
    List? rol,
    String? loggedInAs,
    String? calle,
    String? colonia,
    String? ciudad,
    String? estado,
    String? codigoPostal,
    int? telefono,
    int? whatsapp,

    //--providers
    String? nombreDeNegocio,
    String? nombreDeGerente,
    Map? servicios,
    List? serviciosDisponible,
    Map? horario,
    Map? latLng,
    Map<String, dynamic>? cotizas, //calculated from user address

    //--user
    String? nombre,
    String? apellido,
    Map<String, String>? vehiculos,
    Map<String, dynamic>? peticiones,
    Map<String, dynamic>? cotizaciones,
  }) {
    return IungoUser(
      uid: uid ?? this.uid,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rol: rol ?? this.rol,
      loggedInAs: loggedInAs ?? this.loggedInAs,
      calle: calle ?? this.calle,
      colonia: colonia ?? this.colonia,
      ciudad: ciudad ?? this.ciudad,
      estado: estado ?? this.estado,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      telefono: telefono ?? this.telefono,
      whatsapp: whatsapp ?? this.whatsapp,
      nombreDeNegocio: nombreDeNegocio ?? this.nombreDeNegocio,
      nombreDeGerente: nombreDeGerente ?? this.nombreDeGerente,
      serviciosDisponible: serviciosDisponible ?? this.serviciosDisponible,
      horario: horario ?? this.horario,
      latLng: latLng ?? this.latLng,
      cotizas: cotizas ?? this.cotizas,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      vehiculos: vehiculos ?? this.vehiculos,
      peticiones: peticiones ?? this.peticiones,
      cotizaciones: cotizaciones ?? this.cotizaciones,
    );
  }

  IungoUser.fromJson(Map<String, dynamic?> json)
      : this(
          uid: json['uid'],
          correoElectronico: json['correoElectronico'],
          profileImageUrl: json['profileImageUrl'],
          rol: json['rol'],
          loggedInAs: json['loggedInAs'],
          calle: json['calle'],
          colonia: json['colonia'],
          codigoPostal: json['codigoPostal'],
          ciudad: json['ciudad'],
          estado: json['estado'],
          telefono: json['telefono'],
          whatsapp: json['whatsapp'],

          //--providers
          nombreDeGerente: json['nombreDeGerente'],
          nombreDeNegocio: json['nombreDeNegocio'],
          serviciosDisponible: json['serviciosDisponible'],
          horario: json['horario'],
          latLng: json['latLng'],
          cotizas: json['cotizas'],

          //--users
          nombre: json['nombre'],
          apellido: json['apellido'],
          vehiculos: json['vehiculos'],
          peticiones: json['peticiones'],
          cotizaciones: json['cotizaciones'],
        );
}
