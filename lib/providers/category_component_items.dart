import 'package:flutter/material.dart';
import 'package:pomodoro/providers/category.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryComponentItems with ChangeNotifier {
  final listKey = GlobalKey<AnimatedListState>();
  final List<CategoryComponent> _items = [];

  List<CategoryComponent> get items {
    return [..._items];
  }

  List<CategoryComponent> fetchComponentsByCategory(Categories category) {
    return [
      ..._items.where((element) => element.categories.contains(category))
    ];
  }

  CategoryComponent fetchComponent(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<CategoryComponent> fetchFavoriteComponents() {
    return [...items.where((element) => element.isFavorite == true)];
  }

  void removeFavoriteItems(int index) {
    final favoriteItems = fetchFavoriteComponents();
    favoriteItems.removeAt(index);
    listKey.currentState!.removeItem(index, (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: const Card(
          margin: EdgeInsets.all(10),
          elevation: 10,
          color: Colors.purple,
          child: ListTile(
            contentPadding: EdgeInsets.all(15),
            title: Text("Goodbye", style: TextStyle(fontSize: 24)),
          ),
        ),
      );
    });
  }

  // Stream<List<CategoryComponent>> readSnapshot() {
  //   return FirebaseFirestore.instance
  //       .collection('category-component')
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => _items.add(
  //               CategoryComponent.fromJson(doc.data() as Map<String, dynamic>)))
  //           .toList() as List<CategoryComponent>);
  // }
  Future<void> getCategoriesCollectionFromFirebase() async {
    final _instance = FirebaseFirestore.instance;
    CollectionReference categories = _instance.collection('category-component');

    DocumentSnapshot snapshot =
        await categories.doc('category_components').get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var categoriesData = data['items'] as List<dynamic>;
      categoriesData.forEach((catData) {
        CategoryComponent cat = CategoryComponent.fromJson(catData);
        _items.add(cat);
      });
    }
  }
}
