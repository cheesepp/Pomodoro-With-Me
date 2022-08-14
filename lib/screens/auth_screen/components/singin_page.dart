import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/models/users.dart';
import 'package:pomodoro/services/auth_methods.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:provider/provider.dart';

import '../../../providers/auth_notifier.dart';
import '../../../widgets/toast_widget.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key, required this.onClicked}) : super(key: key);
  VoidCallback onClicked;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showPassword = true;
  bool _isLogin = true;
  Users _users =
      Users(email: '', password: '', uuid: '', userName: '', avatar: '');
  AuthMethods _authentication = AuthMethods();
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      AuthNotifier authNotifier =
          Provider.of<AuthNotifier>(context, listen: false);
      //initialize current user
      _authentication.initializeCurrentUser(authNotifier);
    });
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    _formKey.currentState!.save();
    RegExp regExp =
        RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
    _users.email = _emailController.text.trim();
    _users.password = _passwordController.text.trim();
    if (!regExp.hasMatch(_users.email)) {
      toast('Enter a valid email ID');
    } else if (_users.password.length < 8) {
      toast('Password must have at least 8 characters');
    } else {
      // login function

      _authentication.login(_users, authNotifier, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _emailField(),
              const SizedBox(
                height: 20,
              ),
              _passwordField(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: const Text('Sign in!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      fixedSize: const Size(200,
                          60)), //El ancho de deja en 0 porque el "expanded" lo define.
                  onPressed: () {
                    _submitForm();
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'no_acc'.tr + " "),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClicked,
                          text: 'login_signup'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 3,
                endIndent: 100,
                indent: 100,
                color: Colors.black12,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      AuthNotifier authNotifier =
                          Provider.of<AuthNotifier>(context, listen: false);
                      AuthMethods().signInWithGoogle(context, authNotifier);
                    },
                    icon: ImageIcon(
                      AssetImage('assets/icons/google.png'),
                      color: Colors.red,
                    ),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      AuthNotifier authNotifier =
                          Provider.of<AuthNotifier>(context, listen: false);
                      AuthMethods().signInWithFacebook(context, authNotifier);
                    },
                    icon: ImageIcon(
                      AssetImage('assets/icons/facebook.png'),
                      size: 28,
                      color: Color(0xff3b5998),
                    ),
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _passwordField() {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromARGB(224, 79, 76, 76).withOpacity(0.3)),
      child: TextFormField(
          key: const Key("signInPassword"),
          controller: _passwordController,
          obscureText: showPassword,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility),
              ),
              border: InputBorder.none,
              labelText: 'login_password'.tr),
          style: TextStyle(height: 0.5)),
    );
  }

  Container _emailField() {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromARGB(224, 79, 76, 76).withOpacity(0.3)),
      child: TextFormField(
          key: const Key("signInEmail"),
          controller: _emailController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              border: InputBorder.none,
              labelText: 'Email'),
          style: TextStyle(height: 0.5)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
