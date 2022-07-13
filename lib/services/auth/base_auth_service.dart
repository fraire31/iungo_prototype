import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../enums.dart' as enums;
import '../../exceptions/custom_exception.dart';
import '../../repositories/users/user_repo.dart';

class BaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  final UserRepo _userRepo = UserRepo();

  //USED IN FACEBOOK_AUTH_REPO AND GOOGLE_AUTH_REPO
  Future<void> createNewUserWithOAuthCreds({
    required OAuthCredential credentials,
    enums.userType? userType,
  }) async {
    //separating _isNewUser logic to avoid creating two auth instances in facebook and
    //google_signin repos
    final _auth = await _signInWithCredentials(credentials: credentials);
    final _isNewUser = _auth.additionalUserInfo!.isNewUser;

    //if userType is null = user is logging in
    //executes when user is trying to login(via idp) without having an account
    //this way the system doesn't automatically create an account for them, they have to manually
    //create one
    if (userType == null && _isNewUser) {
      try {
        await firebaseAuth.currentUser!.delete();
        throw CustomException(
            code: 'register-first',
            message: 'No account exists. You must register first.');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          //needed to delete user
          await firebaseAuth.currentUser!
              .reauthenticateWithCredential(credentials);
        }
      }
    }

    //creates new user in the database
    if (userType != null && _isNewUser) {
      await _userRepo.createNewUser(
        uid: _auth.user!.uid,
        email: _auth.user!.email!,
        userType: userType,
      );

      if (!_auth.user!.emailVerified) {
        await _auth.user!.sendEmailVerification();
      }

      await setCustomClaimsRole(
          uid: _auth.user!.uid,
          roles: [userType.name],
          loggedInAs: userType.name);
    } else {
      await setCustomClaimsRole(uid: _auth.user!.uid);
    }
  }

  Future<void> linkAccount({
    required String email,
    String? password,
    String? accountType,
    required enums.signInOptions option,
    required AuthCredential credential,
  }) async {
    if (option == enums.signInOptions.facebook) {
      if (accountType == 'google.com') {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final googleAuth = await googleUser!.authentication;

        final OAuthCredential _oAuthCred = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _signInWithCredentials(credentials: _oAuthCred);
      }

      if (accountType == 'password') {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password!);
      }
    }

    await firebaseAuth.currentUser!.linkWithCredential(credential);
  }

  Future<UserCredential> _signInWithCredentials(
      {required OAuthCredential credentials}) async {
    return await firebaseAuth.signInWithCredential(credentials);
  }

  Future<String?> fetchSignInMethodsForEmail(String email) async {
    final _accounts = await firebaseAuth.fetchSignInMethodsForEmail(email);
    if (_accounts.isEmpty) return null;

    return _accounts.first.toString();
  }

  Future<void> setCustomClaimsRole({
    required String uid,
    List? roles,
    String? loggedInAs,
  }) async {
    try {
      HttpsCallable callable = _functions.httpsCallable('setRole');
      final results = await callable
          .call({'uid': uid, 'roles': roles, 'loggedInAs': loggedInAs});
    } on FirebaseFunctionsException catch (e) {
      print('---cloud function error---');
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  Future<void> firebaseAuthLogout() async {
    await firebaseAuth.signOut();
  }
}
