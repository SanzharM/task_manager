part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class EmptyState extends LoginState {
  @override
  List<Object?> get props => [];
}

class Loading extends LoginState {
  @override
  List<Object?> get props => [];
}

class ErrorState extends LoginState {
  final String error;
  ErrorState(this.error);

  @override
  List<Object?> get props => [];
}

class AuthVerifySuccess extends LoginState {
  final String token;
  AuthVerifySuccess(this.token);

  @override
  List<Object?> get props => [];
}

class PhoneAuthSuccess extends LoginState {
  final String phone;
  PhoneAuthSuccess(this.phone);

  @override
  List<Object?> get props => [];
}

class CodeCompanyVerified extends LoginState {
  final String code;
  CodeCompanyVerified(this.code);
  @override
  List<Object?> get props => [];
}

class WrongSMS extends LoginState {
  @override
  List<Object?> get props => [];
}
