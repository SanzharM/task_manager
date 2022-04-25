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

class ErrorState extends VoiceAuthenticationState {
  final String error;
  ErrorState(this.error);
}

class AuthenticationProcessing extends VoiceAuthenticationState {}
