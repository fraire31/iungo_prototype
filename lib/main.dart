import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import './blocs/blocs/user/user_bloc.dart';
import './constants.dart';
import './firebase_options.dart';
import './providers/auth.dart';
import './providers/requests/provider_requests_provider.dart';
import './providers/requests/request_provider.dart';
import './providers/services/services_provider.dart';
import './providers/users/user_provider.dart';
import './routes.dart';
import './screens/register/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) {
          return UserBloc();
        })
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ServicesProvider()),
          ChangeNotifierProvider(create: (_) => RequestProvider()),
          ChangeNotifierProvider(create: (_) => ProviderRequestsProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Iungo',
      theme: ThemeData(
        fontFamily: 'PT Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          tertiary: kPrimaryDarkColor,
        ),
        textTheme: const TextTheme(
            bodyText1: TextStyle(fontSize: 16),
            bodyText2: TextStyle(fontSize: 16),
            button: TextStyle(fontSize: 16)),
      ),
      initialRoute: HomeScreen.screenId,
      routes: customRoutes,
    );
  }
}
