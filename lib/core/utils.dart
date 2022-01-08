import 'package:task_manager/core/models/task.dart';

class Utils {
  static String dateToString(DateTime? datetime) {
    if (datetime == null) return '';
    return '${datetime.day}-${datetime.month}-${datetime.year} ${datetime.hour}:${datetime.minute}:${datetime.second}';
  }

  static String? taskStatusToString(TaskStatus? status) {
    if (status == null) return null;
    switch (status) {
      case TaskStatus.to_do:
        return 'К выполнению';
      case TaskStatus.in_work:
        return 'В работе';
      case TaskStatus.test:
        return 'На проверке';
      case TaskStatus.done:
        return 'Выполнен';
      case TaskStatus.undetermined:
        return 'Неизвестен';
      default:
        return '';
    }
  }

  static String formattedPhone(String? phone) {
    if (phone == null || phone.length < 11) return '';
    return '+7 (${phone.substring(1, 4)})'
        ' ${phone.substring(4, 7)}'
        ' ${phone.substring(7, 9)}'
        '-${phone.substring(9, phone.length)}';
  }

  static String? numbersOnly(String? value) {
    if (value == null) return null;
    String temp = value.replaceAll(RegExp(r'[^0-9]'), '');
    return temp;
  }
}
