import '../../interactor/entities/device_entity.dart';

class DevicesAdapter {
  static DeviceEntity fromJson(Map<String, dynamic> json) {
    return DeviceEntity(
      id: json['id'],
      name: json['name'],
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }
}
