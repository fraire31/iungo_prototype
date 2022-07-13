import 'package:flutter/material.dart';

import './register_screen.dart';
import '../../constants.dart';
import '../../screens/login/login_options_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String screenId = 'home-screen';

  const HomeScreen({Key? key}) : super(key: key);

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
                'Register to IUNGO to start doing stuff',
                style: kMediumText,
              ),
              kSizedBoxH25,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.screenId);
                      },
                      child: const Text('Registrate'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                  ),
                  kSizedBoxW10,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, LoginOptionsScreen.screenId);
                      },
                      child: const Text('Iniciar sesion'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                  ),
                  // Expanded(
                  //     child: TextButton(
                  //   child: const Text('sign out'),
                  //   onPressed: () {
                  //     GoogleSignIn().disconnect();
                  //     FirebaseAuth.instance.signOut();
                  //
                  //     Provider.of<Auth>(context, listen: false).logout();
                  //   },
                  // ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
