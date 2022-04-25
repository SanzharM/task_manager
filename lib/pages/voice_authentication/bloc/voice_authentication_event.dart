part of 'voice_authentication_bloc.dart';

abstract class VoiceauthenticationEvent extends Equatable {
  const VoiceauthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticateByVoice extends VoiceauthenticationEvent {
  final File file;
  AuthenticateByVoice(this.file);
}
