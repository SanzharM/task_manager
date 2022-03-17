import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:easy_localization/easy_localization.dart';

class AddProfilePage extends StatefulWidget {
  final User? user;
  final bool isEditing;
  final Function? onNext;

  const AddProfilePage({this.user, this.isEditing = false, this.onNext});

  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  late User _user;
  late bool _isEditing;

  bool didChanges = false;

  Future<void> _chooseImageFromLibrary() async {}

  @override
  void initState() {
    if (widget.user != null) _user = widget.user!;
    _isEditing = widget.isEditing;
    super.initState();
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
                return AlertController.showNativeDialog(
                  context: context,
                  title: 'Вы точно хотите вернуться?',
                  message: 'У вас остались несохраненные изменения',
                  onYes: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  onNo: () => Navigator.of(context).pop(),
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                        child: _user.imageUrl != null ? Image.network(_user.imageUrl!) : const Icon(CupertinoIcons.camera_fill),
                        onPressed: () => _chooseImageFromLibrary(),
                      ),
                    ),
                  ),
                ),
                const EmptyBox(height: 24),
                AppTextField(
                  label: 'your_name'.tr(),
                  text: _user.name,
                  onTap: () => setState(() {}),
                  onChanged: (value) {
                    _user = _user.copyWith(name: value);
                    didChanges = true;
                    setState(() {});
                  },
                ),
                const EmptyBox(height: 12),
                AppTextField(
                  label: 'your_surname'.tr(),
                  text: _user.surname,
                  onTap: () => setState(() {}),
                  onChanged: (value) {
                    _user = _user.copyWith(surname: value);
                    didChanges = true;
                    setState(() {});
                  },
                ),
                const EmptyBox(height: 12),
                AppTextField(
                  label: 'email'.tr(),
                  text: _user.email,
                  keyboardType: TextInputType.emailAddress,
                  onTap: () => setState(() {}),
                  onChanged: (value) {
                    _user = _user.copyWith(email: value);
                    didChanges = true;
                    setState(() {});
                  },
                ),
                const EmptyBox(height: 12),
                AppTextField(
                  label: 'phone_number'.tr(),
                  text: _user.phone,
                  keyboardType: TextInputType.number,
                  onTap: () => setState(() {}),
                  onChanged: (value) {
                    _user = _user.copyWith(phone: value);
                    didChanges = true;
                    setState(() {});
                  },
                ),
                const EmptyBox(height: 12),
                AppTextField(
                  label: 'job_position'.tr(),
                  text: _user.position,
                  onTap: () => setState(() {}),
                  onChanged: (value) {
                    _user = _user.copyWith(position: value);
                    didChanges = true;
                    setState(() {});
                  },
                ),
                const EmptyBox(height: 16),
                AppButton(
                  title: _isEditing ? 'save'.tr() : 'add'.tr(),
                  onTap: () => null,
                ),
                const EmptyBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
