import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/models/session.dart';

part 'qr_event.dart';
part 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  getSessions() => add(QrGetSession());
  createSession(LocationData data) => add(QrCreateSession(data));

  QrBloc() : super(QrInitial()) {
    on<QrGetSession>((event, emit) async {
      emit(QrInitial());
      emit(QrLoading());

      final response = await ApiClient.getSessions();

      if (response.sessions != null) {
        return emit(QrSessionsLoaded(response.sessions!));
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<QrCreateSession>((event, emit) async {
      emit(QrInitial());
      emit(QrLoading());
      final response = await ApiClient.setSession(event.data);

      if (response.success == true) {
        return emit(QrSessionCreated());
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });
  }
}
