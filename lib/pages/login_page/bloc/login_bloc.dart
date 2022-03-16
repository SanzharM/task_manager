import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:easy_localization/easy_localization.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  getAuth(String phone) => add(GetAuth());
  verifySMS(String phone, String? code) => add(VerifySMSCode(phone: phone, code: code));

  LoginBloc() : super(LoginInitial()) {
    on<GetAuth>(
      (event, emit) async {
        if (event.phone == null || event.phone == null || event.phone!.length != 11) {
          emit(ErrorState('invalid_phone_number'.tr()));
          return emit(EmptyState());
        }

        emit(Loading());
        final response = await ApiClient.getAuth(event.phone!);

        if (response.success)
          emit(PhoneAuthSuccess(event.phone!));
        else
          emit(ErrorState(response.error ?? 'login_error'.tr()));
      },
    );
    on<VerifySMSCode>((event, emit) async {
      if ((event.code?.length ?? 0) < 4) {
        emit(ErrorState('invalid_code'.tr()));
        return emit(EmptyState());
      }

      emit(Loading());
      final response = await ApiClient.verifySmsCode(event.phone, event.code!);

      if (response.token != null)
        emit(AuthVerifySuccess(response.token!));
      else
        emit(ErrorState(response.error ?? 'login_error'.tr()));
    });
  }
}
