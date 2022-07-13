import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iungo_prototype/constants.dart';
import 'package:iungo_prototype/extensions/string.dart';
import 'package:iungo_prototype/providers/users/user_provider.dart';
import 'package:iungo_prototype/repositories/services/servicios_repo.dart';
import 'package:provider/provider.dart';

class ProviderServicesFutureBuilder extends StatefulWidget {
  const ProviderServicesFutureBuilder({Key? key}) : super(key: key);

  @override
  _ProviderServicesFutureBuilderState createState() =>
      _ProviderServicesFutureBuilderState();
}

class _ProviderServicesFutureBuilderState
    extends State<ProviderServicesFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);
    final _userServices = _userProvider.userData!.serviciosDisponible;

    return FutureBuilder<QuerySnapshot>(
      future: ServiciosRepo().fetchServices(),
      builder: (context, snapshot) {
        Widget _children;
        if (snapshot.hasData) {
          final _docs = snapshot.data!.docs;

          _children = LimitedBox(
            maxHeight: 300,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _docs.length,
              itemBuilder: (context, index) {
                final _service = _docs[index];
                final name = _service['nombre'].toString();

                return InkWell(
                  onDoubleTap: () {
                    if (_userServices!.contains(name)) {
                      setState(() {
                        _userProvider.updateProviderServices(name);
                      });
                    } else {
                      setState(() {
                        _userProvider.updateProviderServices(name);
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: (_userServices!.contains(name))
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: const Border(
                              top: BorderSide(width: 4, color: Colors.blue),
                              left: BorderSide(width: 4, color: Colors.blue),
                              bottom: BorderSide(width: 4, color: Colors.blue),
                              right: BorderSide(width: 4, color: Colors.blue),
                            ),
                          )
                        : null,
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/placeholders/blue_placeholder.png'),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                name.capitalizeEveryFirstLetter(),
                                textAlign: TextAlign.center,
                                style: kRegularText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          _children = Column(
            children: const [
              Text('Cargando servicios ..'),
              CircularProgressIndicator.adaptive()
            ],
          );
        } else {
          _children = Column(
            children: const [
              Text('Cargando servicios ..'),
              CircularProgressIndicator.adaptive()
            ],
          );
        }

        return _children;
      },
    );
  }
}
