import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/services/servicio.dart';

class ServiciosRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addServicios() async {
    await _firestore.collection('services').add({
      'id': 'laksjdf',
      'nombre': 'nombre',
      'servicio': false,
      'description': 'this is a desripcion',
      'urgente': false,
      'usado': true,
    });
  }

  Future<QuerySnapshot> fetchServices() async {
    return await _firestore.collection('servicios').get();
  }

  Future<List<Servicio>> _getServicios() async {
    List<Servicio> _listOfService = [];

    await _firestore.collection('services').get().then((snapshot) {
      snapshot.docs.forEach((element) {
        final data = element.data();

        Servicio _service = Servicio.fromJson(data);

        _listOfService.add(_service);
      });
    });

    return _listOfService;
  }
}
