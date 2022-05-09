import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';

class Session {
  final int? pk;
  final User? user;
  final DateTime? startTime;
  final DateTime? finishTime;

  Session({this.pk, this.user, this.startTime, this.finishTime});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      pk: int.tryParse('${json['id']}'),
      // user: User.fromJson(json),
      user: User(id: int.tryParse('${json['user_id']}')),
      startTime: Utils.parseDate(json['started_at']),
      finishTime: Utils.parseDate(json['finished_at']),
    );
  }
}
