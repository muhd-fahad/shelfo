import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/theme/theme.dart';

class SFOLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isIconOnly;

  const SFOLogo({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.isIconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String assetPath;
    
    if (isIconOnly) {
      assetPath = AppAssets.logoIcon;
    } else {
      assetPath = isDark ? AppAssets.logoSecondary : AppAssets.logoPrimary;
    }

    return SizedBox(
      height: height,
      width: width,
      child: SvgPicture.asset(
        assetPath,
        fit: fit,
      ),
    );
  }
}
