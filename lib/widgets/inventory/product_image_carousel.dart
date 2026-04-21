import 'dart:io';
import 'package:flutter/material.dart';
import '../sfo_common/sfo_image_viewer.dart';
import '../../utils/theme/theme_constants.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final bool isDark;

  const ProductImageCarousel({
    super.key,
    required this.imagePaths,
    required this.isDark,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: widget.isDark ? AppColors.darkBorder : AppColors.border),
        ),
        child: Icon(Icons.inventory_2_outlined, size: 60, color: AppColors.primary.withOpacity(0.2)),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: widget.imagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final path = widget.imagePaths[index];
              final isAsset = path.startsWith('assets/');
              
              return GestureDetector(
                onTap: () => SFOImageViewer.show(context, path),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: widget.isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: widget.isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Hero(
                      tag: path,
                      child: isAsset
                          ? Image.asset(path, fit: BoxFit.contain)
                          : Image.file(File(path), fit: BoxFit.cover),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.imagePaths.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imagePaths.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(
                    _currentIndex == entry.key ? 0.9 : 0.2,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
