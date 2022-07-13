import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../providers/requests/request_provider.dart';
import '../../../widgets/maps/preferences/preferences_map.dart';

class PreferencesRequestScreen extends StatefulWidget {
  static const String screenId = 'preferences-request-screen';

  const PreferencesRequestScreen({Key? key}) : super(key: key);

  @override
  _PreferencesRequestScreenState createState() =>
      _PreferencesRequestScreenState();
}

class _PreferencesRequestScreenState extends State<PreferencesRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        body: Padding(
          padding: kScreenPadding,
          child: FutureBuilder(
              //future gets latLng then sets postalcode
              future: Provider.of<RequestProvider>(context, listen: false)
                  .getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final placemarkList = snapshot.data as List<Placemark>;
                  final data = placemarkList[0];
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Preferencias',
                          style: kMediumBoldText,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Ubicacion del provedor:',
                          style: TextStyle(fontSize: kMainFontSize),
                        ),
                        kSizedBoxH25,
                        PreferencesMap(
                            postalCode: data.postalCode!, city: data.locality!),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: const [
                        Icon(Icons.warning),
                        Text('Huy! Algo salió mal.'),
                        Text(
                          'Asegura que IUNGO tenga permiso para user su ubicaion'
                          ' para encontrar un provedor acerca de usted.',
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text('Cargando ...'),
                        ),
                        CircularProgressIndicator.adaptive(),
                      ],
                    ),
                  );
                }
              }),
        ));
  }
}
