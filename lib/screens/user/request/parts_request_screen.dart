import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../extensions/string.dart';
import '../../../providers/requests/request_provider.dart';
import '../../../widgets/buttons/med_white_icon_button.dart';
import '../request/vehicle_request_screen.dart';

class PartsRequestScreen extends StatefulWidget {
  static const String screenId = 'parts-request-screen';

  const PartsRequestScreen({Key? key}) : super(key: key);

  @override
  _PartsRequestScreenState createState() => _PartsRequestScreenState();
}

class _PartsRequestScreenState extends State<PartsRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Future<void> _displayPickImageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Elige como subir foto:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MedWhiteIconButton(
                    faIcon: Icons.camera,
                    iconColor: Colors.blue,
                    label: 'Tomar foto',
                    onPress: () {
                      _onImageButtonPressed(
                        ImageSource.camera,
                        context: context,
                      );
                      Navigator.of(context).pop();
                    }),
                MedWhiteIconButton(
                    faIcon: Icons.camera_roll,
                    iconColor: Colors.deepOrangeAccent,
                    label: 'Eligir fotos',
                    onPress: () {
                      _onImageButtonPressed(
                        ImageSource.gallery,
                        context: context,
                        isMultiImage: true,
                      );
                      Navigator.of(context).pop();
                    }),
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final List<XFile>? pickedFileList = await _picker.pickMultiImage();
        setState(() {
          _imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget? _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return LimitedBox(
        maxHeight: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return Image.file(
              File(_imageFileList![index].path),
              fit: BoxFit.contain,
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    }

    if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    }

    return null;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _imageFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }
  //---------- IMAGES LOGIC ABOVE ---------

  late String _serviceType;

  late String _name;
  late int _quantity;
  String? _number, _brand, _description, _message;

  void _onSubmit() {
    try {
      Provider.of<RequestProvider>(context, listen: false).savePartsInformation(
        name: _name,
        quantity: _quantity,
        serviceType: _serviceType,
        number: _number,
        brand: _brand,
        description: _description,
        images: _imageFileList,
      );
      Navigator.pushNamed(context, VehicleRequestScreen.screenId);
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    _serviceType = args['serviceName']!;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _serviceType.capitalizeEveryFirstLetter(),
                  style: kMediumBoldText,
                ),
                kSizedBoxH25,
                if (_message != null && _message!.isNotEmpty) ...[
                  Text(
                    _message!,
                    style: const TextStyle(color: Colors.red),
                  )
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Nombre de la Parte*',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Esta entrada es obligatorio.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Cantidad*',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        _quantity = int.tryParse(value)!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Esta entrada es obligatorio.';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Numero de la Parte',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _number = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    decoration: kMainTextInputDecoration.copyWith(
                      labelText: 'Marca',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _brand = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: kMainTextInputDecoration.copyWith(
                        labelText: 'Descripcion', alignLabelWithHint: true),
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                  ),
                ),
                kSizedBoxH10,
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Añadir fotos:',
                    style: kMediumBoldText,
                  ),
                ),
                kSizedBoxH10,
                ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
                    child: _previewImages(),
                  )
                ],
                TextButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  label: Text(
                    'Agregar fotos',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  onPressed: () {
                    _displayPickImageDialog(context);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .25,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _onSubmit();
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
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
