part of 'qr_bloc.dart';

abstract class QrState extends Equatable {
  const QrState();

  @override
  List<Object> get props => [];
}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class ErrorState extends QrState {
  final String error;
  ErrorState(this.error);

  @override
  List<Object> get props => [];
}

class QrSessionsLoaded extends QrState {
  final List<Session> sessions;
  QrSessionsLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class QrSessionCreated extends QrState {}
