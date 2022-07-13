class BaseUsuario {
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

  BaseUsuario({
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
  });
}
