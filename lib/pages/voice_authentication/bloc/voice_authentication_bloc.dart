import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/api/api_client.dart';

part 'voice_authentication_event.dart';
part 'voice_authentication_state.dart';

class VoiceAuthenticationBloc extends Bloc<VoiceauthenticationEvent, VoiceAuthenticationState> {
  authByVoice(File file) => add(AuthenticateByVoice(file));

  VoiceAuthenticationBloc() : super(VoiceAuthenticationInitial()) {
    on<VoiceauthenticationEvent>((event, emit) async {
      if (event is AuthenticateByVoice) {
        emit(VoiceAuthenticationInitial());
        emit(AuthenticationProcessing());
        final response = await ApiClient.authenticateByVoice(event.file);
        if (response.successMessage != null) {
          return emit(VoiceAuthenticationSucceeded(response.successMessage!));
        } else {
          return emit(ErrorState(response.error ?? 'Error at voice auth'));
        }
      }
    });
  }
}
