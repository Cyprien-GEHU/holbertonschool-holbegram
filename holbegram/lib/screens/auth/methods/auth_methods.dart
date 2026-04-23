import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';
import 'package:http/http.dart' as http;
import '../../../models/user.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login({
    required String email,
    required String password,}) async {
      if (email.isEmpty || password.isEmpty ) {
        return "Please fill all the fields";
      }
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        return "success";
      } catch (error) {
        return error.toString(); 
      }
    }
  
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,}) async {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return "Please fill all the fields";
      }
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        User user = userCredential.user!;

        String photoUrl = "";
        if (file != null) {
          final data = await StorageMethods().uploadImageToStorage(
            false,
            'profile_pictures',
            file);
          photoUrl = data["url"];
        }

        Users newUser = Users(
          uid: user.uid,
          email: email,
          username: username,
          bio: "",
          photoUrl: photoUrl,
          followers: [],
          following: [],
          posts: [],
          saved: [],
          searchKey: username.toLowerCase(),
        );

        await _firestore
          .collection("users")
          .doc(user.uid)
          .set(newUser.toJson());
        return "success";
      } catch (error) {
        return error.toString();
      }
    }

  Future<Users> getUserDetails() async {
    User? curUser = _auth.currentUser;

    if (curUser == null) {
      throw Exception("No user logged in");
    }
    DocumentSnapshot snap = await _firestore.collection("users").doc(curUser.uid).get();

    return Users.fromSnap(snap);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

