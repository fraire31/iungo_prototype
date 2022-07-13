import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../exceptions/custom_exception.dart';
import '../../models/requests/peticion.dart';
import '../../services/location_service.dart';

class PeticionRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> savePetition({required Peticion petition}) async {
    final city = petition.preferencias!['ciudad']?.toLowerCase();

    List? _filteredProviders = [];

    await _firestore
        .collection('usuarios')
        .where('rol', arrayContains: 'provider')
        .where('ciudad', isEqualTo: city)
        .get()
        .then((results) {
      final _range =
          petition.preferencias!['distanicaDelProvedor']! * 1000; //km to meters

      final providers = results.docs;

      for (var provider in providers) {
        final _data = provider.data();

        //eventually have logic the prevents from querying providers that dont
        // have an address/privilege to be searched
        if (_data['latLng'] != null &&
            _data['serviciosDisponible'].contains(petition.tipoDeServicio)) {
          if (petition.preferencias!['buscarEnCiudad'] as bool) {
            _filteredProviders.add(_data['uid']);
          } else {
            final _latLng = _data['latLng'] as Map;

            final _providerLatLng = LatLng(_latLng['lat'], _latLng['lng']);

            final _petitionLatLng = LatLng(
                petition.preferencias!['latLng']['lat'],
                petition.preferencias!['latLng']['lng']);

            final double _distance = LocationService.distanceBetweenToLocations(
                _petitionLatLng, _providerLatLng);

            if (_distance <= _range) {
              _filteredProviders.add(_data['uid']);
            }
          }
        }
      }
    });

    final _uuid = Uuid().v1();
    if (_filteredProviders.length > 0) {
      await _firestore.collection('peticiones').add({
        'id': _uuid,
        'userUid': _auth.currentUser!.uid,
        'nombreDeUsuario': petition.nombreDeUsuario,
        'fecha': Timestamp.now(),
        'abierto': true,
        'tipoDeServicio': petition.tipoDeServicio,
        'nombreDeParte': petition.nombreDeParte,
        'cantidad': petition.cantidad,
        'marca': petition.marca,
        'numeroDeParte': petition.numeroDeParte,
        'descripcion': petition.descripcion,
        'fotos': petition.fotos,
        'providers': _filteredProviders,
        'vehiculo': petition.vehiculo,
        'preferencias': petition.preferencias,
      });
    } else {
      throw CustomException(
          code: 'no-providers-found',
          message:
              'No hay provedor que ofrecen este servicio, intente expandir distancia');
    }
  }
}
