import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iungo_prototype/blocs/blocs/user/user_bloc.dart';
import 'package:iungo_prototype/providers/users/user_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../enums.dart' as enums;
import '../../providers/auth.dart';
import '../../services/auth/email_auth_service.dart';
import '../register/verify_email_screen.dart';
import '../user_home_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  static const String screenId = 'email-signin-screen';

  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final EmailAuthService _emailAuthService = EmailAuthService();
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  String? _errorMessage;

  bool _loading = false;

  void _onSubmit() async {
    setState(() {
      _loading = true;
    });

    final _userProvider = Provider.of<UserProvider>(context, listen: false);

    final _auth = Provider.of<Auth>(context, listen: false);

    try {
      await _emailAuthService.loginWithEmail(
          email: _email, password: _password);

      _auth.signInMethod(enums.signInOptions.email);
      if (!_auth.isAuth) return;

      await _userProvider.fetchUserInfo();
      context.read<UserBloc>().add(FetchUserData());

      setState(() {
        _loading = false;
      });

      if (_auth.isEmailVerified) {
        Navigator.pushNamedAndRemoveUntil(
            context, UserHomeScreen.screenId, (route) => false);
      } else {
        await _emailAuthService.sendVerificationEmail();
        Navigator.pushNamedAndRemoveUntil(
            context, VerifyEmailScreen.screenId, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = 'No se encuentra tal usuario.';
      } else if (e.code == 'wrong-password') {
        _errorMessage =
            'La contraseña no es válida o el usuario no tiene contraseña.';
      } else {
        _errorMessage = e.message;
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: kScreenPadding,
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
                      'Iniciar sesion',
                      style: kXLargeBoldText,
                    ),
                  ],
                ),
                kSizedBoxH25,
                const Text('Impieza usar IUNGO para ....',
                    textAlign: TextAlign.left, style: kMediumBoldText),
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
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'correo electronico',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                kSizedBoxH25,
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'contraseña', border: OutlineInputBorder()),
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                kSizedBoxH25,
                ElevatedButton(
                  onPressed: () {
                    _onSubmit();
                  },
                  child: const Text('Ingresar', style: kButtonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
