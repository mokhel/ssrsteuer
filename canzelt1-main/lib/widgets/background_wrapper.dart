import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background.webp',
          fit: BoxFit.cover,
        ),
        Container(color: Colors.black.withOpacity(0.5)), // Abdunklung
        child,
      ],
    );
  }
}
