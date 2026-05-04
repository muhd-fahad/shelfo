import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SFOImageViewer extends StatelessWidget {
  final String imagePath;

  const SFOImageViewer({super.key, required this.imagePath});

  static void show(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SFOImageViewer(imagePath: imagePath),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSvg = imagePath.endsWith('.svg');
    final isAsset = imagePath.startsWith('assets/');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: imagePath,
            child: isSvg
                ? SvgPicture.asset(imagePath, fit: BoxFit.contain)
                : (isAsset
                    ? Image.asset(imagePath, fit: BoxFit.contain)
                    : (kIsWeb 
                        ? Image.network(imagePath, fit: BoxFit.contain)
                        : Image.file(File(imagePath), fit: BoxFit.contain))),
          ),
        ),
      ),
    );
  }
}
