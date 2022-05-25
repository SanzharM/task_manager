import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:easy_localization/easy_localization.dart';

part 'voice_authentication_event.dart';
part 'voice_authentication_state.dart';

class VoiceAuthenticationBloc extends Bloc<VoiceauthenticationEvent, VoiceAuthenticationState> {
  authByVoice(File file) => add(AuthenticateByVoice(file));
  registerVoice(File file) => add(RegisterVoice(file));
  hasRecordedVoice() => add(CheckRecordedVoice());
  deleteVoice() => add(DeleteVoice());
  getTexts() => add(GetTexts());

  VoiceAuthenticationBloc() : super(VoiceAuthenticationInitial()) {
    on<AuthenticateByVoice>((event, emit) async {
      emit(VoiceAuthenticationInitial());
      emit(AuthenticationProcessing());
      final response = await ApiClient.authenticateByVoice(event.file);
      if (response.successMessage != null) {
        return emit(VoiceAuthenticationSucceeded(response.successMessage!));
      } else {
        return emit(ErrorState(response.error ?? 'Error at voice auth'));
      }
    });

    on<RegisterVoice>((event, emit) async {
      emit(VoiceAuthenticationInitial());
      emit(Loading());
      final response = await ApiClient.registerVoice(event.file);

      if (response.successMessage != null) {
        return emit(VoiceAuthenticationRegistered(response.successMessage!));
      } else {
        return emit(ErrorState(response.error ?? 'Error at voice auth'));
      }
    });

    on<CheckRecordedVoice>((event, emit) async {
      emit(VoiceAuthenticationInitial());
      emit(Loading());
      final response = await ApiClient.checkRecordedVoice();

      if (response.success == true) {
        return emit(RecordedVoiceChecked(true));
      } else if (response.success == false && response.error == null) {
        return emit(RecordedVoiceChecked(false));
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<DeleteVoice>((event, emit) async {
      emit(VoiceAuthenticationInitial());
      emit(Loading());
      final response = await ApiClient.deleteVoice();

      if (response.success == true) {
        return emit(VoiceDeleted());
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<GetTexts>((event, emit) async {
      emit(VoiceAuthenticationInitial());
      emit(Loading());

      final response = await ApiClient.getTextsForVoiceAuth();

      if (response.text?.isNotEmpty ?? false) {
        return emit(VoiceAuthTextLoaded(response.text!));
      } else {
        return emit(ErrorState(response.error ?? 'Error'.tr()));
      }
    });
  }
}
