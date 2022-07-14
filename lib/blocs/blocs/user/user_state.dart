part of 'user_bloc.dart';

@immutable
abstract class UserState extends Equatable {}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserSuccess extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoaded extends UserState {
  final IungoUser user;

  UserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String? message;

  UserError({this.message});
  @override
  List<Object?> get props => [message];
}
