import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Picks an image from gallery or camera
  static Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }

  /// Saves the image to the application documents directory
  static Future<String?> saveImageToLocalDirectory(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final String savedPath = path.join(directory.path, fileName);
      
      final File savedImage = await imageFile.copy(savedPath);
      return savedImage.path;
    } catch (e) {
      debugPrint('Error saving image: $e');
    }
    return null;
  }

  /// Deletes an image from the local directory
  static Future<void> deleteImage(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return;
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }
}
