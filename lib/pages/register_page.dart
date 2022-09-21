import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight, _deviceWidth;
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();
  String? name, email, password;
  File? image;
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
                profileImageWidget(),
                registrationForm(),
                registerButton(),
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

  Widget registerButton() {
    return MaterialButton(
      onPressed: registerUser,
      minWidth: _deviceWidth! * 0.70,
      height: _deviceHeight! * 0.06,
      color: Colors.red,
      child: const Text(
        'Register',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget registrationForm() {
    return Container(
      height: _deviceHeight! * 0.30,
      child: Form(
        key: registrationFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            nameField(),
            emailField(),
            passwordField(),
          ],
        ),
      ),
    );
  }

  Widget profileImageWidget() {
    var imageProvider = image != null
        ? FileImage(image!)
        : const NetworkImage('https://i.pravatar.cc/300');
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((result) {
          setState(() {
            image = File(result!.files.first.path!);
          });
        });
      },
      child: Container(
        height: _deviceHeight! * 0.15,
        width: _deviceHeight! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Name...'),
      validator: (value) => value!.isNotEmpty ? null : 'Please enter a name!',
      onSaved: (value) {
        setState(() {
          name = value;
        });
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Email...'),
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
      decoration: InputDecoration(hintText: 'Password...'),
      onSaved: (value) {
        setState(() {
          password = value;
        });
      },
      validator: (value) => value!.length > 6
          ? null
          : 'Please enter a valid password than 6 characters!',
    );
  }

  void registerUser() {
    if (registrationFormKey.currentState!.validate() && image != null) {
      registrationFormKey.currentState!.save();
    }
  }
}
