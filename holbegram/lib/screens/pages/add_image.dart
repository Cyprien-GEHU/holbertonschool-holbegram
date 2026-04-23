import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import 'methods/post_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  Future<void> selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);

    if (file != null) {
      final img = await file.readAsBytes();
      setState(() {
        _image = img;
      });
    }
  }

  void showPickOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> postImage() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final user = userProvider.getUser;

      if (user == null) return;
      
      String res = await PostStorage().uploadPost(
        _captionController.text,
        user.uid,
        user.username,
        user.photoUrl,
        _image!,
      );

      if (!mounted) return;

      if (res == "ok") {
    setState(() {
      _image = null;
      _captionController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post published")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res)),
    );
  }
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post",
          style: TextStyle(
            fontFamily: "Billabong",
            fontSize: 32,
            color: Colors.black,
          ),
        ),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                )
              : TextButton(
                  onPressed: _isLoading ? null : postImage,
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      fontFamily: "Billabong",
                      fontSize: 32,
                      color: Colors.red,
                    ),
                  ),
                ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                hintText: "Write a caption...",
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          _image != null
              ? Image.memory(_image!, height: 250)
              : GestureDetector(
                  onTap: showPickOptions,
                  child: Center(
                    child: Image.asset(
                      "assets/images/add.png",
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
