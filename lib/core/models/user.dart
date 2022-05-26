import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/models/organization.dart';
import 'package:task_manager/core/utils.dart';

class User {
  int? id;
  String? name;
  String? phone;
  dynamic role;
  DateTime? registrationTime;
  DateTime? lastVisitTime;
  String? imageUrl;
  String? position;
  Organization? organization;
  DateTime? birthday;
  double? totalMoney;
  double? moneyPerHour;

  User({
    this.id,
    this.name,
    this.phone,
    this.role,
    this.registrationTime,
    this.lastVisitTime,
    this.imageUrl,
    this.position,
    this.organization,
    this.birthday,
    this.moneyPerHour,
    this.totalMoney,
  });

  String get fullName => (this.name ?? '');

  bool needToFillProfile() => this.id == null || this.fullName.isEmpty || (this.phone?.isEmpty ?? false);

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
      birthday: Utils.parseDate('${json['birthday']}'),
      moneyPerHour: double.tryParse('${json['money_in_hour_kzt']}'),
      totalMoney: double.tryParse('${json['total_money_in_kzt']}'),
    );
  }

  void clearImage() => this.imageUrl = null;

  User copyWith({
    int? id,
    String? name,
    String? phone,
    dynamic role,
    DateTime? registrationTime,
    DateTime? lastVisitTime,
    String? imageUrl,
    String? position,
    Organization? organization,
    DateTime? birthday,
    double? totalMoney,
    double? moneyPerHour,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      registrationTime: registrationTime ?? this.registrationTime,
      lastVisitTime: lastVisitTime ?? this.lastVisitTime,
      imageUrl: imageUrl ?? this.imageUrl,
      position: position ?? this.position,
      organization: organization ?? this.organization,
      birthday: birthday ?? this.birthday,
      totalMoney: totalMoney ?? this.totalMoney,
      moneyPerHour: moneyPerHour ?? this.moneyPerHour,
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
      "last_visit_time": now.toIso8601String(),
      "updated_at": now.toIso8601String(),
      "created_at": this.registrationTime?.toIso8601String(),
      "birthday": this.birthday?.toIso8601String(),
      "total_money_in_kzt": this.totalMoney,
      "money_in_hour_kzt": this.moneyPerHour,
    };
  }

  Widget tryGetImage({bool canAddImage = false, double? placeholderSize}) {
    final placeholder = canAddImage
        ? Icon(CupertinoIcons.camera_fill, size: placeholderSize ?? 32)
        : Icon(CupertinoIcons.person_fill, size: placeholderSize ?? 32);

    if (this.imageUrl?.isEmpty ?? true) return placeholder;

    if (this.imageUrl!.startsWith('http')) {
      return Image.network(
        this.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    if (this.imageUrl!.startsWith('/data')) {
      return Image.file(
        File(this.imageUrl!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    return placeholder;
  }
}
