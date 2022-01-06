import 'package:task_manager/core/models/organization.dart';

class User {
  int? id;
  String? name;
  String? surname;
  String? email;
  String? phone;
  dynamic role;
  DateTime? registrationTime;
  DateTime? lastVisitTime;
  String? imageUrl;
  String? position;
  String? cityName;
  Organization? organization;
}
