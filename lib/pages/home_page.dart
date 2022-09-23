import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finstagram/pages/feed_page.dart';
import 'package:finstagram/pages/profile_page.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  FirebaseService? _firebaseService;
  final List<Widget> pages = [
    FeedPage(),
    ProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
     _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finstagram'),
        actions: [
          GestureDetector(
            onTap: _postImage,
            child: const Icon(
              Icons.add_a_photo,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: GestureDetector(
              onTap: _logoutUser,
              child: const Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(),
      body: pages[currentPage],
    );
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Feed',
            icon: Icon(Icons.feed),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_box),
          ),
        ]);
  }

  void _postImage() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    File _image = File(_result!.files.first.path!);
    await _firebaseService!.postImage(_image);
  }

  void _logoutUser() async {
    await _firebaseService!.logout();
    Navigator.popAndPushNamed(context, '/login');
  }
}
