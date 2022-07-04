import 'package:flutter/cupertino.dart';

enum Categories {
  Code,
  Space,
  Lofi,
  Nature,
  City,
  Beach,
  Window,
  Cafe,
  Kpop,
  Anime,
}

class Category {
  String id;
  Categories category;
  String categoryImage;
  Category(
      {required this.id, required this.category, required this.categoryImage});
}
