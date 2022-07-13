import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iungo_prototype/models/users/user.dart';

import '../../enums.dart' as enums;

class UserRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNewUser({
    required String uid,
    required String email,
    required enums.userType userType,
    String? name,
    String? lastName,
    String? companyName,
  }) async {
    if (userType.name == 'provider') {
      await _firestore.collection('usuarios').add({
        'uid': uid,
        'correoElectronico': email,
        'nombreDeNegocio': companyName,
        'rol': [userType.name],
        'loggedInAs': userType.name,
        'serviciosDisponible': [],
        'horario': {
          'lunes': '',
          'martes': '',
          'miercoles': '',
          'jueves': '',
          'viernes': '',
          'sabado': '',
          'domingo': '',
        }
      });
    } else {
      await _firestore.collection('usuarios').add({
        'uid': uid,
        'correoElectronico': email,
        'nombre': name,
        'apellido': lastName,
        'rol': [userType.name],
        'loggedInAs': userType.name,
      });
    }
  }

  //keep you id here, bc user just logged in
  Future<QuerySnapshot<Map<String, dynamic>>> fetchUserData({
    required String uid,
  }) async {
    return await _firestore
        .collection('usuarios')
        .where('uid', isEqualTo: uid)
        .get();
  }

  Future<void> updateProviderProfileData({required IungoUser data}) {
    return _firestore
        .collection('usuarios')
        .where('uid', isEqualTo: data.uid)
        .get()
        .then((results) {
      final docId = results.docs.first.reference.id;

      _firestore.collection('usuarios').doc(docId).update({
        'profileImageUrl': data.profileImageUrl,
        'nombreDeNegocio': data.nombreDeNegocio,
        'nombreDeGerente': data.nombreDeGerente,
        'calle': data.calle,
        'colonia': data.colonia,
        'ciudad': data.ciudad,
        'estado': data.estado,
        'codigoPostal': data.codigoPostal,
        'serviciosDisponible': data.serviciosDisponible,
        'horario': data.horario,
        'latLng': data.latLng,
      });
    });
  }

  Future<void> updateUserProfileData({
    required IungoUser data,
  }) async {
    return _firestore
        .collection('usuarios')
        .where('uid', isEqualTo: data.uid)
        .get()
        .then((results) {
      final docId = results.docs.first.reference.id;

      _firestore.collection('usuarios').doc(docId).update({
        'nombre': data.nombre,
        'apellido': data.apellido,
        'profileImageUrl': data.profileImageUrl
      });
    });
  }
}
