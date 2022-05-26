part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ErrorState extends ProfileState {
  final String error;
  ErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileEdited extends ProfileState {
  final User user;
  ProfileEdited(this.user);

  @override
  List<Object> get props => [user];
}

class ColleguesLoading extends ProfileState {}

class ColleguesLoaded extends ProfileState {
  final List<User> collegues;
  ColleguesLoaded(this.collegues);

  @override
  List<Object> get props => [collegues];
}
