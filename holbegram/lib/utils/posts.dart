import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/user_provider.dart';
import '../screens/pages/methods/post_storage.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final PostStorage _postStorage = PostStorage();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("posts").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            Post post = Post.fromSnap(docs[index]);

            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 540,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                post.profImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          Text(post.username, style: TextStyle(fontSize: 18)),
                          const Spacer(),
                          if (user.uid == post.uid)
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () async {
                                await _postStorage.deletePost(
                                  post.postId,
                                  post.publicId,
                                  post.uid,
                                  post.likes,
                                );

                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Post Deleted")),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          post.caption,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(post.postUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              post.likes.contains(user.uid)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post.likes.contains(user.uid)
                                  ? Colors.red
                                  : Colors.black,
                            ),
                            onPressed: () async {
                              final postRef = FirebaseFirestore.instance
                                  .collection("posts")
                                  .doc(post.postId);

                              if (post.likes.contains(user.uid)) {
                                await postRef.update({
                                  "likes": FieldValue.arrayRemove([user.uid]),
                                });
                              } else {
                                await postRef.update({
                                  "likes": FieldValue.arrayUnion([user.uid]),
                                });
                              }
                            },
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chat_bubble_outline),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.send),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              user.saved.contains(post.postId)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: user.saved.contains(post.postId)
                                  ? Colors.red
                                  : Colors.black,
                            ),
                            onPressed: () async {
                              final userRef = FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(user.uid);

                              if (user.saved.contains(post.postId)) {
                                await userRef.update({
                                  "saved": FieldValue.arrayRemove([
                                    post.postId,
                                  ]),
                                });
                              } else {
                                await userRef.update({
                                  "saved": FieldValue.arrayUnion([post.postId]),
                                });
                              }

                              // 🔥 IMPORTANT : refresh user provider
                              await Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).refreshUser();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "${post.likes.length} Liked",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
