// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Address {
  final String id;
  final String label;
  final String address;
  final double latitude;
  final double longitude;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as String,
      label: map['label'] as String,
      address: map['address'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      isDefault: map['isDefault'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));
}

class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final String brand;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.brand,
    required this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'last4': last4,
      'brand': brand,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] as String,
      type: map['type'] as String,
      last4: map['last4'] as String,
      brand: map['brand'] as String,
      isDefault: map['isDefault'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromJson(String source) =>
      PaymentMethod.fromMap(json.decode(source));
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.addresses,
    required this.paymentMethods,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'addresses': addresses.map((x) => x.toMap()).toList(),
      'paymentMethods': paymentMethods.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      addresses: List<Address>.from(
        map['addresses']?.map((x) => Address.fromMap(x)) ?? [],
      ),
      paymentMethods: List<PaymentMethod>.from(
        map['paymentMethods']?.map((x) => PaymentMethod.fromMap(x)) ?? [],
      ),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class ResponseUser {
  final List<User> users;
  ResponseUser({required this.users});

  factory ResponseUser.fromJson(String source) {
    try {
      final decoded = jsonDecode(source);

      // API return { "user" [...] }
      if (decoded is Map<String, dynamic>) {
        final list = decoded['users'] as List? ?? [];
        return ResponseUser(
          users: list.map((json) => User.fromMap(json)).toList(),
        );
      }

      // API return [{...},  {...}]
      if (decoded is List) {
        return ResponseUser(
          users: decoded.map((json) => User.fromMap(json)).toList(),
        );
      }

      throw Exception('Unexpected Json stucture');
    } catch (e) {
      throw Exception('Invalid loading Order: $e');
    }
  }
}
