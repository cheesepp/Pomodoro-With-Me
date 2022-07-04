import 'package:flutter/cupertino.dart';
import 'package:pomodoro/providers/category.dart';
import 'package:pomodoro/providers/category_component.dart';

class CategoryItems with ChangeNotifier {
  List<Category> _categoryData = [
    Category(
      id: 'c1',
      category: Categories.Code,
      categoryImage:
          'https://img.icons8.com/cotton/64/000000/working-with-a-laptop--v1.png',
    ),
    Category(
      id: 'c2',
      category: Categories.Space,
      categoryImage:
          'https://img.icons8.com/external-itim2101-lineal-color-itim2101/64/000000/external-space-space-and-galaxy-itim2101-lineal-color-itim2101.png',
    ),
    Category(
      id: 'c3',
      category: Categories.Lofi,
      categoryImage: 'https://img.icons8.com/color/48/000000/irish-music.png',
    ),
    Category(
      id: 'c4',
      category: Categories.Nature,
      categoryImage: 'https://img.icons8.com/cotton/64/000000/tree.png',
    ),
    Category(
      id: 'c5',
      category: Categories.City,
      categoryImage: 'https://img.icons8.com/cotton/64/000000/city--v2.png',
    ),
    Category(
      id: 'c6',
      category: Categories.Beach,
      categoryImage: 'https://img.icons8.com/cotton/64/000000/beach--v1.png',
    ),
    Category(
      id: 'c7',
      category: Categories.Window,
      categoryImage:
          'https://img.icons8.com/cotton/64/000000/frozen-window.png',
    ),
    Category(
      id: 'c8',
      category: Categories.Cafe,
      categoryImage: 'https://img.icons8.com/cotton/64/000000/cafe.png',
    ),
    Category(
      id: 'c9',
      category: Categories.Kpop,
      categoryImage:
          'https://img.icons8.com/cotton/64/000000/musical-notes.png',
    ),
    Category(
      id: 'c10',
      category: Categories.Anime,
      categoryImage: 'https://img.icons8.com/dusk/64/000000/son-goku.png',
    ),
  ];

  List<Category> get categoryData {
    return [..._categoryData];
  }
}
