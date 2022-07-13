import 'package:flutter/material.dart';

import './registration_options_screen.dart';
import '../../constants.dart';
import '../../enums.dart' as enums;

class RegisterScreen extends StatelessWidget {
  static const String screenId = 'register-screen';
  const RegisterScreen({Key? key}) : super(key: key);

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
              const Text(
                'Me quiero registrar como un:',
                style: kMediumBoldText,
              ),
              kSizedBoxH25,
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RegistrationOptionsScreen.screenId,
                            arguments: {'userType': enums.userType.user});
                      },
                      child: Card(
                        child: Column(
                          children: const [
                            ListTile(
                              title: Text(
                                'Usuario',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Icon(
                                Icons.person_outline,
                                size: 55,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RegistrationOptionsScreen.screenId,
                            arguments: {'userType': enums.userType.provider});
                      },
                      child: Card(
                        child: Column(
                          children: const [
                            ListTile(
                              title: Text(
                                'Provedor',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Icon(
                                Icons.handshake_outlined,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
