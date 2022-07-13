import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_range/flutter_time_range.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iungo_prototype/extensions/string.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/users/user_provider.dart';
import '../../widgets/buttons/med_white_icon_button.dart';
import '../../widgets/grids/services/provider_services_future_builder.dart';

class ProviderProfileScreen extends StatefulWidget {
  static const String screenId = 'provider-profile-screen';

  const ProviderProfileScreen({Key? key}) : super(key: key);

  @override
  _ProviderProfileScreenState createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  XFile? _imageFile;

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value ?? null;
  }

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    BuildContext? context,
  }) async {
    ///CAN SET QUALITY TO 50 AND WIDTH TO SMALL SO THAT ITS EASIER TO UPLOAD
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

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return SizedBox(
        height: 120,
        child: FittedBox(
          fit: BoxFit.contain,
          child: CircleAvatar(
            backgroundImage: FileImage(
              File(_imageFile!.path),
            ),
          ),
        ),
      );
    } else if (_pickImageError != null) {
      return Column(
        children: [
          Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: Color.fromRGBO(247, 198, 0, 1),
                size: 35,
              ),
              Text('Se ha producido un error.')
            ],
          ),
          const Text('Intente subir otra photo o toma una foto.')
        ],
      );
    } else {
      if (_profileUrl == null || _profileUrl!.isEmpty) {
        return Container(
          height: 120,
          width: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                'assets/images/placeholders/blue_placeholder.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: _profileUrl!,
          errorWidget: (context, url, error) {
            return Container(
              color: Colors.grey.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error),
                  Text('Error al cargar imagen.')
                ],
              ),
            );
          },
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          imageBuilder: (context, imageProvider) => SizedBox(
            height: 120,
            child: FittedBox(
              fit: BoxFit.contain,
              child: CircleAvatar(backgroundImage: imageProvider),
            ),
          ),
        );
      }
    }
  }

  Future<void> _displayPickImageDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elige como subir foto'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            MedWhiteIconButton(
                faIcon: Icons.camera,
                iconColor: Colors.blue,
                label: 'Tomar foto',
                onPress: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                  Navigator.of(context).pop();
                }),
            MedWhiteIconButton(
              faIcon: Icons.camera_roll,
              iconColor: Colors.deepOrangeAccent,
              label: 'Elegir foto',
              onPress: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
                Navigator.of(context).pop();
              },
            ),
          ]),
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
      },
    );
  }

  //--------------IMAGE LOGIC ABOVE-----------
  bool _loading = false;
  bool _isInit = true;

  String? _profileUrl;

  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _managerNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _suburbController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final _userProvider = Provider.of<UserProvider>(context, listen: false);
      final _providerData = _userProvider.userData;

      _profileUrl = _providerData?.profileImageUrl ?? '';

      _companyNameController.text = _providerData?.nombreDeNegocio ?? '';
      _managerNameController.text = _providerData?.nombreDeGerente ?? '';
      _streetController.text = _providerData?.calle ?? '';
      _suburbController.text = _providerData?.colonia ?? '';
      _cityController.text = _providerData?.ciudad ?? '';
      _stateController.text = _providerData?.estado ?? '';
      _postalCodeController.text = _providerData?.codigoPostal ?? '';
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _managerNameController.dispose();
    _streetController.dispose();
    _suburbController.dispose();
    _cityController.dispose();
    _stateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    final _providerServices = _userProvider.userData!.serviciosDisponible;
    final _schedule = _userProvider.userData!.horario;

    void _submit() async {
      setState(() {
        _loading = true;
      });

      final _entireData = {
        'general': {
          'newProfileImage': _imageFile != null ? File(_imageFile!.path) : null,
          'profileImageUrl': _profileUrl,
          'companyName': _companyNameController.text,
          'managerName': _managerNameController.text,
          'street': _streetController.text,
          'suburb': _suburbController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'postalCode': _postalCodeController.text,
        },
        'schedule': _schedule,
        'services': _providerServices,
      };

      await _userProvider.updateProviderData(_entireData).then((results) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Sus datos han sido guardados.',
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.green,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }).catchError((e) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Algo salio mal. Intente de nuevo si sus datos no aparentan guardados',
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.red,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      });
    }

    Future<void> showTimeRangePicker12Hour(BuildContext context, String day) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Horario de ${day.capitalizeEveryFirstLetter()}"),
              content: TimeRangePicker(
                initialFromHour: DateTime.now().hour,
                initialFromMinutes: DateTime.now().minute,
                initialToHour: DateTime.now().hour,
                initialToMinutes: DateTime.now().minute,
                tabFromText: "Desde",
                tabToText: "Hasta",
                backText: "Regresar",
                nextText: "Siguiente",
                cancelText: "Cancelar",
                selectText: "Seleccionar",
                editable: true,
                is24Format: false,
                disableTabInteraction: false,
                inactiveBgColor: kLightGrey,
                timeContainerStyle: BoxDecoration(
                  color: kLightGrey,
                  borderRadius: BorderRadius.circular(7),
                ),
                separatorStyle:
                    const TextStyle(color: kLightGrey, fontSize: 30),
                selectedTimeStyle: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 30,
                ),
                activeBgColor: Theme.of(context).colorScheme.tertiary,
                activeLabelColor: Theme.of(context).colorScheme.tertiary,
                indicatorColor: Theme.of(context).colorScheme.tertiary,
                unselectedTimeStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                ),
                onSelect: (from, to) {
                  final fromFormatted =
                      TimeOfDay(hour: from.hour, minute: from.minute)
                          .format(context);

                  final toFormatted =
                      TimeOfDay(hour: to.hour, minute: to.minute)
                          .format(context);

                  setState(() {
                    _schedule![day] = '$fromFormatted - $toFormatted';
                    _userProvider.updateProviderSchedule(_schedule);
                  });

                  Navigator.pop(context);
                },
                onCancel: () => Navigator.pop(context),
              ),
            );
          });
    }

    Widget _weekdayRow(String weekday) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$weekday: '.capitalizeEveryFirstLetter(),
                style: kRegularBoldText,
              ),
            ),
            Expanded(
              flex: 3,
              child: (_schedule![weekday]!.isEmpty)
                  ? TextButton.icon(
                      icon: Icon(
                        Icons.add,
                        size: 18,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () {
                        showTimeRangePicker12Hour(context, weekday);
                      },
                      label: Text(
                        'Agregar horario',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        showTimeRangePicker12Hour(context, weekday);
                      },
                      child: Text(
                        '${_schedule[weekday]}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
            ),
            if (_schedule[weekday] != null && _schedule[weekday] != 'Cerrado')
              Expanded(
                  flex: 2,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _schedule[weekday] = 'Cerrado';
                      });
                    },
                    icon: const Icon(Icons.remove,
                        size: 18, color: Colors.black54),
                    label: const Text(
                      'Cerrado',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ))
          ],
        ),
      );
    }

    Widget _customTextField(TextEditingController controller, String label) {
      return TextFormField(
        controller: controller,
        decoration: kMainTextInputDecoration.copyWith(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            final _filteredLabel = label.replaceAllMapped('*', (match) => '');
            return 'No puede dejar $_filteredLabel vacio.';
          }
          return null;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: kScreenPadding,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              ...[_previewImages()],
              TextButton.icon(
                onPressed: () {
                  _displayPickImageDialog(context);
                },
                icon: const Icon(
                  Icons.edit,
                  size: 16,
                ),
                label: const Text('Edit profile'),
              ),
              kSizedBoxH10,
              _customTextField(_companyNameController, 'Nombre de Negocio*'),
              kSizedBoxH10,
              _customTextField(_managerNameController, 'Nombre de gerente'),
              kSizedBoxH25,
              const Text(
                'Informacion general:',
                style: kMediumBoldText,
              ),
              kSizedBoxH10,
              _customTextField(_streetController, 'Calle*'),
              kSizedBoxH10,
              _customTextField(_suburbController, 'Colonia*'),
              kSizedBoxH10,
              _customTextField(_cityController, 'Ciudad*'),
              kSizedBoxH10,
              _customTextField(_stateController, 'Estado*'),
              kSizedBoxH10,
              _customTextField(_postalCodeController, 'Codigo Postal*'),
              kSizedBoxH25,
              const Text(
                'Horario:',
                style: kMediumBoldText,
              ),
              _weekdayRow('lunes'),
              _weekdayRow('martes'),
              _weekdayRow('miercoles'),
              _weekdayRow('jueves'),
              _weekdayRow('viernes'),
              _weekdayRow('sabado'),
              _weekdayRow('domingo'),
              kSizedBoxH25,
              const Text(
                'Servicios:',
                style: kMediumBoldText,
              ),
              kSizedBoxH10,
              const ProviderServicesFutureBuilder(),
              kSizedBoxH25,
              if (_loading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                      color: Theme.of(context).colorScheme.primary),
                ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                  child: TextButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    onPressed: () {
                      bool _providerHasServices = _providerServices != null &&
                          _providerServices.isNotEmpty;

                      if (_formKey.currentState!.validate() &&
                          _providerHasServices) {
                        _submit();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              !_providerHasServices
                                  ? 'Tiene que elegir minimo un servicio.'
                                  : 'No puede dejar el formulario vacio. Sus datos no han sido guardados.',
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    label: Text(
                      'Guardar',
                      style: kButtonText.copyWith(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
