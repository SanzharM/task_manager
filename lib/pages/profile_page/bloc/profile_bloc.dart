import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:easy_localization/easy_localization.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  getProfile() => add(GetProfile());
  editProfile(User user) => add(EditProfile(user));
  getCollegues() => add(GetCollegues());

  ProfileBloc() : super(ProfileInitial()) {
    on<GetProfile>((event, emit) async {
      emit(ProfileInitial());
      emit(ProfileLoading());

      final response = await ApiClient.getProfileData();

      if (response.user != null) {
        return emit(ProfileLoaded(response.user!));
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<EditProfile>((event, emit) async {
      emit(ProfileInitial());
      emit(ProfileLoading());

      final response = await ApiClient.editProfile(event.user);

      if (response.success == true) {
        return emit(ProfileEdited(event.user));
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<GetCollegues>((event, emit) async {
      emit(ProfileInitial());
      emit(ColleguesLoading());
      final response = await ApiClient.getCompanyUsers();

      if (response.users != null) {
        return emit(ColleguesLoaded(response.users!));
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });
  }
}
