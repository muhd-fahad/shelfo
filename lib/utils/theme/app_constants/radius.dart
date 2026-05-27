import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppRadius {
  static BorderRadius get sm => BorderRadius.all(Radius.circular(8.r));
  static BorderRadius get md => BorderRadius.all(Radius.circular(12.r));
  static BorderRadius get lg => BorderRadius.all(Radius.circular(16.r));
  static BorderRadius get xl => BorderRadius.all(Radius.circular(24.r));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}
