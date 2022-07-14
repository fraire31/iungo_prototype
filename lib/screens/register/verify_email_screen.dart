import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/auth.dart';
import '../../services/auth/email_auth_service.dart';
import '../user_home_screen.dart';
import 'home_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const String screenId = 'verify-email-screen';
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final EmailAuthService _emailAuthService = EmailAuthService();
  bool _isEmailVerified = false, _canResendEmail = true;
  Timer? _timer;
  Auth? _auth;

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context, listen: false);

    _isEmailVerified = _auth!.isEmailVerified;
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkedEmailVerified(),
    );
  }

  Future<void> _checkedEmailVerified() async {
    _auth!.userReload();

    setState(() {
      _isEmailVerified = _auth!.isEmailVerified;
      if (_isEmailVerified) {
        _timer?.cancel();
        Navigator.pushNamedAndRemoveUntil(
            context, UserHomeScreen.screenId, (route) => false);
      } ////should this be outside of set state?
    });
  }

  void _sendVerificationEmail() async {
    try {
      await _emailAuthService.sendVerificationEmail();
      setState(() => _canResendEmail = false);
      await Future.delayed(const Duration(seconds: 15));
      setState(() => _canResendEmail = true);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: kScreenPadding,
        child: Center(
          child: Column(
            children: [
              const Text('Debes verificar tu correo electrónico.'),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                    'Revisa tu correo electrónico para hacer clic en el link para verificar tu cuenta.'),
              ),
              ElevatedButton.icon(
                onPressed: _canResendEmail ? _sendVerificationEmail : null,
                label: const Text('Re-enviar Email'),
                icon: const Icon(Icons.email),
              ),
              TextButton(
                onPressed: () {
                  _auth!.logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.screenId, (route) => false);
                },
                child: Text(
                  _canResendEmail ? 'Cerrar sesión' : 'Cancelar',
                  style: const TextStyle(
                    decorationStyle: TextDecorationStyle.solid,
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
