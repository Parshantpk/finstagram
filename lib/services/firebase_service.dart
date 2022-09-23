import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

const String userCollection = 'users';
const String postCollection = 'posts';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Map? currentUser;

  FirebaseService();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required File image,
  }) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String _userId = _userCredential.user!.uid;
      log(_userId);
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image.path);
      log(_fileName);
      UploadTask _task =
          _storage.ref('images/$_userId/$_fileName').putFile(image);
      log(_task.toString());
      log(image.toString());
      return _task.then((_snapshot) async {
        String _downloadUrl = await _snapshot.ref.getDownloadURL();
        log(_downloadUrl);
        await _db.collection(userCollection).doc(_userId).set({
          "name": name,
          "email": email,
          "image": _downloadUrl,
        });
        log('true');
        return true;
      }).catchError((e) {
        log("false == >${e}");
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCredential.user != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot doc = await _db.collection(userCollection).doc(uid).get();
    return doc.data() as Map;
  }

  Future<bool> postImage(File _image) async {
    try {
      String _userId = _auth.currentUser!.uid;
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(_image.path);
      UploadTask _task =
          _storage.ref('images/$_userId/$_fileName').putFile(_image);
      return await _task.then((_snapshot) async {
        String _downloadUrl = await _snapshot.ref.getDownloadURL();
        await _db.collection(postCollection).add({
          'userId': _userId,
          'timestamp': Timestamp.now(),
          'image': _downloadUrl,
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> getLatestPosts() {
    return _db
        .collection(postCollection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsForUser() {
    String _userId = _auth.currentUser!.uid;
    return _db
        .collection(postCollection)
        .where('userId', isEqualTo: _userId)
        .snapshots();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
