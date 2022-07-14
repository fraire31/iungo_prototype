import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../models/users/user.dart';
import '../../../repositories/users/user_repo.dart';
import '../../../services/firebase_storage/storage_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoading()) {
    final UserRepo _userRepo = UserRepo();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    on<FetchUserData>((event, emit) async {
      final data = await _userRepo.fetchUserData(uid: _auth.currentUser!.uid);
      final user = data.docs.first.data();
      final iungoUser = IungoUser.fromJson(user);
      emit(UserLoaded(user: iungoUser));
    });

    on<UpdateUserData>((event, emit) async {
      final state = this.state;
      final StorageService _service = StorageService();
      if (state is UserLoaded) {
        emit(UserLoading());
        String? url = event.userData['profileImageUrl'];
        if (event.userData['newProfileImage'] != null) {
          if (url!.isNotEmpty) {
            await _service.deleteFileImage();
          }

          url = await _service.updateProfileImage(
              image: event.userData['newProfileImage']);
        }

        final IungoUser user = state.user.copyWith(
          nombre: event.userData['name'],
          apellido: event.userData['lastName'],
          profileImageUrl: url,
        );

        await _userRepo.updateUserProfileData(data: user).then((_) {
          emit(UserSuccess());
          emit(UserLoaded(user: user));
        });
      }
    });
  }
}
