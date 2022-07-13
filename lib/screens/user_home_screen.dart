import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/auth.dart';
import '../providers/users/user_provider.dart';
import '../widgets/grids/requests/provider_home_view.dart';
import '../widgets/grids/services/services_future_builder.dart';
import 'provider/provider_profile_screen.dart';
import 'register/home_screen.dart';
import 'user/user_profile_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static const String screenId = 'user-home-screen';

  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    final _userData = Provider.of<UserProvider>(context).userData;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message),
          ),
          IconButton(
            onPressed: () {
              _userData!.rol!.contains('provider')
                  ? Navigator.pushNamed(context, ProviderProfileScreen.screenId)
                  : Navigator.pushNamed(context, UserProfileScreen.screenId);
            },
            icon: const Icon(Icons.person),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(
                    child: Image.asset(
                      'assets/images/iungo/iungo_logo_90.png',
                    ),
                  ),
                  if (_userData!.loggedInAs == 'user') ...[
                    const ListTile(title: Text('Mis Vehiculos')),
                    const ListTile(title: Text('Peticiones')),
                  ],
                  if (_userData.loggedInAs == 'provider') ...[
                    const ListTile(title: Text('Peticiones')),
                    const ListTile(title: Text('Cotizas')),
                  ],
                  const ListTile(title: Text('Perfil')),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 35),
                child: Column(
                  children: [
                    ListTile(title: Text('Cuenta')),
                    ListTile(
                      title: const Text('Cerrar sesion'),
                      onTap: () {
                        _auth.logout();
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.screenId, (route) => false);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (_userData.rol!.contains('provider') &&
              (_userData.codigoPostal == null ||
                  _userData.codigoPostal!.isEmpty))
            MaterialBanner(
              backgroundColor: Colors.black26,
              forceActionsBelow: true,
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Color.fromRGBO(247, 198, 0, 1),
                      size: 35,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Provedors tienen que completar su perfil para poder ser buscados.',
                    ),
                  ),
                ],
              ),
              actions: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ProviderProfileScreen.screenId);
                    },
                    label: Text(
                      'Completar fomulario',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (_userData.rol!.contains('user'))
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: kLightGrey,
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .30,
              child: const Text('Hero'),
            ),
          kSizedBoxH25,
          Flexible(
            child: _userData.rol!.contains('provider')
                ? const ProviderHomeView()
                : const ServicesFutureBuilder(),
          ),
          // const Flexible(
          //   child: Center(child: ServicesFutureBuilder()),
          // ),
        ],
      ),
    );
  }
}
