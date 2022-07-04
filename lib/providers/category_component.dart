import 'package:flutter/cupertino.dart';
import 'package:pomodoro/providers/category.dart';

import '../firebase_services.dart';

class CategoryComponent with ChangeNotifier {
  String id;
  List<Categories> categories;
  String name;
  String imageUrl;
  String videoUrl;
  String ytbUrl;
  bool isFavorite;
  CategoryComponent(
      {required this.id,
      required this.categories,
      required this.imageUrl,
      required this.name,
      required this.videoUrl,
      required this.ytbUrl,
      this.isFavorite = false});

  factory CategoryComponent.fromJson(Map<String, dynamic> json) {
    return CategoryComponent(
      id: json['id'],
      categories: jsonToEnum(json['categories'])!,
      name: json['name'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      ytbUrl: json['ytbUrl'],
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
