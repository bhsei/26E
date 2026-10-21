import 'package:flutter/material.dart';

/// Global floating entry point for DēGlitch Assistant.
///
/// Place this inside a Positioned widget within the shared mobile layout's
/// Stack (above the Scaffold body, not inside each individual screen).
class SuperMobileAssistantFab extends StatelessWidget {
  const SuperMobileAssistantFab({
    super.key,
    required this.onPressed,
    this.visible = true,
  });

  final VoidCallback onPressed;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        child: Tooltip(
          message: 'AI Assistance',
          child: Material(
            elevation: 7,
            shadowColor: const Color(0x330878F9),
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: visible ? onPressed : null,
              customBorder: const CircleBorder(),
              child: Ink(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF49C5FF), Color(0xFF0878F9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
