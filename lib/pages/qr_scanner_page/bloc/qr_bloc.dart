import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:easy_localization/easy_localization.dart';

part 'qr_event.dart';
part 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  getSessions() => add(QrGetSession());
  createSession() => add(QrCreateSession());

  QrBloc() : super(QrInitial()) {
    on<QrGetSession>((event, emit) async {
      emit(QrInitial());
      emit(QrLoading());

      final response = await ApiClient.getSessions();

      if (response != null) {
        return emit(QrSessionsLoaded());
      } else {
        return emit(ErrorState(response ?? 'error'.tr()));
      }
    });

    on<QrCreateSession>((event, emit) async {
      // emit(QrInitial());
      // emit(QrLoading());
    });
  }
}
