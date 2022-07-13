import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './custom_grid_view.dart';
import '../../../providers/services/services_provider.dart';

class ServicesFutureBuilder extends StatefulWidget {
  const ServicesFutureBuilder({Key? key}) : super(key: key);

  @override
  _ServicesFutureBuilderState createState() => _ServicesFutureBuilderState();
}

class _ServicesFutureBuilderState extends State<ServicesFutureBuilder> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final _services = Provider.of<ServicesProvider>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('servicios').snapshots(),
      builder: (context, snapshot) {
        List<Widget> children;

        if (snapshot.hasError) {
          children = [
            const Text('Ubo un error: '),
            Text('${snapshot.error}'),
          ];
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              children = const [
                Text('Cargando Datos...'),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ];

              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                _services.setServices(snapshot.data!.docs);
                children = [
                  const Flexible(
                    child: CustomGridView(),
                  ),
                ];
              } else {
                children = const [
                  CircularProgressIndicator.adaptive(),
                ];
              }
              break;
          }
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        );
      },
    );
  }
}
