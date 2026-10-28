import 'package:flutter/material.dart';
import '../../../widgets/deglitch_brand.dart';
import 'auth_copy.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deglitchPale,
      body: Stack(
        children: [
          const Positioned(
            top: -115,
            right: -95,
            child: _GlowCircle(size: 285, opacity: 0.25),
          ),
          const Positioned(
            bottom: -150,
            left: -120,
            child: _GlowCircle(size: 320, opacity: 0.24),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 46,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [
          deglitchBlue.withValues(alpha: opacity),
          deglitchPale.withValues(alpha: 0),
        ],
      ),
    ),
  );
}

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: GlitchBrand(
      iconSize: 58,
      showWordmark: true,
      darkBackground: false,
      animated: false,
    ),
  );
}

class AuthTitle extends StatelessWidget {
  const AuthTitle({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: deglitchNavy,
          fontSize: 25,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.55,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 7),
        Text(
          subtitle!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF6484A8),
            fontSize: 14,
            height: 1.45,
          ),
        ),
      ],
    ],
  );
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.validator,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    autofillHints: autofillHints,
    validator: validator,
    style: const TextStyle(
      color: deglitchNavy,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF85A1BF), fontSize: 13),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF3679B9)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.9),
      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFDCEEFF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFDCEEFF), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: deglitchBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE56A78)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE56A78), width: 1.3),
      ),
    ),
  );
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    width: double.infinity,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: const LinearGradient(
          colors: [Color(0xFF168BFF), Color(0xFF0866E9)],
        ),
        boxShadow: [
          BoxShadow(
            color: deglitchBlue.withValues(alpha: 0.20),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    ),
  );
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.lead,
    required this.action,
    required this.onTap,
  });
  final String lead;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(
        lead,
        style: const TextStyle(color: Color(0xFF6986A7), fontSize: 12),
      ),
      TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          action,
          style: const TextStyle(
            color: deglitchBlue,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ],
  );
}

class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({super.key, required this.onUnavailable});
  final VoidCallback onUnavailable;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        authText(context, 'continueWith'),
        style: const TextStyle(color: Color(0xFF7D97B3), fontSize: 12),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: _SocialButton(
              label: 'Google',
              child: const Text(
                'G',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4285F4),
                ),
              ),
              onTap: onUnavailable,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SocialButton(
              label: 'Apple',
              child: const Icon(
                Icons.phone_iphone_rounded,
                size: 24,
                color: Colors.black,
              ),
              onTap: onUnavailable,
            ),
          ),
        ],
      ),
    ],
  );
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.child,
    required this.onTap,
  });
  final String label;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 51,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.82),
        side: const BorderSide(color: Color(0xFFDCEEFF)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Tooltip(message: label, child: child),
    ),
  );
}

void showAuthMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF103D73),
        duration: const Duration(seconds: 3),
      ),
    );
}
