import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shelfo/widgets/sfo_common/sfo_image_viewer.dart';
import '../../utils/theme/theme.dart';

class SFOLogoPicker extends StatelessWidget {
  final String? logoPath;
  final Function(ImageSource) onPick;
  final VoidCallback onRemove;
  final double size;
  final String label;

  const SFOLogoPicker({
    super.key,
    this.logoPath,
    required this.onPick,
    required this.onRemove,
    this.size = 100,
    this.label = "upload logo",
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
                  onPick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera, color: colorScheme.onSurface),
                title: Text('Camera', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.of(context).pop();
                  onPick(ImageSource.camera);
                },
              ),
              if (logoPath != null) ...[
                ListTile(
                  leading: Icon(Icons.visibility_outlined, color: colorScheme.onSurface),
                  title: Text('View Image', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.of(context).pop();
                    SFOImageViewer.show(context, logoPath!);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: colorScheme.error),
                  title: Text('Remove Logo', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.error)),
                  onTap: () {
                    Navigator.of(context).pop();
                    onRemove();
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget? imageWidget;
    if (logoPath != null) {
      if (logoPath!.startsWith('assets/') && logoPath!.endsWith('.svg')) {
        imageWidget = SvgPicture.asset(logoPath!, fit: BoxFit.contain);
      } else if (logoPath!.startsWith('assets/')) {
        imageWidget = Image.asset(logoPath!, fit: BoxFit.cover);
      } else {
        imageWidget = kIsWeb 
            ? Image.network(logoPath!, fit: BoxFit.cover)
            : Image.file(File(logoPath!), fit: BoxFit.cover);
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
              color: colorScheme.surfaceContainer,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.xl,
                side: BorderSide(
                  color: colorScheme.outline,
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
                        color: colorScheme.onSurfaceVariant,
                        size: size * 0.3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
                  decoration: BoxDecoration(
                    color: colorScheme.error,
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
