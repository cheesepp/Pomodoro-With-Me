import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/screens/tab_screen.dart';

import '../../models/users.dart';
import '../../providers/auth.dart';
import '../../providers/auth_notifier.dart';
import 'package:provider/provider.dart';

import '../../widgets/image_picker.dart';
import '../../widgets/toast_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Users _users =
      Users(userName: '', email: '', password: '', uuid: '', avatar: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Authentication _authentication = Authentication();
  File? _pickedImage;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool showPassword = true;
  bool showConfirmPassword = true;
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
    _formKey.currentState!.save();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    RegExp regExp =
        RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
    _users.userName = _userNameController.text.trim();
    _users.email = _emailController.text.trim();
    _users.password = _passwordController.text.trim();
    if (_users.userName.length < 3) {
      toast('Name must have at least 3 characters');
    }
    if (!regExp.hasMatch(_users.email)) {
      toast('Enter a valid email ID');
    } else if (_passwordController.text.toString() != _users.password) {
      toast('Confirm password does not match with password');
    } else if (_users.password.length < 8) {
      toast('Password must have at least 8 characters');
    } else {
      // login function
      // if (_pickedImage != null)
      _authentication.signUp(_users, _pickedImage, authNotifier, context);
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
              UserImagePicker(_pickedImage),
              const SizedBox(
                height: 20,
              ),
              _emailField(),
              const SizedBox(
                height: 20,
              ),
              _usernameField(),
              const SizedBox(
                height: 20,
              ),
              _passwordField(),
              const SizedBox(
                height: 20,
              ),
              _confirmPasswordField(),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: const Text('Sign up!',
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
                    onPressed: () {},
                    icon: ImageIcon(
                      AssetImage('assets/icons/twitter.png'),
                      color: Colors.blue,
                    ),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: ImageIcon(
                      AssetImage('assets/icons/google.png'),
                      color: Colors.red,
                    ),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {},
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

  Container _usernameField() {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromARGB(224, 79, 76, 76).withOpacity(0.3)),
      child: TextFormField(
          key: Key("username"),
          controller: _userNameController,
          autocorrect: true,
          textCapitalization: TextCapitalization.words,
          enableSuggestions: false,
          validator: (value) {
            if (value!.isEmpty || value.length < 4) {
              return 'Please enter at least 4 characters';
            }
            return null;
          },
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.account_circle_sharp),
              border: InputBorder.none,
              labelText: 'User name'),
          style: TextStyle(height: 0.5)),
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
          key: const Key("signUpPassword"),
          controller: _passwordController,
          obscureText: showPassword,
          validator: (value) {
            if (value!.isEmpty || value.length < 7) {
              return 'Password must be at least 7 characters long.';
            }
            return null;
          },
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
              labelText: 'Password'),
          style: TextStyle(height: 0.5)),
    );
  }

  Container _confirmPasswordField() {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromARGB(224, 79, 76, 76).withOpacity(0.3)),
      child: TextFormField(
          key: const Key("signUpConfirmPassword"),
          controller: _confirmPasswordController,
          obscureText: showConfirmPassword,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Confirm password is not match!';
            }
            return null;
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showConfirmPassword = !showConfirmPassword;
                  });
                },
                icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility),
              ),
              border: InputBorder.none,
              labelText: 'Confirm Password'),
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
          key: const Key("signUpEmail"),
          controller: _emailController,
          textCapitalization: TextCapitalization.none,
          enableSuggestions: false,
          validator: (value) {
            if (value!.isEmpty || !value.contains('@')) {
              return 'Please enter a valid email address.';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
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
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
