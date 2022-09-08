import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pomodoro/models/users.dart';
import 'package:pomodoro/providers/auth_notifier.dart';
import 'package:pomodoro/screens/tab_screen.dart';
import 'package:pomodoro/services/storage_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/src/provider.dart';

import '../screens/auth_screen/auth_screen.dart';
import '../widgets/notification_dialog_widget.dart';
import '../widgets/toast_widget.dart';

void showSnackBar(BuildContext context, String text,
    {Color? color, Color? textColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: color,
    ),
  );
}

class AuthMethods extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore ref = FirebaseFirestore.instance;
  //login
  Future<void> login(
      Users users, AuthNotifier authNotifier, BuildContext context) async {
    UserCredential? result;

    try {
      result = await _auth.signInWithEmailAndPassword(
          email: users.email, password: users.password);
    } catch (e) {
      toast('Your email or password is not correctly!');
    }

    //check verification
    try {
      if (result != null) {
        User user = _auth.currentUser!;
        _auth.currentUser == null ? print('null') : print('not null');
        if (!user.emailVerified) {
          _auth.signOut();
          toast('Email ID not verified');
        } else if (user != null) {
          authNotifier.setUser(user);
          await getUserDetail(authNotifier);
          print('done');
          print(authNotifier.userDetails.userName);
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((_) => const TabsScreen())));
        SavingDataLocally.setLogin();
        SavingDataLocally.setAuthMethods('email auth');
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
      result = await _auth.createUserWithEmailAndPassword(
          email: users.email, password: users.password);
      print(users.email + " " + users.password);
    } catch (e) {
      toast(e.toString());
    }

    try {
      if (result != null) {
        await _auth.currentUser!.updateDisplayName(users.userName);

        User user = result.user!;
        await user.sendEmailVerification();
        if (user != null) {
          await user.reload();
          await uploadUserData(users, userDataUploaded);
          await _auth.signOut();
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
        .child(user.uid.toString() + '.jpg');
    try {
      await ref.putFile(image!);
      await uploadUserData(users, userDataUploaded);
    } catch (e) {
      print('ERROR:' + e.toString());
      print('Ko duoc ba oi');
    }

    try {
      users.avatar = await ref.getDownloadURL();
    } catch (e) {
      print('error: ' + e.toString());
    }
  }

  //up load user data
  Future<void> uploadUserData(Users users, bool userDataUploaded) async {
    bool userDataUploadVar = userDataUploaded;

    User currentUser = _auth.currentUser!;
    users.avatar = await FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(currentUser.uid.toString() + '.jpg')
        .getDownloadURL();

    users.uuid = currentUser.uid;
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');

    // check data uploaded or not
    if (!userDataUploadVar) {
      await userRef
          .doc(currentUser.uid)
          .set(users.toJson())
          .catchError((e) => print('errorrrrr'
                  ': ' +
              e))
          .then((value) {
        print(users.toJson());
        userDataUploadVar = true;
      });
    }
  }

  //get user details
  Future<void>? getUserDetail(AuthNotifier authNotifier) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(authNotifier.user!.uid)
        .get()
        .catchError((e) => print(e))
        .then((value) {
      print(value.data()!);
      authNotifier.setUserDetails(Users.fromJson(value.data()!));
    });
  }

  // initialize current user
  Future<void> initializeCurrentUser(AuthNotifier authNotifier) async {
    User? user = _auth.currentUser;

    if (user != null) {
      authNotifier.setUser(user);
      await getUserDetail(authNotifier);
    }
  }

  //sign out
  Future<void> signOut(AuthNotifier authNotifier, BuildContext context) async {
    await _auth.signOut();

    authNotifier.setUser(null);
    print('Logout');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;
  Users users =
      Users(userName: '', email: '', password: '', avatar: '', uuid: '');

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  // FACEBOOK SIGN IN
  Future<void> signInWithFacebook(
      BuildContext context, AuthNotifier authNotifier) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final UserCredential fbuser =
          await _auth.signInWithCredential(facebookAuthCredential);
      bool userDataUploaded = false;
      User currentUser = fbuser.user!;
      users.userName = currentUser.displayName ?? "No information";
      users.avatar =
          currentUser.photoURL ?? "https://demofree.sirv.com/nope-not-here.jpg";
      users.email = currentUser.email!;
      users.uuid = currentUser.uid;

      if (fbuser.user!.isAnonymous) {
        uploadUserData(users, userDataUploaded);
        print('${authNotifier.userDetails.avatar}hehe');
      }
      authNotifier.setUserDetails(users);
      SavingDataLocally.setLogin();
      SavingDataLocally.setAuthMethods('facebook auth');
      NotificationDialog.show(context, 'Login success', 'Welcome! (*´▽`*)');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const TabsScreen())));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      print(e.message!); // Displaying the error message
    }
  }

  // FACEBOOK SIGN OUT
  Future facebookSignOut(
      AuthNotifier authNotifier, BuildContext context) async {
    await FacebookAuth.instance.logOut();
    SavingDataLocally.setLogin(isLogin: false);
    NotificationDialog.show(context, 'Logout', 'Signout success!');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => const AuthScreen())));
    authNotifier.setUser(null);
    authNotifier.setUserDetails(
        Users(userName: '', email: '', password: '', avatar: '', uuid: ''));
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(
      BuildContext context, AuthNotifier authNotifier) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // if you want to do specific task like storing information in firestore
        // only for new users using google sign in (since there are no two options
        // for google sign in and google sign up, only one as of now),
        // do the following:

        if (userCredential.user != null) {
          bool userDataUploaded = false;
          User currentUser = userCredential.user!;
          users.userName = currentUser.displayName as String;
          users.avatar = currentUser.photoURL as String;
          users.uuid = currentUser.uid as String;
          if (userCredential.additionalUserInfo!.isNewUser) {
            uploadUserData(users, userDataUploaded);
            print('${authNotifier.userDetails.avatar}hehe');
          }

          authNotifier.setUserDetails(users);
          print('${authNotifier.userDetails.avatar}hehe');
          NotificationDialog.show(context, 'Login success', 'Welcome! (*´▽`*)');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const TabsScreen())));
          SavingDataLocally.setLogin();
          SavingDataLocally.setAuthMethods('google auth');
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // GOOGLE SIGN OUT
  Future googleSignOut(BuildContext context, AuthNotifier authNotifier) async {
    await FirebaseAuth.instance.signOut();
    SavingDataLocally.setLogin(isLogin: false);
    NotificationDialog.show(context, 'Logout', 'Logout success');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => const AuthScreen())));
    authNotifier.setUser(null);
    authNotifier.setUserDetails(
        Users(userName: '', email: '', password: '', avatar: '', uuid: ''));
  }
}
