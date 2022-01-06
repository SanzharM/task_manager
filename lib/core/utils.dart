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
}
