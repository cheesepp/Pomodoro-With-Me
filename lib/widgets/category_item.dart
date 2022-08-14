import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/screens/category_components_screen.dart';
import 'package:pomodoro/utils/ThemeColor.dart';

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
        return 'code'.tr;
        break;
      case Categories.Space:
        return 'space'.tr;
        break;
      case Categories.Beach:
        return 'beach'.tr;
        break;
      case Categories.Anime:
        return 'Anime';
        break;
      case Categories.Cafe:
        return 'Cafe';
        break;
      case Categories.City:
        return 'city'.tr;
        break;
      case Categories.Kpop:
        return 'K-pop';
        break;
      case Categories.Lofi:
        return 'Lofi';
        break;
      case Categories.Nature:
        return 'nature'.tr;
        break;
      case Categories.Window:
        return 'window'.tr;
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
            primary: Theme.of(context).accentColor,
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
