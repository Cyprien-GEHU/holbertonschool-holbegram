import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchcontroller = TextEditingController();
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchcontroller,
          decoration: const InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value.toLowerCase();
            });
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(), 
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var users = snapshot.data!.docs;
          var filtered = users.where((user) {
            return user["username"]
              .toString()
              .toLowerCase()
              .contains(query);
          }).toList();
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              var user = filtered[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user["photoUrl"]),
                ),
                title: Text(user["username"]),
                subtitle: Text(user["email"]),
              );
            },
          );
        },
      ),
    );
  }
}