import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../enums.dart' as enums;
import '../services/auth/email_auth_service.dart';
import '../services/auth/facebook_auth_service.dart';
import '../services/auth/google_auth_service.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final FacebookAuthService _facebookAuthService = FacebookAuthService();
  final EmailAuthService _emailAuthService = EmailAuthService();

  User? _user;

  bool _isAuth = false, _isEmailVerified = false;

  enums.signInOptions? _option;

  List? _roles;

  User? get user => _user;

  bool get isAuth => _isAuth;

  enums.signInOptions? get option => _option;

  bool get isEmailVerified => _isEmailVerified;

  List? get roles => _roles;

  bool isProvider() {
    return _roles!.contains('provider');
  }

  void _currentUser() {
    _user = _auth.currentUser;
  }

  void _emailVerified() {
    _isEmailVerified = _user!.emailVerified;
  }

  void userReload() async {
    //reload to have updated user info
    await _auth.currentUser!.reload().then((value) {
      _currentUser();
      _emailVerified();
    });
  }

  void signInMethod(enums.signInOptions option) {
    _currentUser();
    _emailVerified();
    _option = option;

    if (_user != null) {
      _isAuth = true;
    } else {
      _isAuth = false;
    }
  }

  void logout() async {
    switch (_option) {
      case enums.signInOptions.google:
        {
          await _googleAuthService.googleDisconnect();
        }
        break;
      case enums.signInOptions.facebook:
        {
          await _facebookAuthService.facebookLogout();
        }
        break;
      case enums.signInOptions.email:
        {
          await _emailAuthService.firebaseAuthLogout();
        }
        break;

      default:
        {
          _auth.signOut();
        }
        break;
    }
    _user = null;
    _isAuth = false;
    _option = null;
    _isEmailVerified = false;
    _roles = null;
  }
}
