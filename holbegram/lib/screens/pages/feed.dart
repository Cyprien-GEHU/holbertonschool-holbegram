import 'package:flutter/material.dart';
import '../../utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Holbegram",
              style: TextStyle(
                fontFamily: "Billabong",
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset("assets/images/logo.png", height: 30, width: 30),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: const [Icon(Icons.message), SizedBox(width: 10)],
      ),
      body: const Posts(),
    );
  }
}
