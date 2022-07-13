import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './base_auth_service.dart';
import '../../enums.dart' as enums;

class GoogleAuthService extends BaseAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> googleLogin({enums.userType? userType}) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final OAuthCredential _credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await createNewUserWithOAuthCreds(
        credentials: _credentials, userType: userType);
  }

  Future<void> googleDisconnect() async {
    await _googleSignIn.disconnect();
    super.firebaseAuthLogout();
  }
}
