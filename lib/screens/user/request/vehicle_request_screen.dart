import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './preferences_request_screen.dart';
import '../../../constants.dart';
import '../../../providers/requests/request_provider.dart';

class VehicleRequestScreen extends StatefulWidget {
  static const String screenId = 'vehicle-request-screen';

  const VehicleRequestScreen({Key? key}) : super(key: key);

  @override
  _VehicleRequestScreenState createState() => _VehicleRequestScreenState();
}

class _VehicleRequestScreenState extends State<VehicleRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final String _valMesasge = 'Esta entrada es obligatorio.';

  late String _make, _model, _motorNumber, _motorType, _transmission, _traction;
  String? _version, _vin;
  late int _year;

  void _onSubmit(String option) {
    final _peticionInfo = Provider.of<RequestProvider>(context, listen: false);
    try {
      if (option == 'continue') {
        _peticionInfo.saveVehicleInformation(
          make: _make,
          model: _model,
          year: _year,
          motorNumber: _motorNumber,
          motorType: _motorType,
          transmission: _transmission,
          traction: _traction,
          version: _version,
          vin: _vin,
        );
      } else {
        //save vehicle to user profile
      }

      Navigator.pushNamed(context, PreferencesRequestScreen.screenId);
    } catch (e) {
      print('error');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: kScreenPadding,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: const Text(
                    'Vehiculo',
                    style: kMediumBoldText,
                  ),
                ),
                kSizedBoxH25,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Marca*',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _make = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _valMesasge;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Modelo*',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _model = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _valMesasge;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Version',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _version = value;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: kMainTextInputDecoration.copyWith(
                            labelText: 'Año*',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            setState(() {
                              _year = int.tryParse(value)!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return _valMesasge;
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextFormField(
                          decoration: kMainTextInputDecoration.copyWith(
                            labelText: 'Numero de Motor*',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _motorNumber = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return _valMesasge;
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Tipo de Motor*',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _motorType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _valMesasge;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Tipo de Transmision*',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _transmission = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _valMesasge;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Traccion*',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _traction = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _valMesasge;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Numero de VIN/Serie',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _vin = value;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onSubmit('continue');
                        }
                      },
                      child: Text(
                        'Seguir',
                        style: kButtonText.copyWith(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onSubmit('save');
                        }
                      },
                      child: Text(
                        'Seguir y guardar datos',
                        style: kButtonText.copyWith(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
