part of 'voice_authentication_bloc.dart';

abstract class VoiceAuthenticationState extends Equatable {
  const VoiceAuthenticationState();

  @override
  List<Object> get props => [];
}

class VoiceAuthenticationInitial extends VoiceAuthenticationState {}

class VoiceAuthenticationSucceeded extends VoiceAuthenticationState {
  final String message;
  VoiceAuthenticationSucceeded(this.message);
}

class VoiceAuthenticationRegistered extends VoiceAuthenticationState {
  final String message;
  VoiceAuthenticationRegistered(this.message);
}

class ErrorState extends VoiceAuthenticationState {
  final String error;
  ErrorState(this.error);
}

class AuthenticationProcessing extends VoiceAuthenticationState {}

class Loading extends VoiceAuthenticationState {}

class RecordedVoiceChecked extends VoiceAuthenticationState {
  final bool hasVoice;
  RecordedVoiceChecked(this.hasVoice);

  @override
  List<Object> get props => [hasVoice];
}

class VoiceDeleted extends VoiceAuthenticationState {
  @override
  List<Object> get props => [];
}

class VoiceAuthTextLoaded extends VoiceAuthenticationState {
  final String text;
  VoiceAuthTextLoaded(this.text);

  @override
  List<Object> get props => [text];
}
