import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:task_manager/core/utils.dart';

class Session {
  final int? pk;
  final DateTime? startTime;
  final DateTime? finishTime;
  final double? lat;
  final double? lng;

  Session({this.pk, this.startTime, this.finishTime, this.lat, this.lng});

  bool isActive() => this.finishTime == null;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      pk: int.tryParse('${json['id']}'),
      startTime: Utils.parseDate(json['started_at'])?.add(DateTime.now().timeZoneOffset),
      finishTime: Utils.parseDate(json['finished_at'])?.add(DateTime.now().timeZoneOffset),
      lat: double.tryParse('${json['latitude']}'),
      lng: double.tryParse('${json['longitude']}'),
    );
  }

  static Future<geocoding.Placemark?> getCurrentLocation() async {
    final data = await Location.instance.getLocation();
    if (data.latitude == null || data.longitude == null) return null;
    return (await geocoding.placemarkFromCoordinates(data.latitude!, data.longitude!)).first;
  }
}
