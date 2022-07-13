import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import './email_registration_screen.dart';
import '../../constants.dart';
import '../../enums.dart' as enums;
import '../../providers/auth.dart';
import '../../providers/users/user_provider.dart';
import '../../services/auth/facebook_auth_service.dart';
import '../../services/auth/google_auth_service.dart';
import '../../widgets/buttons/med_white_icon_button.dart';
import '../../widgets/dialogs/sign_in_dialog.dart';
import '../user_home_screen.dart';

class RegistrationOptionsScreen extends StatefulWidget {
  static const String screenId = 'idp-options-screen';

  const RegistrationOptionsScreen({Key? key}) : super(key: key);

  @override
  _RegistrationOptionsScreenState createState() =>
      _RegistrationOptionsScreenState();
}

class _RegistrationOptionsScreenState extends State<RegistrationOptionsScreen> {
  late enums.userType _userType;
  late enums.signInOptions _signInOption;
  late String _linkPassword;

  void _submit() async {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    final _auth = Provider.of<Auth>(context, listen: false);
    switch (_signInOption) {
      case enums.signInOptions.google:
        {
          await GoogleAuthService().googleLogin(userType: _userType);
        }
        break;
      case enums.signInOptions.facebook:
        {
          FacebookAuthService _facebookAuthService = FacebookAuthService();
          await _facebookAuthService
              .facebookLogin(userType: _userType)
              .catchError((error) async {
            final e = error as FirebaseAuthException;
            if (e.code == 'account-exists-with-different-credential') {
              final _email = e.email;

              final String? _accountType = await _facebookAuthService
                  .fetchSignInMethodsForEmail(_email!);

              if (_accountType == 'password' ||
                  _accountType == 'facebook.com') {
                await showDialog(
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
          });
        }
        break;

      default:
        {}
        break;
    }

    _auth.signInMethod(_signInOption);

    if (!_auth.isAuth) return;
    await _userProvider.fetchUserInfo();

    Navigator.pushNamedAndRemoveUntil(
        context, UserHomeScreen.screenId, (route) => false);
  }

  _getDialogPassword(String value) {
    _linkPassword = value;
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
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: kScreenPadding,
          child: Column(
            children: [
              Image.asset(
                'assets/images/iungo/iungo_logo_440.png',
                height: 300,
              ),
              kSizedBoxH25,
              const Text(
                'Como te gustaria registrarte:',
                style: kMediumBoldText,
              ),
              kSizedBoxH25,
              MedWhiteIconButton(
                faIcon: FontAwesomeIcons.envelope,
                iconColor: Theme.of(context).colorScheme.primary,
                label: 'Correo Electronico',
                onPress: () => Navigator.pushNamed(
                  context,
                  EmailRegistrationScreen.screenId,
                  arguments: {'userType': _userType},
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
