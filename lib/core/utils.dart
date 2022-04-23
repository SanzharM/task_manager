import 'package:task_manager/core/api/api_endpoints.dart';
import 'package:task_manager/core/models/task.dart';

class Utils {
  static String phoneMask = '+7 (###) ### ####';
  static String dateToString(DateTime? datetime) {
    if (datetime == null) return '';
    return '${datetime.day}-${datetime.month}-${datetime.year} ${datetime.hour}:${datetime.minute}:${datetime.second}';
  }

  static String getMonth(int month) {
    if (month == 0) month = 12;
    if (month == 13) month = 1;
    switch (month) {
      case 1:
        return 'Январь';
      case 2:
        return 'Февраль';
      case 3:
        return 'Март';
      case 4:
        return 'Апрель';
      case 5:
        return 'Май';
      case 6:
        return 'Июнь';
      case 7:
        return 'Июль';
      case 8:
        return 'Август';
      case 9:
        return 'Сентябрь';
      case 10:
        return 'Октябрь';
      case 11:
        return 'Ноябрь';
      case 12:
        return 'Декабрь';
      default:
        return '';
    }
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

  static String getRequestMethod(RequestMethod method) {
    switch (method) {
      case RequestMethod.get:
        return 'GET';
      case RequestMethod.post:
        return 'POST';
      case RequestMethod.put:
        return 'PUT';
      case RequestMethod.delete:
        return 'DELETE';
    }
  }
}
