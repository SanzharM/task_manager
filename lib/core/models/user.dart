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

  User({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.role,
    this.registrationTime,
    this.lastVisitTime,
    this.imageUrl,
    this.position,
    this.cityName,
    this.organization,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User();
  }

  User copyWith({
    int? id,
    String? name,
    String? surname,
    String? email,
    String? phone,
    dynamic role,
    DateTime? registrationTime,
    DateTime? lastVisitTime,
    String? imageUrl,
    String? position,
    String? cityName,
    Organization? organization,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      registrationTime: registrationTime ?? this.registrationTime,
      lastVisitTime: lastVisitTime ?? this.lastVisitTime,
      imageUrl: imageUrl ?? this.imageUrl,
      position: position ?? this.position,
      cityName: cityName ?? this.cityName,
      organization: organization ?? this.organization,
    );
  }
}
