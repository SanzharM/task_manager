import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/models/comment.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/bottom_input.dart';
import 'package:task_manager/core/widgets/comment_card.dart';
import 'package:task_manager/core/widgets/custom_shimmer.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/task_page/bloc/task_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key, required this.taskId}) : super(key: key);

  final int taskId;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _inputKey = GlobalKey<BottomInputState>();
  final _bloc = TaskBloc();

  List<Comment> comments = [];
  bool isLoading = false;

  String _text = '';

  Future<void> _onRefresh() async {
    if (isLoading) return;
    _bloc.getComments(widget.taskId);
    await Future.delayed(const Duration(milliseconds: 250));
  }

  @override
  void initState() {
    _bloc.getComments(widget.taskId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).hasFocus ? () => FocusScope.of(context).unfocus() : null,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: AppCloseButton(),
          automaticallyImplyLeading: false,
          title: Text('comments'.tr()),
        ),
        body: BlocListener(
          bloc: _bloc,
          listener: (context, state) {
            isLoading = state is CommentsLoading;

            if (state is ErrorState) {
              AlertController.showSnackbar(context: context, message: state.error);
            }

            if (state is CommentsLoaded) {
              comments = state.comments.reversed.toList();
            }

            if (state is CommentCreated) {
              _inputKey.currentState?.clearText();
              _inputKey.currentState?.setisSending(false);
              comments = state.comments.reversed.toList();
            }
            setState(() {});
          },
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: CustomShimmer(
                    enabled: isLoading,
                    child: isLoading && comments.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                            padding: const EdgeInsets.all(16.0),
                            itemCount: comments.length,
                            separatorBuilder: (context, index) => const EmptyBox(height: 12.0),
                            itemBuilder: (context, index) => CommentCard(comment: comments[index]),
                          ),
                  ),
                ),
              ),
              BottomInput(
                key: _inputKey,
                onChanged: (value) => _text = value,
                text: _text,
                onSend: () {
                  if (isLoading) return;
                  _inputKey.currentState?.setisSending(true);
                  return _bloc.createComment(_text, widget.taskId);
                },
                onTap: () => setState(() {}),
                sendButtonConsistant: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
