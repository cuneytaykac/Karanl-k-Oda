import 'package:flutter/material.dart';

/// Banyo tepsisi.
class DevelopTray extends StatelessWidget {
  const DevelopTray({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A1A16), Color(0xFF24110E)],
        ),
        border: Border.all(color: const Color(0xFF4A2620), width: 3),
        boxShadow: const [
          BoxShadow(
              color: Color(0xB3000000), blurRadius: 60, offset: Offset(0, 30))
        ],
      ),
      child: child,
    );
  }
}
