import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/date_picker.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:task_manager/core/widgets/value_picker.dart';
import 'package:task_manager/pages/task_page/bloc/task_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({
    Key? key,
    required this.task,
    this.isEditing = false,
    required this.board,
    required this.onBack,
    this.users = const <User>[],
  }) : super(key: key);

  final Task? task;
  final Board board;
  final bool isEditing;
  final void Function() onBack;
  final List<User> users;

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _bloc = TaskBloc();
  late Task _task;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task ?? Task(boardId: widget.board.pk, deadline: DateTime.now());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).hasFocus ? () => FocusScope.of(context).unfocus() : null,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _task.title ?? (widget.isEditing ? 'edit'.tr() : 'create'.tr()),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          leading: AppBackButton(),
        ),
        body: BlocListener(
          bloc: _bloc,
          listener: (context, state) {
            print('state is $state');
            isLoading = state is Loading;

            if (state is TaskCreated) {
              widget.onBack();
              Navigator.of(context).pop();
            }

            if (state is ErrorState) {}

            setState(() {});
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
                  AppTextField(
                    label: 'title'.tr(),
                    text: _task.title,
                    maxLines: 2,
                    onTap: () => setState(() {}),
                    onChanged: (value) => _task = _task.copyWith(title: value),
                    needValidator: true,
                  ),
                  const EmptyBox(height: 12.0),
                  AppTextField(
                    label: 'description'.tr(),
                    text: _task.description,
                    maxLines: 3,
                    onTap: () => setState(() {}),
                    onChanged: (value) => _task = _task.copyWith(description: value),
                    needValidator: true,
                  ),
                  const EmptyBox(height: 12.0),
                  AppTextField(
                    label: 'created_by'.tr(),
                    text: _task.creator?.name ?? _task.creator?.phone ?? _task.creator?.toString(),
                    readonly: true,
                    needValidator: true,
                    onTap: () {
                      setState(() {});
                      ValuePicker(
                        context: context,
                        title: 'created_by'.tr(),
                        values: widget.users.map((e) => e.name ?? e.phone!).toList(),
                        onSelect: (value) {
                          _task = _task.copyWith(
                            creator: widget.users.firstWhere((e) => e.name == value || e.phone == value),
                          );
                          setState(() {});
                        },
                      ).show();
                    },
                  ),
                  const EmptyBox(height: 12.0),
                  AppTextField(
                    label: 'performer'.tr(),
                    text: _task.performer?.name ?? _task.performer?.phone ?? _task.performer?.toString(),
                    readonly: true,
                    needValidator: true,
                    onTap: () {
                      setState(() {});
                      ValuePicker(
                        context: context,
                        title: 'choose_performer'.tr(),
                        values: widget.users.map((e) => e.name ?? e.phone!).toList(),
                        onSelect: (value) {
                          _task = _task.copyWith(
                            performer: widget.users.firstWhere((e) => e.name == value || e.phone == value),
                          );
                          setState(() {});
                        },
                      ).show();
                    },
                    onChanged: (value) => null,
                  ),
                  const EmptyBox(height: 12.0),
                  AppTextField(
                    label: 'deadline'.tr(),
                    text: Utils.toDateString(_task.deadline, includeMonthTitles: true),
                    readonly: true,
                    needValidator: true,
                    onTap: () {
                      setState(() {});
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => DatePicker(
                          onPicked: (date) => _task = _task.copyWith(deadline: date),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: AppButton(
            title: 'create'.tr(),
            isLoading: isLoading,
            color: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
            onTap: () {
              final isValid = _formKey.currentState?.validate() ?? true;
              if (!isValid || isLoading) return;
              return _bloc.validateTask(_task);
            },
          ),
        ),
      ),
    );
  }
}
