import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/dsxr97aer/image/upload";

  final String cloudinaryPreset = "unsigned_preset";

  Future<Map<String, dynamic>> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));

      request.fields['upload_preset'] = cloudinaryPreset;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file,
          filename: const Uuid().v1(),
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var json = jsonDecode(responseData);

        return {
          "url": json['secure_url'],
          "public_id": json['public_id'],
        };
      } else {
        throw Exception(responseData);
      }
    } catch (e) {
      throw Exception("Upload failed: $e");
    }
  }

  Future<void> deleteImage(String publicId) async {
    final url =
        "https://api.cloudinary.com/v1_1/dsxr97aer/image/destroy";

    await http.post(
      Uri.parse(url),
      body: {"public_id": publicId, "upload_preset": cloudinaryPreset},
    );
  }
}