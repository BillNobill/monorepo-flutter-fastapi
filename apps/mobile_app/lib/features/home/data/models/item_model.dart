import 'package:mobile_app/core/utils/base_model.dart';

class Item extends BaseModel {
  final int id;
  final String title;
  final String description;

  Item({required this.id, required this.title, required this.description});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
  };
}
