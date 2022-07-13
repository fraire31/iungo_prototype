import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../enums.dart' as enums;
import 'base_auth_service.dart';

class FacebookAuthService extends BaseAuthService {
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Future<void> facebookLogin({enums.userType? userType}) async {
    final LoginResult loginResult = await _facebookAuth.login();

    final OAuthCredential _credentials = FacebookAuthProvider.credential(
      loginResult.accessToken!.token,
    );

    await createNewUserWithOAuthCreds(
      credentials: _credentials,
      userType: userType,
    );
  }

  Future<void> facebookLogout() async {
    await _facebookAuth.logOut();
    super.firebaseAuthLogout();
  }
}
