import 'package:flutter/material.dart';

import './screens/login/email_login_screen.dart';
import './screens/login/login_options_screen.dart';
import './screens/provider/provider_profile_screen.dart';
import './screens/register/email_registration_screen.dart';
import './screens/register/home_screen.dart';
import './screens/register/register_screen.dart';
import './screens/register/registration_options_screen.dart';
import './screens/register/verify_email_screen.dart';
import './screens/user/request/parts_request_screen.dart';
import './screens/user/request/preferences_request_screen.dart';
import './screens/user/request/vehicle_request_screen.dart';
import './screens/user/user_profile_screen.dart';
import 'screens/user_home_screen.dart';

var customRoutes = <String, WidgetBuilder>{
  HomeScreen.screenId: (context) => const HomeScreen(),
  EmailRegistrationScreen.screenId: (context) =>
      const EmailRegistrationScreen(),
  RegisterScreen.screenId: (context) => const RegisterScreen(),
  RegistrationOptionsScreen.screenId: (context) =>
      const RegistrationOptionsScreen(),
  EmailLoginScreen.screenId: (context) => const EmailLoginScreen(),
  VerifyEmailScreen.screenId: (context) => const VerifyEmailScreen(),
  LoginOptionsScreen.screenId: (context) => const LoginOptionsScreen(),
  UserHomeScreen.screenId: (context) => const UserHomeScreen(),
  PartsRequestScreen.screenId: (context) => const PartsRequestScreen(),
  VehicleRequestScreen.screenId: (context) => VehicleRequestScreen(),
  PreferencesRequestScreen.screenId: (context) =>
      const PreferencesRequestScreen(),
  UserProfileScreen.screenId: (context) => const UserProfileScreen(),
  ProviderProfileScreen.screenId: (context) => const ProviderProfileScreen(),
};
