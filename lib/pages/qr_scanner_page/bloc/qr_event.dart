part of 'qr_bloc.dart';

abstract class QrEvent extends Equatable {
  const QrEvent();

  @override
  List<Object> get props => [];
}

class QrGetSession extends QrEvent {
  @override
  List<Object> get props => [];
}

class QrCreateSession extends QrEvent {
  @override
  List<Object> get props => [];
}

class QrValidateResult extends QrEvent {
  final String result;
  QrValidateResult(this.result);

  @override
  List<Object> get props => [result];
}
