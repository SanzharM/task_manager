part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent {}

class EditProfile extends ProfileEvent {
  final User user;
  EditProfile(this.user);

  @override
  List<Object> get props => [user];
}

class GetCollegues extends ProfileEvent {}
