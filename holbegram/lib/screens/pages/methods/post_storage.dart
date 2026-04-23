import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    try {
      final cloudData = await StorageMethods().uploadImageToStorage(
        true,
        "post",
        image,
      );

      String postId = _firestore.collection("posts").doc().id;
      await _firestore.collection("posts").doc(postId).set({
        "caption": caption,
        "uid": uid,
        "username": username,
        "profImage": profImage,
        "postUrl": cloudData['url'],
        "public_id": cloudData["public_id"],
        "postId": postId,
        "datePublished": DateTime.now(),
        "likes": [],
      });

      await _firestore.collection("users").doc(uid).update({
        "posts": FieldValue.arrayUnion([postId]),
      });

      return "ok";
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> deletePost(
    String postId,
    String publicId,
    String uid,
    List likes,
  ) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();

      await _firestore.collection("users").doc(uid).update({
        "posts": FieldValue.arrayRemove([postId]),
      });

      final usersSnap = await _firestore
          .collection("users")
          .where("saved", arrayContains: postId)
          .get();

      for (var doc in usersSnap.docs) {
        await doc.reference.update({
          "saved": FieldValue.arrayRemove([postId]),
        });
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
