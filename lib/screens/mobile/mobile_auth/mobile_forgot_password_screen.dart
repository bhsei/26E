import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/deglitch_brand.dart';
import 'auth_components.dart';
import 'auth_copy.dart';

class MobileForgotPasswordScreen extends StatefulWidget {
  const MobileForgotPasswordScreen({super.key});
  @override
  State<MobileForgotPasswordScreen> createState() =>
      _MobileForgotPasswordScreenState();
}

class _MobileForgotPasswordScreenState
    extends State<MobileForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return authText(context, 'enterEmail');
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))
      return authText(context, 'invalidEmail');
    return null;
  }

  Future<void> _sendReset() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _loading) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      setState(() => _sent = true);
      showAuthMessage(context, authText(context, 'resetEmailSent'));
    } on FirebaseAuthException catch (error) {
      if (mounted) showAuthMessage(context, authErrorText(context, error.code));
    } catch (_) {
      if (mounted)
        showAuthMessage(context, authText(context, 'genericAuthError'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => AuthShell(
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, .04),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: _sent ? _successView() : _formView(),
    ),
  );

  Widget _formView() => Form(
    key: _formKey,
    child: Column(
      key: const ValueKey('recovery-form'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthBrandHeader(),
        const SizedBox(height: 25),
        const Center(child: _RecoveryIllustration()),
        const SizedBox(height: 17),
        AuthTitle(
          title: authText(context, 'resetPassword'),
          subtitle: authText(context, 'resetSubtitle'),
        ),
        const SizedBox(height: 25),
        AuthTextField(
          controller: _emailController,
          hint: authText(context, 'email'),
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          validator: _validateEmail,
        ),
        const SizedBox(height: 16),
        AuthPrimaryButton(
          label: authText(context, _loading ? 'sending' : 'sendResetLink'),
          onPressed: _sendReset,
          loading: _loading,
        ),
        const SizedBox(height: 19),
        Center(
          child: TextButton.icon(
            onPressed: () => context.go('/sign-in'),
            icon: const Icon(Icons.arrow_back_rounded, size: 17),
            label: Text(authText(context, 'backToSignIn')),
            style: TextButton.styleFrom(foregroundColor: deglitchBlue),
          ),
        ),
      ],
    ),
  );

  Widget _successView() => Column(
    key: const ValueKey('recovery-success'),
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const AuthBrandHeader(),
      const SizedBox(height: 38),
      const Center(child: _RecoveryIllustration(success: true)),
      const SizedBox(height: 25),
      AuthTitle(title: authText(context, 'resetEmailSent')),
      const SizedBox(height: 27),
      AuthPrimaryButton(
        label: authText(context, 'backToSignIn'),
        onPressed: () => context.go('/sign-in'),
      ),
    ],
  );
}

class _RecoveryIllustration extends StatelessWidget {
  const _RecoveryIllustration({this.success = false});
  final bool success;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    height: 130,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFDAF1FF).withValues(alpha: .65),
          ),
        ),
        Container(
          width: 79,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFB9E0FF), width: 2),
            boxShadow: [
              BoxShadow(
                color: deglitchBlue.withValues(alpha: .12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            success
                ? Icons.mark_email_read_rounded
                : Icons.mark_email_unread_rounded,
            color: deglitchBlue,
            size: 39,
          ),
        ),
        Positioned(
          right: 16,
          top: 8,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: success ? const Color(0xFF18B78B) : deglitchBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: deglitchBlue.withValues(alpha: .20),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              success ? Icons.check_rounded : Icons.lock_reset_rounded,
              color: Colors.white,
              size: 19,
            ),
          ),
        ),
        Positioned(left: 9, bottom: 15, child: _dot(7)),
        Positioned(right: 6, bottom: 27, child: _dot(5)),
        Positioned(left: 27, top: 13, child: _dot(4)),
      ],
    ),
  );

  Widget _dot(double size) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Color(0xFF55BFFF),
      shape: BoxShape.circle,
    ),
  );
}
