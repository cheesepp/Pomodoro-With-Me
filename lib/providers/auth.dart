import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pomodoro/auth_screen/auth_screen.dart';
import 'package:pomodoro/providers/auth_notifier.dart';
import 'package:pomodoro/screens/tab_screen.dart';

import '../models/users.dart';
import '../widgets/toast_widget.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;

  //login
  Future<void> login(
      Users users, AuthNotifier authNotifier, BuildContext context) async {
    UserCredential? result;

    try {
      result = await auth.signInWithEmailAndPassword(
          email: users.email, password: users.password);
    } catch (e) {
      toast('Sai roi ba');
    }

    //check verification
    try {
      if (result != null) {
        User user = auth.currentUser!;
        if (!user.emailVerified) {
          auth.signOut();
          toast('Email ID not verified');
        } 
          authNotifier.setUser(user);
          await getUserDetail(authNotifier);

          Navigator.push(
              context, MaterialPageRoute(builder: ((_) => const TabsScreen())));
        }
    } catch (e) {
      toast(e.toString());
    }
  }

  //sign up
  Future<void> signUp(Users users, File? image, AuthNotifier authNotifier,
      BuildContext context) async {
    UserCredential? result;
    bool userDataUploaded = false;
    try {
      result = await auth.createUserWithEmailAndPassword(
          email: users.email, password: users.password);
    } catch (e) {
      toast(e.toString());
    }

    try {
      if (result != null) {
        await auth.currentUser!.updateDisplayName(users.userName);

        User user = result.user!;
        await user.sendEmailVerification();
        if (user != null) {
          await user.reload();

          uploadUserData(users, userDataUploaded);
          await auth.signOut();
          authNotifier.setUser(null);

          toast('Verification link is sent to ${user.email}');
        }
      }
    } catch (e) {
      toast(e.toString());
    }

    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(users.uuid.toString() + '.jpg');
    try {
      await ref.putFile(image!);
    } catch (e) {
      print('Ko duoc ba oi');
    }
    try {
      users.avatar = await ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
  }

  //up load user data
  Future<void> uploadUserData(Users users, bool userDataUploaded) async {
    bool userDataUploadVar = userDataUploaded;

    User currentUser = auth.currentUser!;
    users.uuid = currentUser.uid;
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');

    // check data uploaded or not
    if (!userDataUploadVar) {
      await userRef
          .doc(currentUser.uid)
          .set(users.toJson())
          .catchError((e) => print(e))
          .then((value) => userDataUploadVar = true);
    }
  }

  //get user details
  Future<void>? getUserDetail(AuthNotifier authNotifier) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(authNotifier.user!.uid)
        .get()
        .catchError((e) => print(e))
        .then((value) => (value != null)
            ? authNotifier.setUserDetails(Users.fromJson(value.data()!))
            : print(value));
  }

  // initialize current user
  Future<void> initializeCurrentUser(AuthNotifier authNotifier) async {
    User user = auth.currentUser!;

    if (user != null) {
      authNotifier.setUser(user);
      await getUserDetail(authNotifier);
    }
  }

  //sign out
  Future<void> signOut(AuthNotifier authNotifier, BuildContext context) async {
    await auth.signOut();

    authNotifier.setUser(null);
    print('Logout');
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const AuthScreen()));
  }
}
