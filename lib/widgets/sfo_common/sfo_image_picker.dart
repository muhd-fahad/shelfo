import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shelfo/widgets/sfo_common/sfo_image_viewer.dart';
import '../../utils/theme/theme.dart';

class SFOImagePicker extends StatelessWidget {
  final List<String> imagePaths;
  final Function(ImageSource) onAddImage;
  final Function(int) onRemoveImage;
  final String label;

  const SFOImagePicker({
    super.key,
    required this.imagePaths,
    required this.onAddImage,
    required this.onRemoveImage,
    this.label = "upload images",
  });

  void _showPicker(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library, color: colorScheme.onSurface),
                title: Text('Photo Library', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.of(context).pop();
                  onAddImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera, color: colorScheme.onSurface),
                title: Text('Camera', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.of(context).pop();
                  onAddImage(ImageSource.camera);
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                      shape: const RoundedSuperellipseBorder(
                        borderRadius: AppRadius.md,
                      ),
                      image: DecorationImage(
                        image: kIsWeb 
                          ? NetworkImage(path) as ImageProvider
                          : FileImage(File(path)),
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
                      decoration: BoxDecoration(
                        color: colorScheme.error,
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
                color: theme.inputDecorationTheme.fillColor,
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppRadius.md,
                  side: BorderSide(
                    color: colorScheme.outline,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_outlined, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 4),
                  Text(label, 
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
