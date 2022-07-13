import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iungo_prototype/providers/users/user_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../enums.dart' as enums;
import '../../providers/auth.dart';
import '../../services/auth/email_auth_service.dart';
import '../register/verify_email_screen.dart';
import '../user_home_screen.dart';

class EmailRegistrationScreen extends StatefulWidget {
  static const String screenId = 'email-register-screen';

  const EmailRegistrationScreen({Key? key}) : super(key: key);

  @override
  _EmailRegistrationScreenState createState() =>
      _EmailRegistrationScreenState();
}

class _EmailRegistrationScreenState extends State<EmailRegistrationScreen> {
  final EmailAuthService _emailAuthService = EmailAuthService();
  final _formKey = GlobalKey<FormState>();
  late enums.userType _userType;
  String? _name, _lastName, _companyName, _email, _password;

  String? _errorMessage;

  bool _loading = false;

  void _onSubmit() async {
    setState(() {
      _loading = true;
    });

    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    final _auth = Provider.of<Auth>(context, listen: false);

    try {
      await _emailAuthService.registerByEmail(
        companyName: _userType == enums.userType.provider ? _companyName : null,
        name: _userType == enums.userType.user ? _name : null,
        lastName: _userType == enums.userType.user ? _lastName : null,
        email: _email!,
        password: _password!,
        userType: _userType,
      );

      _auth.signInMethod(enums.signInOptions.email);

      if (!_auth.isAuth) return;
      await _userProvider.fetchUserInfo();

      setState(() {
        _loading = false;
      });

      if (_auth.isEmailVerified) {
        Navigator.pushNamedAndRemoveUntil(
            context, UserHomeScreen.screenId, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, VerifyEmailScreen.screenId, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void didChangeDependencies() {
    bool _isInit = true;
    if (_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments
          as Map<String, enums.userType>;
      _userType = args['userType']!;
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
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.check, color: Colors.green, size: 28.0),
                    kSizedBoxW10,
                    Text(
                      'Regístrate',
                      style: kXLargeBoldText,
                    ),
                  ],
                ),
                kSizedBoxH25,
                const Text(
                  'Regístrate y conviértete en un feliz usuario de Iungo',
                  textAlign: TextAlign.left,
                  style: kMediumBoldText,
                ),
                kSizedBoxH25,
                if (_loading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: LinearProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                if (_errorMessage != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
                if (_userType == enums.userType.provider) ...[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre de negocio*',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _companyName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Necesita ingresar nombre de negocio';
                      }
                      return null;
                    },
                  ),
                ],
                if (_userType == enums.userType.user) ...[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre*',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Primer nombre es requerido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _lastName = value;
                    },
                  ),
                ],
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo electronico*',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    _email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un correo electronico.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contraseña*',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ////---LEFT OFF HERE IMPLEMENTING MATCHING PASSWORDS----
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Repite contraseña*',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña de nuevo.';
                    }

                    if (value != _password) {
                      return 'Las contraseñas no coinciden';
                    }

                    return null;
                  },
                ),
                kSizedBoxH25,
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                    if (_formKey.currentState!.validate()) {
                      _onSubmit();
                    }
                  },
                  child: const Text('Registrar', style: kButtonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
