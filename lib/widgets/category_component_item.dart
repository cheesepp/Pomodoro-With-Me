import 'package:flutter/material.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:pomodoro/screens/category_components_screen.dart';
import 'package:provider/provider.dart';
import '../screens/component_detail_screen.dart';

class CategoryComponentItem extends StatelessWidget {
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
              color: const Color(0xfff6f7dd),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(offset: Offset(6, 7), blurRadius: 18)
              ],
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
                const SizedBox(
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
