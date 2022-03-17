part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class GetAuth extends LoginEvent {
  final String? phone;
  GetAuth({this.phone});

  @override
  List<Object?> get props => [];
}

class VerifySMSCode extends LoginEvent {
  final String phone;
  final String? code;
  VerifySMSCode({required this.phone, required this.code});

  @override
  List<Object?> get props => [];
}
