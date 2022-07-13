import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:iungo_prototype/models/users/user.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
}
