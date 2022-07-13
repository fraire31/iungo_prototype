import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../enums.dart' as enums;
import '../../models/services/servicio.dart';
import '../../repositories/services/servicios_repo.dart';

class ServicesProvider with ChangeNotifier {
  final ServiciosRepo _serviciosRepo = ServiciosRepo();

  Map<String, Servicio> _services = {};

  Map get services => _services;

  List<Servicio> getServicesByOption(enums.serviceOptions option) {
    Map<String, Servicio> filteredMap;
    if (option == enums.serviceOptions.services) {
      filteredMap = Map.from(_services)
        ..removeWhere((key, value) => !value.servicio);
    } else {
      filteredMap = Map.from(_services)
        ..removeWhere((key, value) => value.servicio);
    }

    final mapToList = filteredMap.entries.map((e) => e.value).toList();

    return mapToList;
  }

  void setServices(List<QueryDocumentSnapshot> docs) async {
    _services = {};

    for (var element in docs) {
      final data = element.data() as Map<String, dynamic>;

      final Servicio _service = Servicio.fromJson(data);

      _services[data['id']] = _service;
    }
  }
}
