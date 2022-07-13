import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iungo_prototype/providers/auth.dart';
import 'package:provider/provider.dart';

import './email_login_screen.dart';
import '../../constants.dart';
import '../../enums.dart' as enums;
import '../../exceptions/custom_exception.dart';
import '../../providers/users/user_provider.dart';
import '../../services/auth/facebook_auth_service.dart';
import '../../services/auth/google_auth_service.dart';
import '../../widgets/buttons/med_white_icon_button.dart';
import '../../widgets/dialogs/sign_in_dialog.dart';
import '../register/verify_email_screen.dart';
import '../user_home_screen.dart';

class LoginOptionsScreen extends StatefulWidget {
  static const String screenId = 'sign-in-options-screen';

  const LoginOptionsScreen({Key? key}) : super(key: key);

  @override
  State<LoginOptionsScreen> createState() => _LoginOptionsScreenState();
}

class _LoginOptionsScreenState extends State<LoginOptionsScreen> {
  late enums.signInOptions _signInOption;
  late String _linkPassword;

  void _submit() async {
    final _auth = Provider.of<Auth>(context, listen: false);
    final _userProvider = Provider.of<UserProvider>(context, listen: false);

    switch (_signInOption) {
      case enums.signInOptions.google:
        {
          final GoogleAuthService _googleAuthService = GoogleAuthService();

          try {
            await _googleAuthService.googleLogin();
          } on CustomException catch (e) {
            if (e.code == 'register-first') {
              final message = e.message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  action: SnackBarAction(
                    label: "Okay",
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );

              await _googleAuthService.googleDisconnect();
            }
          }
        }
        break;
      case enums.signInOptions.facebook:
        {
          FacebookAuthService _facebookAuthService = FacebookAuthService();

          try {
            await _facebookAuthService.facebookLogin();
          } on CustomException catch (e) {
            if (e.code == 'register-first') {
              final message = e.message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  action: SnackBarAction(
                    label: "Okay",
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );

              await _facebookAuthService.facebookLogout();
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'account-exists-with-different-credential') {
              //merge existing account w fb idp
              final _email = e.email;

              final String? _accountType = await _facebookAuthService
                  .fetchSignInMethodsForEmail(_email!);

              if (_accountType == 'password' ||
                  _accountType == 'facebook.com') {
                await await showDialog(
                  context: context,
                  builder: (context) {
                    return SignInDialog(
                      accountType: _accountType!,
                      signInOption: _signInOption,
                      password: _getDialogPassword,
                    );
                  },
                );
              }

              await _facebookAuthService.linkAccount(
                email: _email,
                password: _linkPassword,
                accountType: _accountType,
                option: _signInOption,
                credential: e.credential!,
              );
            }
          }
        }
        break;
      default:
        {}
        break;
    }

    _auth.signInMethod(_signInOption);

    if (!_auth.isAuth) return;
    await _userProvider.fetchUserInfo();

    if (_signInOption == enums.signInOptions.google ||
        _signInOption == enums.signInOptions.facebook) {
      Navigator.pushNamedAndRemoveUntil(
          context, UserHomeScreen.screenId, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, VerifyEmailScreen.screenId, (route) => false);
    }
  }

  _getDialogPassword(String value) {
    _linkPassword = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: kScreenPadding,
          child: Column(
            children: [
              Image.asset(
                'assets/images/iungo/iungo_logo_440.png',
                height: MediaQuery.of(context).size.height * .40,
              ),
              kSizedBoxH25,
              const Text(
                'Como te gustaria iniciar sesion:',
                style: kMediumBoldText,
                textAlign: TextAlign.center,
              ),
              kSizedBoxH25,
              MedWhiteIconButton(
                faIcon: FontAwesomeIcons.envelope,
                iconColor: Theme.of(context).colorScheme.primary,
                label: 'Correo Electronico',
                onPress: () => Navigator.pushNamed(
                  context,
                  EmailLoginScreen.screenId,
                ),
              ),
              MedWhiteIconButton(
                faIcon: FontAwesomeIcons.google,
                iconColor: const Color.fromRGBO(234, 67, 53, 1),
                label: 'Google',
                onPress: () {
                  _signInOption = enums.signInOptions.google;
                  _submit();
                },
              ),
              MedWhiteIconButton(
                faIcon: FontAwesomeIcons.facebook,
                iconColor: const Color.fromRGBO(19, 112, 230, 1),
                label: 'Facebook',
                onPress: () {
                  _signInOption = enums.signInOptions.facebook;
                  _submit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
