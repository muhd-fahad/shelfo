import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_background.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SFOHeader(title: "About Shelfo"),
      body: SFOBackground(
        child: Center(
          child: Column(
            spacing: 12.h,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const SFOLogo(height: 44, width: 162,  fit: .contain,),
              Text(
                "Version 1.0.0",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "Your complete inventory solution.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 48.h),
              const Text("made with ❤️ by Fahad"),
            ],
          ),
        ),
      ),
    );
  }
}
