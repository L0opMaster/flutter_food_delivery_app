// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Categories {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  const Categories({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());

  factory Categories.fromJson(String source) =>
      Categories.fromMap(json.decode(source));

  @override
  bool operator ==(covariant Categories other) =>
      identical(this, other) && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ResponseCategories {
  final List<Categories> categories;
  ResponseCategories({required this.categories});

  factory ResponseCategories.fromJson(String source) {
    try {
      final List<dynamic> jsonList = jsonDecode(source) as List<dynamic>;
      return ResponseCategories(
        categories: jsonList.map((json) => Categories.fromMap(json)).toList(),
      );
    } catch (e) {
      throw Exception('Invalid loading format: $e');
    }
  }
}
