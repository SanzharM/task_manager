part of 'voice_authentication_bloc.dart';

abstract class VoiceauthenticationEvent extends Equatable {
  const VoiceauthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticateByVoice extends VoiceauthenticationEvent {
  final File file;
  AuthenticateByVoice(this.file);

  @override
  List<Object> get props => [file];
}

class CheckRecordedVoice extends VoiceauthenticationEvent {
  final String? phone;
  CheckRecordedVoice(this.phone);

  @override
  List<Object> get props => [];
}

class RegisterVoice extends VoiceauthenticationEvent {
  final File file;
  RegisterVoice(this.file);

  @override
  List<Object> get props => [file];
}

class DeleteVoice extends VoiceauthenticationEvent {}

class GetTexts extends VoiceauthenticationEvent {}
