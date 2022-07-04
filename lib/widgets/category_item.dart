import 'package:flutter/material.dart';
import 'package:pomodoro/screens/category_components_screen.dart';

import '../providers/category.dart';

class CategoryItem extends StatelessWidget {
  String id;
  String image;
  Categories name;
  CategoryItem(
      {Key? key, required this.id, required this.image, required this.name})
      : super(key: key);

  String get categoryText {
    switch (name) {
      case Categories.Code:
        return 'Code';
        break;
      case Categories.Space:
        return 'Space';
        break;
      case Categories.Beach:
        return 'Beach';
        break;
      case Categories.Anime:
        return 'Anime';
        break;
      case Categories.Cafe:
        return 'Cafe';
        break;
      case Categories.City:
        return 'City';
        break;
      case Categories.Kpop:
        return 'K-pop';
        break;
      case Categories.Lofi:
        return 'Lofi';
        break;
      case Categories.Nature:
        return 'Nature';
        break;
      case Categories.Window:
        return 'Window';
        break;
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Color(0xfff6f7dd),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(CategoryComponentsScreen.routeName, arguments: {
            'name': categoryText,
            'category': name,
            'icon': image,
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: Image.network(image),
            ),
            Text(
              categoryText,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
