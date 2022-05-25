import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/app_icons.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatelessWidget {
  final User user;
  UserCard({required this.user});

  String whatsappUrl(String? phone) => 'https://api.whatsapp.com/send?phone=${Utils.numbersOnly(phone)}';
  String telegramUrl(String? phone) => 'https://t.me/${Utils.numbersOnly(phone)}';

  Future<void> _onPhoneCall(String? inputPhone) async {
    final String? phone = Utils.numbersOnly(inputPhone);
    if (phone == null || phone.length != 11) return;

    await canLaunch('tel:$phone') ? await launch('tel:$phone') : _copyToClipBoard(phone);
  }

  Future<void> _copyToClipBoard(text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      print('During copying to Clipboard, Error Occured: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width - 32.0,
      constraints: const BoxConstraints(minHeight: 56.0),
      decoration: BoxDecoration(
        borderRadius: AppConstraints.borderRadius,
        color: Application.isDarkMode(context) ? AppColors.grey : AppColors.defaultGrey,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: user.imageUrl != null
                ? Image.network(user.imageUrl!, height: 48, width: 48)
                : const Icon(CupertinoIcons.person_fill, size: 48),
          ),
          const EmptyBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const EmptyBox(height: 4),
                if (user.position != null && user.position!.isNotEmpty) Text(user.position!, style: const TextStyle(fontSize: 14)),
                const EmptyBox(height: 8),
                CupertinoButton(
                  padding: const EdgeInsets.all(4.0),
                  onPressed: () => _onPhoneCall(user.phone),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.phone_fill_arrow_up_right, size: 28),
                      const EmptyBox(width: 8),
                      Expanded(child: Text(Utils.formattedPhone(user.phone))),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(4.0),
                  onPressed: () async => await launch(whatsappUrl(user.phone)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AppIcons.whatsApp, height: 32),
                      const EmptyBox(width: 8),
                      Expanded(child: Text('Чат WhatsApp', maxLines: 1)),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(4.0),
                  onPressed: () async => await launch(telegramUrl(user.phone)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AppIcons.telegram, height: 32),
                      const EmptyBox(width: 8),
                      Expanded(child: Text('Чат Telegram', maxLines: 1)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserRow extends StatelessWidget {
  const UserRow({Key? key, required this.user, this.size, this.namePlaceholder}) : super(key: key);

  final User? user;
  final double? size;
  final String? namePlaceholder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: user?.tryGetImage() ?? const Icon(CupertinoIcons.person_badge_minus_fill),
          height: size ?? 24.0,
          width: size ?? 24.0,
        ),
        const EmptyBox(width: 8.0),
        Flexible(
          child: Text(
            user?.name ?? namePlaceholder ?? 'No user',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
