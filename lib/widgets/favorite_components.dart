import 'package:flutter/material.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:pomodoro/screens/category_components_screen.dart';
import 'package:provider/provider.dart';
import '../screens/component_detail_screen.dart';

class FavoriteComponentItem extends StatefulWidget {
  @override
  State<FavoriteComponentItem> createState() => _FavoriteComponentItemState();
}

class _FavoriteComponentItemState extends State<FavoriteComponentItem> {
  @override
  Widget build(BuildContext context) {
    final component = Provider.of<CategoryComponent>(context);
    return ChangeNotifierProvider.value(
      value: component,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ComponentDetailScreen(
                      component: component,
                    )));
            print('successfully!');
          },
          child: Container(
            height: 90,
            width: 200,
            decoration: BoxDecoration(
              color: Color(0xfff6f7dd),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(offset: Offset(6, 7), blurRadius: 18)],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(component.imageUrl),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 4,
                  child: SizedBox(
                    // height: 30,
                    width: 270,
                    child: Text(
                      component.name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: IconButton(
                      onPressed: () {
                        // setState(() {
                        //   component.isFavorite = !component.isFavorite;
                        //   print(component.isFavorite);
                        component.toggleFavorite();
                      },
                      icon: component.isFavorite
                          ? Icon(
                              Icons.favorite_outlined,
                              color: Colors.red,
                              size: 20,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 20,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
