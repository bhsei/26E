import 'package:flutter/material.dart';

/// Shared visual tokens used by the DēGlitch secondary settings screens.
abstract final class DgColors {
  static const blue = Color(0xFF0878F9);
  static const deepBlue = Color(0xFF12447F);
  static const mutedBlue = Color(0xFF7193B7);
  static const page = Color(0xFFF3F8FD);
  static const line = Color(0xFFDDEBFA);
  static const paleBlue = Color(0xFFEAF5FF);
  static const green = Color(0xFF10A879);
  static const red = Color(0xFFE64F5A);
  static const amber = Color(0xFFE9A23B);
}

class DgPageScaffold extends StatelessWidget {
  const DgPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 28),
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;
  final EdgeInsets padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DgColors.page,
      appBar: AppBar(
        backgroundColor: DgColors.page,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: DgColors.deepBlue,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: DgColors.deepBlue,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: actions,
      ),
      body: SafeArea(
        top: false,
        child: Padding(padding: padding, child: child),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

class DgSectionHeading extends StatelessWidget {
  const DgSectionHeading(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: DgColors.deepBlue,
              fontSize: 12,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    ),
  );
}

class DgPanel extends StatelessWidget {
  const DgPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: DgColors.line),
      boxShadow: const [
        BoxShadow(
          color: Color(0x080F4380),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

class DgSettingsTile extends StatelessWidget {
  const DgSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: DgColors.paleBlue,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFCFE8FF)),
              ),
              child: Icon(icon, color: DgColors.blue, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: DgColors.deepBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: DgColors.mutedBlue,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (showChevron) ...[
              if (trailing != null) const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: DgColors.mutedBlue,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class DgPrimaryButton extends StatelessWidget {
  const DgPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 17,
              height: 17,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon ?? Icons.check_rounded, size: 19),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: DgColors.blue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: DgColors.blue.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

class DgOutlineButton extends StatelessWidget {
  const DgOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.foregroundColor = DgColors.blue,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        side: BorderSide(color: foregroundColor.withOpacity(0.24)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}

class DgStatusPill extends StatelessWidget {
  const DgStatusPill(this.label, {super.key, this.color = DgColors.green});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.11),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
    ),
  );
}

class DgEmptyState extends StatelessWidget {
  const DgEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: DgColors.paleBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: DgColors.blue),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: DgColors.deepBlue,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: DgColors.mutedBlue,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 18), action!],
        ],
      ),
    ),
  );
}

void dgShowMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}
