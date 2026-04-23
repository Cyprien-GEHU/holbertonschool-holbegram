import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontFamily: "Billabong",
            fontSize: 32,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Text("liked posts"),
      ),
    );
  } 
}