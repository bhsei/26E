import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/deglitch_brand.dart';
import 'auth_components.dart';
import 'auth_copy.dart';

class MobileSignUpScreen extends StatefulWidget {
  const MobileSignUpScreen({super.key});
  @override
  State<MobileSignUpScreen> createState() => _MobileSignUpScreenState();
}

class _MobileSignUpScreenState extends State<MobileSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _acceptedTerms = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) =>
      (value == null || value.trim().isEmpty)
      ? authText(context, 'enterName')
      : null;
  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return authText(context, 'enterEmail');
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))
      return authText(context, 'invalidEmail');
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty)
      return authText(context, 'enterPassword');
    if (value.length < 6) return authText(context, 'weakPassword');
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty)
      return authText(context, 'enterPassword');
    if (value != _passwordController.text)
      return authText(context, 'passwordsDoNotMatch');
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _loading) return;
    if (!_acceptedTerms) {
      showAuthMessage(context, authText(context, 'mustAcceptTerms'));
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await result.user?.updateDisplayName(_nameController.text.trim());
      if (!mounted) return;
      showAuthMessage(context, authText(context, 'accountCreated'));
      context.go('/super-mobile-home');
    } on FirebaseAuthException catch (error) {
      if (mounted) showAuthMessage(context, authErrorText(context, error.code));
    } catch (_) {
      if (mounted)
        showAuthMessage(context, authText(context, 'genericAuthError'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _socialUnavailable() =>
      showAuthMessage(context, authText(context, 'socialUnavailable'));

  @override
  Widget build(BuildContext context) => AuthShell(
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthBrandHeader(),
          const SizedBox(height: 20),
          AuthTitle(title: authText(context, 'createAccount')),
          const SizedBox(height: 21),
          AuthTextField(
            controller: _nameController,
            hint: authText(context, 'fullName'),
            icon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            validator: _validateName,
          ),
          const SizedBox(height: 11),
          AuthTextField(
            controller: _emailController,
            hint: authText(context, 'email'),
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: _validateEmail,
          ),
          const SizedBox(height: 11),
          AuthTextField(
            controller: _passwordController,
            hint: authText(context, 'password'),
            icon: Icons.lock_outline_rounded,
            obscureText: !_showPassword,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            validator: _validatePassword,
            suffixIcon: IconButton(
              onPressed: () => setState(() => _showPassword = !_showPassword),
              icon: Icon(
                _showPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF6C8EAF),
                size: 19,
              ),
            ),
          ),
          const SizedBox(height: 11),
          AuthTextField(
            controller: _confirmController,
            hint: authText(context, 'confirmPassword'),
            icon: Icons.verified_user_outlined,
            obscureText: !_showConfirm,
            textInputAction: TextInputAction.done,
            validator: _validateConfirm,
            suffixIcon: IconButton(
              onPressed: () => setState(() => _showConfirm = !_showConfirm),
              icon: Icon(
                _showConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF6C8EAF),
                size: 19,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 32,
                height: 35,
                child: Checkbox(
                  value: _acceptedTerms,
                  onChanged: (value) =>
                      setState(() => _acceptedTerms = value ?? false),
                  activeColor: deglitchBlue,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    authText(context, 'agreeTerms'),
                    style: const TextStyle(
                      color: Color(0xFF6986A7),
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AuthPrimaryButton(
            label: authText(context, _loading ? 'creatingAccount' : 'signUp'),
            onPressed: _submit,
            loading: _loading,
          ),
          const SizedBox(height: 21),
          AuthSocialButtons(onUnavailable: _socialUnavailable),
          const SizedBox(height: 13),
          AuthFooterLink(
            lead: authText(context, 'alreadyHaveAccount'),
            action: authText(context, 'signIn'),
            onTap: () => context.go('/sign-in'),
          ),
        ],
      ),
    ),
  );
}
