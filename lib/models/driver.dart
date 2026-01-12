// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Driver {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final String vehiclePlate;
  final double rating;
  final int totalDeliveries;
  final bool isActive;
  final double currentLatitude;
  final double currentLongitude;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.rating,
    required this.totalDeliveries,
    required this.isActive,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  Driver copyWith({
    String? id,
    String? name,
    String? phone,
    String? vehicleType,
    String? vehiclePlate,
    double? rating,
    int? totalDeliveries,
    bool? isActive,
    double? currentLatitude,
    double? currentLongitude,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      rating: rating ?? this.rating,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      isActive: isActive ?? this.isActive,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'rating': rating,
      'totalDeliveries': totalDeliveries,
      'isActive': isActive,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      vehicleType: map['vehicleType'] as String,
      vehiclePlate: map['vehiclePlate'] as String,
      rating: (map['rating'] as num).toDouble(),
      totalDeliveries: map['totalDeliveries'] as int,
      isActive: map['isActive'] as bool,
      currentLatitude: (map['currentLatitude'] as num).toDouble(),
      currentLongitude: (map['currentLongitude'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Driver.fromJson(String source) => Driver.fromMap(json.decode(source));

  @override
  bool operator ==(covariant Driver other) =>
      identical(this, other) || other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ResponseDriver {
  List<Driver> drivers;
  ResponseDriver({required this.drivers});

  factory ResponseDriver.fromJson(String source) {
    try {
      final List<dynamic> jsonList = jsonDecode(source) as List<dynamic>;
      return ResponseDriver(
        drivers: jsonList.map((json) => Driver.fromMap(json)).toList(),
      );
    } catch (e) {
      throw Exception('Invalid format Driver: $e');
    }
  }
}
