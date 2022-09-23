import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                titleWidget(),
                loginForm(),
                loginButton(),
                registerPageLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    return const Text(
      'Finstagram',
      style: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget loginForm() {
    return Container(
      height: _deviceHeight! * 0.2,
      child: Form(
        key: loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emailField(),
            passwordField(),
          ],
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Email...'),
      onSaved: (value) {
        setState(() {
          email = value;
        });
      },
      validator: (value) {
        bool result = value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$"),
        );
        return result ? null : 'Please enter a valid email!';
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Password...'),
      onSaved: (value) {
        setState(() {
          password = value;
        });
      },
      validator: (value) => value!.length >= 6
          ? null
          : 'Please enter a valid password than 6 characters!',
    );
  }

  Widget loginButton() {
    return MaterialButton(
      onPressed: loginUser,
      minWidth: _deviceWidth! * 0.70,
      height: _deviceHeight! * 0.06,
      color: Colors.red,
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget registerPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/register'),
      child: const Text(
        "Don't have an account?",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 15,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }

  void loginUser() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      bool _result = await _firebaseService!.loginUser(email: email!, password: password!);
      if (_result) Navigator.popAndPushNamed(context, '/');
    }
  }
}
