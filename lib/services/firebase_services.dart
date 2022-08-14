import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/providers/category_component.dart';
import 'package:pomodoro/services/auth_methods.dart';
import '../providers/task.dart';

class FirebaseService extends ChangeNotifier {
  List<CategoryComponent> items;

  FirebaseService({required this.items});

  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  Set<CategoryComponent> favorites = {};
  Set<Task> tasks = {};
  Future<void> getAllFavorites() async {
    QuerySnapshot<Map<String, dynamic>>? favoritesRef;
    try {
      favoritesRef = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("favorites")
          .get();
      if (favoritesRef.docs.isNotEmpty) {
        favoritesRef.docs.forEach((element) {
          favorites.add(items.firstWhere((item) => item.id == element.data()['id']));
        });
      } else {
        favorites = {};
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addFavorite(CategoryComponent component) async {
    component.isFavorite = !component.isFavorite;
    try {
      if (component.isFavorite) {
        await firestore
            .collection("users")
            .doc(user.uid)
            .collection("favorites")
            .doc(component.id)
            .set({'id': component.id});
      } else {
        favorites.remove(component);
        await firestore
            .collection("users")
            .doc(user.uid)
            .collection("favorites")
            .doc(component.id)
            .delete();

        print('ok?');
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future uploadTask(Task task) async {
    try {
      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("tasks")
          .doc(task.id)
          .set(task.toJson());
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future updateTask(Task task) async {

    await firestore
        .collection("users")
        .doc(user.uid)
        .collection("tasks")
        .doc(task.id).update(task.toJson());
    notifyListeners();
  }

  Future removeTask(Task task) async {

    await firestore.collection("users").doc(user.uid).collection("tasks").doc(task.id).delete();
   tasks.removeWhere((element) => element.id == task.id);
    notifyListeners();

  }

  Future<void> fetchAllTasks() async {
    QuerySnapshot<Map<String, dynamic>>? taskRef;
    try {
      print("User uid: " + user.uid);
      print("email: " + user.email!);
      taskRef = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("tasks")
          .get();
      taskRef.docs.forEach((element) {
        tasks.add(Task.fromJson(element.data()));
        for (int i = 0;i < tasks.length - 1;i++){
          for (int j = i+1;j < tasks.length;j++){
            if (tasks.elementAt(i).id == tasks.elementAt(j).id) {
              tasks.remove(tasks.elementAt(j));
            }
          }
        }
      });

    } catch (e) {
      print(e);
    }
  }
}
