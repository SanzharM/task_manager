import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/application.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  getAuth(String phone, String companyCode) => add(GetAuth(phone: phone, companyCode: companyCode));
  verifySMS(String phone, String? code, String companyCode) => add(VerifySMSCode(phone: phone, code: code, companyCode: companyCode));
  verifyCodeCompany(String code) => add(VerifyCompany(code));

  LoginBloc() : super(LoginInitial()) {
    on<GetAuth>((event, emit) async {
      emit(LoginInitial());
      if (event.phone == null || event.phone!.length != 11) {
        return emit(ErrorState('invalid_phone_number'.tr()));
      }
      if (event.companyCode == null || event.companyCode!.length != 6) {
        return emit(ErrorState('invalid_code'.tr()));
      }

      emit(Loading());
      final response = await ApiClient.getAuth(event.phone!, event.companyCode!);

      if (response.success)
        emit(PhoneAuthSuccess(event.phone!));
      else
        emit(ErrorState(response.error ?? 'login_error'.tr()));
    });

    on<VerifySMSCode>((event, emit) async {
      emit(LoginInitial());
      if ((event.code?.length ?? 0) < 4) {
        return emit(ErrorState('invalid_code'.tr()));
      }

      emit(Loading());
      final response = await ApiClient.verifySmsCode(event.phone, event.code!, event.companyCode);

      if (response.token != null) {
        await Application.setToken(response.token);
        emit(AuthVerifySuccess(response.token!));
      } else if (response.error == 'wrong_sms') {
        emit(WrongSMS());
      } else {
        emit(ErrorState(response.error ?? 'login_error'.tr()));
      }
    });

    on<VerifyCompany>((event, emit) async {
      emit(LoginInitial());
      if (event.code.length != 6) {
        return emit(ErrorState('invalid_code'.tr()));
      }

      emit(Loading());

      final response = await ApiClient.verifyCompanyCode(event.code);
      if (response.success == true)
        return emit(CodeCompanyVerified(event.code));
      else
        return emit(ErrorState(response.error ?? 'invalid_company_code'.tr()));
    });
  }
}
