import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomInput extends StatefulWidget {
  final String text;
  final void Function(String) onChanged;
  final void Function() onTap;
  final void Function() onSend;
  final Color? backgroundColor;
  final bool sendButtonConsistant;

  const BottomInput({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.onTap,
    required this.onSend,
    this.backgroundColor,
    this.sendButtonConsistant = false,
  }) : super(key: key);

  @override
  State<BottomInput> createState() => BottomInputState();
}

class BottomInputState extends State<BottomInput> with TickerProviderStateMixin {
  String _text = '';
  TextEditingController _controller = TextEditingController();

  static const _duration = Duration(milliseconds: 100);

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool showSendButton = false;
  bool animateInputWidth = false;

  bool isSending = false;

  void _sendButtonAnimator() {
    if (_controller.text.isEmpty) _animationController.reverse();
    if (_controller.text.isNotEmpty) _animationController.forward();
    setState(() {});
  }

  void clearText() {
    _controller.clear();
    setState(() => _text = '');
  }

  void setisSending(bool value) => setState(() => isSending = value);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      value: widget.sendButtonConsistant ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut);

    _controller = TextEditingController(text: _text);
    if (!widget.sendButtonConsistant) _controller.addListener(_sendButtonAnimator);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: widget.backgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              onChanged: (value) {
                _text = value;
                widget.onChanged(value);
              },
              onTap: () => setState(() {}),
              showCursor: true,
              cursorColor: Colors.black,
              textAlignVertical: TextAlignVertical.top,
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              scrollPhysics: const BouncingScrollPhysics(),
              scrollPadding: const EdgeInsets.symmetric(vertical: 4.0),
              style: const TextStyle(fontSize: 15, decoration: TextDecoration.none),
              decoration: InputDecoration(
                hintText: 'add_comment'.tr(),
                fillColor: Colors.white,
                filled: true,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            width: _controller.text.isEmpty ? 8 : 2,
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
              ),
              child: AnimatedSwitcher(
                duration: _duration,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: IconButton(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(4.0),
                  color: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
                  icon: isSending
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)
                      : const Icon(Icons.send_rounded, color: AppColors.white, size: 16.0),
                  onPressed: () {
                    if (_text.isEmpty && !widget.sendButtonConsistant) return;
                    widget.onSend();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
