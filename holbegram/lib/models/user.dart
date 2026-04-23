import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String uid;
  String email;
  String username;
  String bio;
  String photoUrl;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;
  List<dynamic> saved;
  String searchKey;


  Users({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.saved,
    required this.searchKey,
  });

  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>? ?? {};

    return Users(
      uid: snapshot['uid'] ?? "", 
      email: snapshot['email'] ?? "", 
      username: snapshot['username'] ?? "", 
      bio: snapshot['bio'] ?? "",
      photoUrl: snapshot['photoUrl'] ?? "",
      followers: List<dynamic>.from(snapshot["followers"] ?? []),
      following: List<dynamic>.from(snapshot["following"] ?? []),
      posts: List<dynamic>.from(snapshot["posts"] ?? []),
      saved: List<dynamic>.from(snapshot["saved"] ?? []),
      searchKey: snapshot['searchKey'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid, 
    "email": email, 
    "username": username, 
    "bio": bio,
    "photoUrl": photoUrl,
    "followers": followers,
    "following": following,
    "posts": posts,
    "saved": saved,
    "searchKey": searchKey,
  };
}