import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/users/user.dart';
import '../../repositories/users/user_repo.dart';
import '../../services/firebase_storage/storage_service.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storageService = StorageService();
  final UserRepo _userRepo = UserRepo();

  IungoUser? _user;

  IungoUser? get userData => _user;

  Future<void> fetchUserInfo() async {
    final String uid = _auth.currentUser!.uid;

    final data = await _userRepo.fetchUserData(uid: uid);

    final _userData = data.docs.first.data();
    _user = IungoUser.fromJson(_userData);
  }

  void updateProviderServices(String serviceName) {
    if (_user!.serviciosDisponible != null &&
        _user!.serviciosDisponible!.contains(serviceName)) {
      _user!.serviciosDisponible!.remove(serviceName);
    } else {
      ///set at servicio disponible [] in database
      _user!.serviciosDisponible!.add(serviceName);
    }
  }

  void updateProviderSchedule(Map updatedSchedule) {
    _user!.horario = updatedSchedule;
  }

  Future<void> updateProviderData(Map data) async {
    final _providersAddress =
        '${data['general']['street']} ${data['general']['suburb']} ${data['general']['city']} ${data['general']['state']} ${data['general']['postalCode']}, MX';

    List<Location> _locations = await GeocodingPlatform.instance
        .locationFromAddress(_providersAddress, localeIdentifier: 'es_MX');

    final _currentLocation =
        LatLng(_locations[0].latitude, _locations[0].longitude);

    String? url = data['general']['profileImageUrl'];

    if (data['general']['newProfileImage'] != null) {
      if (url!.isNotEmpty) {
        await _storageService.deleteFileImage();
      }

      url = await _storageService.updateProfileImage(
          image: data['general']['newProfileImage']);
    }

    _user = _user!.copyWith(
      profileImageUrl: url,
      nombreDeNegocio: data['general']['companyName'],
      nombreDeGerente: data['general']['managerName'],
      calle: data['general']['street'],
      colonia: data['general']['suburb'],
      ciudad: data['general']['city'],
      estado: data['general']['state'],
      codigoPostal: data['general']['postalCode'],
      latLng: {
        'lat': _currentLocation.latitude,
        'lng': _currentLocation.longitude
      },
      horario: data['schedule'],
      serviciosDisponible: data['services'],
    );

    return await _userRepo
        .updateProviderProfileData(data: _user!)
        .then((value) {
      notifyListeners();
    });
  }
}
