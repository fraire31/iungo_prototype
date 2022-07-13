import 'package:firebase_auth/firebase_auth.dart';

import './base_auth_service.dart';
import '../../enums.dart' as enums;
import '../../repositories/users/user_repo.dart';

class EmailAuthService extends BaseAuthService {
  final UserRepo _userRepo = UserRepo();

  Future<void> registerByEmail({
    String? companyName,
    String? name,
    String? lastName,
    required String email,
    required String password,
    required enums.userType userType,
  }) async {
    //authenticating new user and create new user or provider

    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    if (userCredential.user == null) return;

    await _userRepo.createNewUser(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email!,
      userType: userType,
      name: name,
      lastName: lastName,
      companyName: companyName,
    );

    if (!userCredential.user!.emailVerified) {
      await userCredential.user!.sendEmailVerification();
    }

    await setCustomClaimsRole(
        uid: userCredential.user!.uid,
        roles: [userType.name],
        loggedInAs: userType.name);
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user == null) return;
    await setCustomClaimsRole(uid: userCredential.user!.uid);
  }

  Future<void> sendVerificationEmail() async {
    await firebaseAuth.currentUser!.sendEmailVerification();
  }
}
