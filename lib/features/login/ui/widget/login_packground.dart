import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ColorfulBackground extends StatelessWidget {
  final Widget? child;
  const ColorfulBackground({Key? key, this.child}) : super(key: key);

  static Color c(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));

  // Your gradient colors
  static const _baseGradientColors = [
    Color(0xFFA7E0F8),
    Color(0xFF27548A),
    Color(0xFF00B4D8),
    Color(0xFF27548A),
    Color(0xFF4477AC),
    Color(0xFF00B4D8),
    Color(0xFFDDE7FF),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    double blobSize(double factor) => (width + height) * factor;

    return SizedBox.expand(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _baseGradientColors,
              ),
            ),
          ),
          Positioned(
            left: -width * 0.25,
            top: height * 0.05,
            child: _BlurredBlob(
              size: blobSize(0.6),
              colors: const [Color(0xFFA7E0F8), Color(0xFF4477AC)],
              blur: 120,
              opacity: 0.9,
            ),
          ),
          Positioned(
            left: width * 0.25,
            top: -height * 0.08,
            child: _BlurredBlob(
              size: blobSize(0.45),
              colors: const [Color(0xFF00B4D8), Color(0xFFDDE7FF)],
              blur: 100,
              opacity: 0.7,
            ),
          ),
          Positioned(
            right: -width * 0.2,
            bottom: -height * 0.05,
            child: _BlurredBlob(
              size: blobSize(0.55),
              colors: const [Color(0xFF27548A), Color(0xFF4477AC)],
              blur: 140,
              opacity: 0.95,
            ),
          ),
          if (child != null) Center(child: child),
        ],
      ),
    );
  }
}

class _BlurredBlob extends StatelessWidget {
  final double size;
  final List<Color> colors;
  final double blur;
  final double opacity;

  const _BlurredBlob({
    Key? key,
    required this.size,
    required this.colors,
    this.blur = 80,
    this.opacity = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.2, -0.1),
              radius: 0.8,
              colors: colors,
            ),
          ),
        ),
      ),
    );
  }
}
