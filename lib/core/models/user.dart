import 'package:task_manager/core/models/organization.dart';
import 'package:task_manager/core/utils.dart';

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
    this.organization,
  });

  String get fullName => (this.name ?? '') + (this.surname ?? '');

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse('${json['id']}'),
      phone: '${json['phone'] ?? ''}',
      role: json['role'],
      position: json['position'],
      name: json['name'],
      imageUrl: json['image_url'],
      registrationTime: Utils.parseDate('${json['created_at']}'),
      lastVisitTime: Utils.parseDate('${json['updated_at']}'),
    );
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
      organization: organization ?? this.organization,
    );
  }

  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    return {
      "id": this.id,
      "phone": this.phone,
      "role": this.role,
      "position": this.position,
      "name": this.name,
      "image_url": this.imageUrl,
      "company_id": this.organization?.id,
      "total_money_in_kzt": null,
      "last_visit_time": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
      "created_at": null,
    };
  }
}
