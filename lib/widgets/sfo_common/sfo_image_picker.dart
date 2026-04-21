import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shelfo/widgets/sfo_common/sfo_image_viewer.dart';
import '../../utils/theme/theme_constants.dart';

class SFOImagePicker extends StatelessWidget {
  final List<String> imagePaths;
  final bool isDark;
  final Function(ImageSource) onAddImage;
  final Function(int) onRemoveImage;
  final String label;

  const SFOImagePicker({
    super.key,
    required this.imagePaths,
    required this.isDark,
    required this.onAddImage,
    required this.onRemoveImage,
    this.label = "upload images",
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library, color: isDark ? Colors.white : Colors.black87),
                title: Text('Photo Library', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  onAddImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera, color: isDark ? Colors.white : Colors.black87),
                title: Text('Camera', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  onAddImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...imagePaths.asMap().entries.map((entry) {
            int idx = entry.key;
            String path = entry.value;
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => SFOImageViewer.show(context, path),
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 12, top: 8),
                    decoration: ShapeDecoration(
                      shape: RoundedSuperellipseBorder(
                        borderRadius: AppRadius.md,
                      ),
                      image: DecorationImage(
                        image: FileImage(File(path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => onRemoveImage(idx),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }),
          GestureDetector(
            onTap: () => _showPicker(context),
            child: Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(top: 8),
              decoration: ShapeDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppRadius.md,
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  const SizedBox(height: 4),
                  Text(label, 
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, 
                      fontSize: 10
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
