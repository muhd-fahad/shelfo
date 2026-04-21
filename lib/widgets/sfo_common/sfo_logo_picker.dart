import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shelfo/widgets/sfo_common/sfo_image_viewer.dart';
import '../../utils/theme/theme_constants.dart';

class SFOLogoPicker extends StatelessWidget {
  final String? logoPath;
  final bool isDark;
  final Function(ImageSource) onPick;
  final VoidCallback onRemove;
  final double size;
  final String label;

  const SFOLogoPicker({
    super.key,
    this.logoPath,
    required this.isDark,
    required this.onPick,
    required this.onRemove,
    this.size = 100,
    this.label = "upload logo",
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
                  onPick(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera, color: isDark ? Colors.white : Colors.black87),
                title: Text('Camera', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  onPick(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              if (logoPath != null) ...[
                ListTile(
                  leading: Icon(Icons.visibility_outlined, color: isDark ? Colors.white : Colors.black87),
                  title: Text('View Image', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  onTap: () {
                    Navigator.of(context).pop();
                    SFOImageViewer.show(context, logoPath!);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Remove Logo', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    onRemove();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget;
    if (logoPath != null) {
      if (logoPath!.startsWith('assets/') && logoPath!.endsWith('.svg')) {
        imageWidget = SvgPicture.asset(logoPath!, fit: BoxFit.contain);
      } else if (logoPath!.startsWith('assets/')) {
        imageWidget = Image.asset(logoPath!, fit: BoxFit.cover);
      } else {
        imageWidget = Image.file(File(logoPath!), fit: BoxFit.cover);
      }
    }

    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: isDark ? AppColors.darkBackground : Colors.grey.shade100,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.xl,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: logoPath != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: imageWidget,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        size: size * 0.3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
          ),
          if (logoPath != null)
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: onRemove,
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
      ),
    );
  }
}
