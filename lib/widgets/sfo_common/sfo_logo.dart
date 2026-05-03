import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/theme/theme.dart';

class SFOLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit fit;

  const SFOLogo({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String assetPath = isDark ? AppAssets.logoSecondary : AppAssets.logoPrimary;

    return SvgPicture.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
