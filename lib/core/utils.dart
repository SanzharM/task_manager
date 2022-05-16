import 'package:task_manager/core/api/api_endpoints.dart';
import 'package:task_manager/core/constants/error_types.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/pages/task_board/ui/task_board_builder.dart';

class Utils {
  static String phoneMask = '+7 (###) ### ####';
  static String dateToString(DateTime? datetime) {
    if (datetime == null) return '';
    return DateFormat('yyyy-MM-dd').format(datetime);
  }

  static String toDateString(DateTime? date, {bool includeMonthTitles = false}) {
    if (date == null) return '';
    if (includeMonthTitles) {
      return '${getMonth(date.month)} ${date.day}, ${date.year}';
    }
    return '${date.day}.${date.month}.${date.year}';
  }

  static String getMonth(int month) {
    switch (month) {
      case 1:
        return 'january'.tr();
      case 2:
        return 'february'.tr();
      case 3:
        return 'march'.tr();
      case 4:
        return 'april'.tr();
      case 5:
        return 'may'.tr();
      case 6:
        return 'june'.tr();
      case 7:
        return 'july'.tr();
      case 8:
        return 'august'.tr();
      case 9:
        return 'september'.tr();
      case 10:
        return 'october'.tr();
      case 11:
        return 'november'.tr();
      case 12:
        return 'december'.tr();
      default:
        return '';
    }
  }

  static String taskStatusToString(TaskStatus? status) {
    switch (status) {
      case TaskStatus.todo:
        return 'status_todo'.tr();
      case TaskStatus.in_process:
        return 'status_in_process'.tr();
      case TaskStatus.done:
        return 'status_done'.tr();
      case TaskStatus.undetermined:
        return 'status_undetermined'.tr();
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

  static bool isUnauthorizedStatusCode(String error) {
    switch (error.toLowerCase()) {
      case ErrorType.tokenExpired:
        return true;
      case 'not authenticated':
        return true;
      case 'not authorized':
        return true;
      case 'unauthorized':
        return true;
      case '401':
        return true;
      default:
        return false;
    }
  }

  static DateTime? parseDate(String? date, {String dateFormat = 'yyyy-MM-ddTHH:mm:ss'}) {
    if (date == null || date.isEmpty) return null;
    try {
      return DateFormat(dateFormat).parse(date);
    } catch (e) {
      return null;
    }
  }

  static TaskStatus getStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'to_do':
        return TaskStatus.todo;
      case 'todo':
        return TaskStatus.todo;
      case 'in_process':
        return TaskStatus.in_process;
      case 'done':
        return TaskStatus.done;
      case 'undetermined':
        return TaskStatus.undetermined;
      default:
        return TaskStatus.undetermined;
    }
  }

  static String getTimerNumber(int number) {
    if (number >= 0 && number <= 9) return '0$number';
    return number.toString();
  }

  static String getStringTimeSort(TimeSort? time) {
    switch (time) {
      case TimeSort.week:
        return 'week'.tr();
      case TimeSort.month:
        return 'month'.tr();
      case TimeSort.past_tasks:
        return 'past_tasks'.tr();
      case TimeSort.out_of_deadline:
        return 'out_of_deadline'.tr();
      default:
        return '';
    }
  }
}
