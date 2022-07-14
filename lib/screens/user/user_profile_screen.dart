import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iungo_prototype/blocs/blocs/user/user_bloc.dart';
import 'package:iungo_prototype/widgets/buttons/med_white_icon_button.dart';

import '../../constants.dart';

class UserProfileScreen extends StatefulWidget {
  static const String screenId = 'user-profile';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isInit = true;
  String? _profileUrl;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final _state = context.read<UserBloc>().state;
      if (_state is UserLoaded) {
        final _data = _state.user;
        _profileUrl = _data.profileImageUrl ?? '';
        _nameController.text = _data.nombre ?? '';
        _lastNameController.text = _data.apellido ?? '';
      } else {
        _profileUrl = '';
        _nameController.text = '';
        _lastNameController.text = '';
      }

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: kScreenPadding,
        child: ListView(
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
            kSizedBoxH25,
            TextField(
              controller: _nameController,
              decoration:
                  kMainTextInputDecoration.copyWith(labelText: 'Nombre'),
            ),
            kSizedBoxH10,
            TextField(
              controller: _lastNameController,
              decoration:
                  kMainTextInputDecoration.copyWith(labelText: 'apellido'),
            ),
            BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      'Sus han sido guardados.',
                      style: TextStyle(color: Colors.green),
                    ),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
              builder: (context, userState) {
                if (userState is UserLoading) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: LinearProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                child: TextButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: () {
                    context.read<UserBloc>().add(
                          UpdateUserData(
                            userData: {
                              'name': _nameController.text,
                              'lastName': _lastNameController.text,
                              'newProfileImage': _imageFile != null
                                  ? File(_imageFile!.path)
                                  : null,
                              'profileImageUrl': _profileUrl,
                            },
                          ),
                        );
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
    );
  }
}
