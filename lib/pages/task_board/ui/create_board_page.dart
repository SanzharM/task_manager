import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/pages/profile_page/bloc/profile_bloc.dart';

import '../../../core/app_colors.dart';
import '../../../core/application.dart';
import '../../../core/models/user.dart';

class CreateBoardPage extends StatefulWidget {
  const CreateBoardPage({Key? key, required this.onCreate}) : super(key: key);

  final void Function(String groupName, String? description, List<User> users) onCreate;

  @override
  State<CreateBoardPage> createState() => CreateBoardPageState();
}

class CreateBoardPageState extends State<CreateBoardPage> {
  String groupName = '';
  String? description = '';
  final _boardBloc = ProfileBloc();
  bool isLoading = false;
  List<User> _collegues = [];
  late String? phone;

  @override
  void initState() {
    super.initState();
    _boardBloc.getCollegues();
    initPhone();
  }

  void initPhone() async {
    phone = await Application.getPhone();
  }

  void setIsLoading(bool value) => setState(() => isLoading = value);

  void openUsersDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 26),
              title: Center(child: Text("Коллеги")),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      BlocBuilder(
                        bloc: _boardBloc,
                        builder: (context, state) {
                          if (state is ColleguesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is ColleguesLoaded) {
                            state.collegues.removeWhere(
                                (element) => element.phone == phone);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                ...state.collegues.map((e) {
                                  return ListTile(
                                    title: Text(e.name ?? e.phone!),
                                    trailing: Checkbox(
                                      onChanged: (bool? value) {
                                        if (value == true) {
                                          _collegues.add(e);
                                        } else {
                                          _collegues.remove(e);
                                        }
                                        setState(() {});
                                      },
                                      value: _collegues
                                          .any((element) => e.id == element.id),
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 16,
                                ),
                                AppButton(
                                    title: 'Выбрать',
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    }),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).hasFocus
          ? () => FocusScope.of(context).unfocus()
          : null,
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
                  if (value == null || value.isEmpty)
                    return 'field_cannot_be_empty'.tr();
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
              InkWell(
                onTap: openUsersDialog,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Application.isDarkMode(context)
                          ? AppColors.snow.withOpacity(0.3)
                          : AppColors.darkGrey.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  height: 54,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(_collegues.isNotEmpty ? _collegues.join(',') : 'Участники'),
                  ),
                ),
              ),
              const EmptyBox(height: 24.0),
              AppButton(
                title: 'submit'.tr(),
                isLoading: isLoading,
                onTap: () {
                  if (FocusScope.of(context).hasFocus)
                    FocusScope.of(context).unfocus();
                  widget.onCreate(groupName, description, _collegues);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
