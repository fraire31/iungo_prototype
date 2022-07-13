import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../exceptions/custom_exception.dart';
import '../../models/requests/peticion.dart';
import '../../models/vehiculo.dart';
import '../../repositories/requests/peticion_repo.dart';
import '../../services/firebase_storage/storage_service.dart';
import '../../services/location_service.dart';

class RequestProvider with ChangeNotifier {
  final PeticionRepo _peticionRepo = PeticionRepo();
  final StorageService _storageService = StorageService();

  late Peticion _request;

//preferences
//used in Google map
  LatLng? _currentLocation;

  String? _city;

  String? get city => _city;

  LatLng get currentLocation => _currentLocation!;

  Future<void> saveRequest({
    required LatLng coordinates,
    required int range,
    required String city,
    required bool searchEntireCity,
    required String userName,
  }) async {
    final _uuid = const Uuid().v1();

    List _imageUrls = [];

    if (_request.fotos != null) {
      _imageUrls = await _storageService.uploadPetitionImages(
        images: _request.fotos as List<XFile>,
        petitionId: _uuid,
      );
    }

    _request = _request.copyWith(
      id: _uuid,
      fecha: Timestamp.now(),
      nombreDeUsuario: userName,
      preferencias: {
        'buscarEnCiudad': searchEntireCity,
        'latLng': {'lat': coordinates.latitude, 'lng': coordinates.longitude},
        'ciudad': city,
        'distanicaDelProvedor': range
      },
      fotos: _imageUrls,
    );

    await _peticionRepo.savePetition(petition: _request);
  }

  void savePartsInformation({
    required String serviceType,
    required String name,
    required int quantity,
    String? number,
    String? brand,
    String? description,
    List<XFile>? images,
  }) {
    _request = Peticion(
      tipoDeServicio: serviceType,
      nombreDeParte: name,
      cantidad: quantity,
      numeroDeParte: number,
      marca: brand,
      descripcion: description,
      fotos: images,
    );
  }

  void saveVehicleInformation({
    required String make,
    required String model,
    String? version,
    required int year,
    required String motorNumber,
    required String motorType,
    required String transmission,
    required String traction,
    String? vin,
  }) {
    final _uuid = Uuid().v1();

    final _vehicle = Vehiculo(
      id: _uuid,
      marca: make,
      modelo: model,
      ano: year,
      numeroDeMotor: motorNumber,
      tipoDeMotor: motorType,
      transmission: transmission,
      traccion: traction,
      vin: vin,
      version: version,
    );

    _request = _request.copyWith(vehiculo: _vehicle.toJson());
  }

  Future<List<Placemark>> getCurrentLocation() async {
    final position = await LocationService.determinePosition();
    final _latitude = position.latitude;
    final _longitude = position.longitude;
    _currentLocation = LatLng(_latitude, _longitude);

    //getting postal code of the current position to add as
    //initial value to postalCode textField
    return await GeocodingPlatform.instance.placemarkFromCoordinates(
      _latitude,
      _longitude,
    );
  }

  Future<void> getLatLngByPostal(String postalCode) async {
    //should this be in services?
    List<Location> locations = await GeocodingPlatform.instance
        .locationFromAddress('$postalCode ,MX', localeIdentifier: 'es_MX')
        .catchError((e) => throw CustomException(
            code: 'location-from-address',
            message: 'Intente otro codigo postal'));

    _currentLocation = LatLng(locations[0].latitude, locations[0].longitude);

    //save new city just in case user would like to search provider throughout the whole city
    final _placeFromPostalCode = await GeocodingPlatform.instance
        .placemarkFromCoordinates(
            _currentLocation!.latitude, _currentLocation!.longitude);
    _city = _placeFromPostalCode[0].locality;

    notifyListeners();
  }
}
