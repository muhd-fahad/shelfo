import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

class SFOImagePicker extends StatelessWidget {
  final List<String> imagePaths;
  final bool isDark;
  final VoidCallback onAddImage;
  final String label;

  const SFOImagePicker({
    super.key,
    required this.imagePaths,
    required this.isDark,
    required this.onAddImage,
    this.label = "upload images",
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...imagePaths.map((path) => Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: ShapeDecoration(
                  shape: RoundedSuperellipseBorder(
                    borderRadius: AppRadius.md,
                  ),
                  image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
                ),
              )),
          GestureDetector(
            onTap: onAddImage,
            child: Container(
              width: 100,
              height: 100,
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
