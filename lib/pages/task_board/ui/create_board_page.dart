import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateBoardPage extends StatefulWidget {
  const CreateBoardPage({Key? key, required this.onCreate}) : super(key: key);

  final void Function(String groupName, String? description) onCreate;

  @override
  State<CreateBoardPage> createState() => CreateBoardPageState();
}

class CreateBoardPageState extends State<CreateBoardPage> {
  String groupName = '';
  String? description = '';

  bool isLoading = false;

  void setIsLoading(bool value) => setState(() => isLoading = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).hasFocus ? () => FocusScope.of(context).unfocus() : null,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.xmark),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const EmptyBox(height: 32.0),
              AppTextField(
                label: 'group_name'.tr(),
                text: groupName,
                onTap: () => setState(() {}),
                onChanged: (value) => groupName = value,
                needValidator: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'field_cannot_be_empty'.tr();
                  return null;
                },
              ),
              const EmptyBox(height: 16.0),
              AppTextField(
                label: 'description'.tr(),
                text: description,
                onTap: () => setState(() {}),
                onChanged: (value) => description = value,
              ),
              const EmptyBox(height: 24.0),
              AppButton(
                title: 'submit'.tr(),
                isLoading: isLoading,
                onTap: () {
                  if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
                  widget.onCreate(groupName, description);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
