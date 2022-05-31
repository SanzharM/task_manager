import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/date_picker.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/pages/profile_page/bloc/profile_bloc.dart';

class AddProfilePage extends StatefulWidget {
  final User? user;
  final bool isEditing;
  final void Function()? onNext;

  const AddProfilePage({this.user, this.isEditing = false, this.onNext});

  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  final _bloc = ProfileBloc();
  final _formKey = GlobalKey<FormState>();

  late User _user;
  late bool _isEditing;

  bool didChanges = false;
  bool isLoading = false;

  Future<void> _chooseImageFromSource(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    didChanges = true;
    setState(() => _user = _user.copyWith(imageUrl: image.path));
  }

  @override
  void initState() {
    if (widget.user != null) _user = widget.user!;
    _isEditing = widget.isEditing;
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).hasFocus ? FocusScope.of(context).unfocus() : null,
      child: Scaffold(
        appBar: AppBar(
          title: _isEditing ? Text('editing_profile'.tr()) : Text('create_profile'.tr()),
          centerTitle: true,
          leading: AppBackButton(
            onBack: () {
              if (didChanges) {
                AlertController.showNativeDialog(
                  context: context,
                  title: 'do_you_want_to_go_back'.tr(),
                  message: 'you_have_unsaved_changes'.tr(),
                  onYes: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  onNo: () => Navigator.of(context).pop(),
                );
                return;
              }
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocListener(
          bloc: _bloc,
          listener: (context, state) {
            isLoading = state is ProfileLoading;

            if (state is ErrorState) {
              AlertController.showResultDialog(context: context, message: state.error, isSuccess: null);
            }

            if (state is ProfileEdited) {
              if (widget.onNext != null) widget.onNext!();
              Navigator.of(context).pop();
            }
          },
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const EmptyBox(height: 8),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                          maxWidth: MediaQuery.of(context).size.width * 0.3,
                          minHeight: MediaQuery.of(context).size.height * 0.1,
                          minWidth: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: ClipOval(
                          child: CupertinoButton(
                            child: _user.tryGetImage(canAddImage: true),
                            onPressed: () {
                              if (_user.imageUrl?.isEmpty ?? true) {
                                _chooseImageFromSource(ImageSource.gallery);
                                return;
                              }
                              return _showModal();
                            },
                          ),
                        ),
                      ),
                    ),
                    const EmptyBox(height: 24),
                    AppTextField(
                      label: 'phone_number'.tr(),
                      text: _user.phone,
                      keyboardType: TextInputType.number,
                      readonly: true,
                      onTap: () => setState(() {}),
                    ),
                    const EmptyBox(height: 12),
                    AppTextField(
                      label: 'your_name'.tr(),
                      text: _user.name,
                      onTap: () => setState(() {}),
                      maxLines: 2,
                      needValidator: true,
                      onChanged: (value) {
                        _user = _user.copyWith(name: value);
                        didChanges = true;
                        setState(() {});
                      },
                    ),
                    const EmptyBox(height: 12),
                    AppTextField(
                      label: 'job_position'.tr(),
                      text: _user.position,
                      onTap: () => setState(() {}),
                      maxLines: 2,
                      needValidator: true,
                      onChanged: (value) {
                        _user = _user.copyWith(position: value);
                        didChanges = true;
                        setState(() {});
                      },
                    ),
                    const EmptyBox(height: 12),
                    AppTextField(
                      label: 'birthday'.tr(),
                      text: Utils.dateToString(_user.birthday),
                      readonly: true,
                      onTap: () => DatePicker(
                        initialDate: _user.birthday ?? DateTime.now().subtract(Duration(days: 365 * 15)),
                        minYear: DateTime.now().subtract(Duration(days: 365 * 130)).year,
                        maxYear: DateTime.now().subtract(Duration(days: 365 * 15)).year,
                        minDate: DateTime.now().subtract(Duration(days: 365 * 130)),
                        maxDate: DateTime.now().subtract(Duration(days: 365 * 15)),
                        onPicked: (date) {
                          _user = _user.copyWith(birthday: date);
                          didChanges = true;
                          setState(() {});
                        },
                      ).show(context),
                      onChanged: (value) {
                        _user = _user.copyWith(totalMoney: double.tryParse(value));
                        didChanges = true;
                        setState(() {});
                      },
                    ),
                    const EmptyBox(height: 12),
                    AppTextField(
                      label: 'total_money'.tr(),
                      text: _user.totalMoney?.toString(),
                      keyboardType: TextInputType.number,
                      onTap: () => setState(() {}),
                      onChanged: (value) {
                        if (value.endsWith('.')) value = value.replaceAll('.', '');
                        final money = double.tryParse(value);
                        _user = _user.copyWith(totalMoney: money);
                        didChanges = true;
                      },
                    ),
                    const EmptyBox(height: 16),
                    AppButton(
                      color: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
                      title: _isEditing ? 'save'.tr() : 'add'.tr(),
                      onTap: () {
                        if (!didChanges) {
                          Navigator.of(context).pop();
                          return;
                        }
                        if (_formKey.currentState?.validate() ?? false) _bloc.editProfile(_user);
                      },
                    ),
                    const EmptyBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showModal() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: AppConstraints.borderRadiusTLR),
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            OneLineCell(
              title: 'choose_image_from_camera'.tr(),
              icon: const Icon(CupertinoIcons.photo_camera_solid),
              onTap: () async {
                await _chooseImageFromSource(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            const EmptyBox(height: 16.0),
            OneLineCell(
              title: 'choose_image_from_library'.tr(),
              icon: const Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
              onTap: () async {
                await _chooseImageFromSource(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            const EmptyBox(height: 16.0),
            OneLineCell(
              title: 'delete'.tr(),
              icon: const Icon(CupertinoIcons.delete, size: 22, color: AppColors.switchOffLight),
              onTap: () {
                _user.clearImage();
                didChanges = true;
                setState(() {});
              },
            ),
            const EmptyBox(height: 24.0),
            OneLineCell(
              title: 'done'.tr(),
              centerTitle: true,
              onTap: () => Navigator.of(context).pop(),
              needIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}
