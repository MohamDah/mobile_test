import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/errors/failures.dart';

/// Uploads images to Cloudinary via the unsigned upload REST API.
/// No secret key is embedded — the upload preset is unsigned.
class CloudinaryDataSource {
  static const String _cloudName = 'dbbpf2hla';
  static const String _uploadPreset = 'iotp877m';
  static final Uri _uploadUri = Uri.parse(
    'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
  );

  /// Uploads [file] to the `gym_images` folder on Cloudinary and returns
  /// the permanent HTTPS URL (`secure_url`) from the response.
  Future<String> uploadGymImage(File file) async {
    try {
      final request = http.MultipartRequest('POST', _uploadUri)
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode != 200) {
        throw ServerFailure(
            'Image upload failed (HTTP ${response.statusCode}).');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final url = json['secure_url'] as String?;
      if (url == null) {
        throw const ServerFailure('Cloudinary did not return a download URL.');
      }
      return url;
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Image upload failed: $e');
    }
  }
}
