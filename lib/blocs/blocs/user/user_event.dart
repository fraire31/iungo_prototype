part of 'user_bloc.dart';

@immutable
abstract class UserEvent extends Equatable {}

class FetchUserData extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UpdateUserData extends UserEvent {
  final Map userData;

  UpdateUserData({required this.userData});

  @override
  List<Object?> get props => [userData];
}
