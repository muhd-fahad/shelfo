import 'package:flutter/material.dart';

import '../utils/theme/theme.dart';

Text ScreenTitleWidget(String title) {
  return Text(
    title,
    style: SFOAppTheme.light.textTheme.titleLarge,
  );
}