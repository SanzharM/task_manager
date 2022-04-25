part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class GetAuth extends LoginEvent {
  final String? phone;
  final String? companyCode;
  GetAuth({required this.phone, required this.companyCode});

  @override
  List<Object?> get props => [];
}

class VerifySMSCode extends LoginEvent {
  final String phone;
  final String? code;
  final String companyCode;
  VerifySMSCode({required this.phone, required this.code, required this.companyCode});

  @override
  List<Object?> get props => [];
}

class VerifyCompany extends LoginEvent {
  final String code;
  VerifyCompany(this.code);

  @override
  List<Object?> get props => [];
}
