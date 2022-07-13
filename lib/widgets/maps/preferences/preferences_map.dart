import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../exceptions/custom_exception.dart';
import '../../../providers/requests/request_provider.dart';
import '../../../providers/users/user_provider.dart';
import '../../../screens/user_home_screen.dart';

class PreferencesMap extends StatefulWidget {
  String postalCode;
  String city;

  PreferencesMap({Key? key, required this.postalCode, required this.city})
      : super(key: key);

  @override
  _PreferencesMapState createState() => _PreferencesMapState();
}

class _PreferencesMapState extends State<PreferencesMap> {
  bool _loading = false;
  double _range = 1; //kms
  double _radius = 1000; //meters
  LatLng _latLng = LatLng(19.432608, -99.133209); //MXCD
  bool _searchEntireCity = false;

  void _conversion(double range) {
    int x = range.toInt();
    int i = (x) * (1000); //radius in meters

    setState(() {
      _radius = i.toDouble();
    });
  }

  void _submit() async {
    setState(() {
      _loading = true;
    });
    try {
      final _userName =
          Provider.of<UserProvider>(context, listen: false).userData!.nombre;

      await Provider.of<RequestProvider>(context, listen: false).saveRequest(
        coordinates: _latLng,
        range: _range.toInt(),
        city: widget.city,
        searchEntireCity: _searchEntireCity,
        userName: _userName!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tu peticion a sido enviada.',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );

      setState(() {
        _loading = false;
      });
      Navigator.pushNamedAndRemoveUntil(
          context, UserHomeScreen.screenId, (route) => false);
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
              label: 'OK',
              textColor: Colors.red,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ),
      );
      setState(() {
        _loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Algo salio mal. Intente de nuevo.'),
          action: SnackBarAction(
              label: 'OK',
              textColor: Colors.red,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ),
      );
      setState(() {
        _loading = false;
      });
    }
  }

  void _updateMap() async {
    try {
      if (widget.postalCode.length >= 5) {
        await Provider.of<RequestProvider>(context, listen: false)
            .getLatLngByPostal(widget.postalCode);

        widget.city =
            Provider.of<RequestProvider>(context, listen: false).city as String;
      } else {
        _snackBar('Intente otro Codio Postal.', 'De acuerdo');
      }
    } on CustomException catch (e) {
      if (e.code == 'location-from-address') {
        _snackBar('Intente otro Codio Postal.', 'De acuerdo');
      }
    } catch (e) {
      final _message = e.toString();
      _snackBar(_message, 'De acuerdo');
    }
  }

  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> _snackBar(
      String content, String label) {
    return Future.delayed(const Duration(milliseconds: 600)).then((_) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(content),
          action: SnackBarAction(
              label: label,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestProvider>(
      builder: (context, request, child) {
        _latLng = Provider.of<RequestProvider>(context).currentLocation;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _updateMap();
              },
              onChanged: (value) {
                widget.postalCode = value;
              },
              controller: TextEditingController()..text = widget.postalCode,
              decoration: kMainTextInputDecoration.copyWith(
                labelText: 'Codigo Postal',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('En toda tu ciudad',
                    style: TextStyle(
                      fontSize: kMainFontSize,
                    )),
                SizedBox(
                  width: 25,
                  height: 20,
                  child: Checkbox(
                      value: _searchEntireCity,
                      onChanged: (value) {
                        setState(() {
                          _searchEntireCity = value!;
                        });
                      }),
                )
              ],
            ),
            kSizedBoxH25,
            Text(
              'Distancia de Codigo Postal: ${_range.toInt()} km',
              style: const TextStyle(fontSize: kMainFontSize),
            ),
            Slider.adaptive(
              value: _range,
              min: 1,
              max: 25,
              onChanged: (newRange) {
                setState(() {
                  _range = newRange;
                });
              },
              onChangeEnd: (newRange) {
                _conversion(newRange);
              },
              // divisions: 15,
              label: '${_range.toInt()} km',
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .35,
              child: GoogleMap(
                  onMapCreated: (controller) {
                    controller.moveCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _latLng,
                          zoom: 11.5,
                        ),
                      ),
                    );
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('c'),
                      position: _latLng,
                      draggable: true,
                      onDrag: (c) {
                        print(c);
                      },
                    )
                  },
                  circles: {
                    Circle(
                      fillColor: const Color.fromRGBO(34, 175, 254, .3),
                      strokeColor: kPrimaryColor,
                      strokeWidth: 2,
                      circleId: const CircleId('c'),
                      center: _latLng,
                      radius: _radius,
                    )
                  },
                  initialCameraPosition: CameraPosition(
                    target: _latLng,
                    zoom: 11.5,
                  )),
            ),
            if (_loading)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ElevatedButton(
              onPressed: () {
                _submit();
              },
              child: const Text('Omitir'),
            )
          ],
        );
      },
    );
  }
}
