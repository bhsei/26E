import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/deglitch_brand.dart';
import 'auth_components.dart';
import 'auth_copy.dart';

class MobileSignInScreen extends StatefulWidget {
  const MobileSignInScreen({super.key});
  @override
  State<MobileSignInScreen> createState() => _MobileSignInScreenState();
}

class _MobileSignInScreenState extends State<MobileSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _rememberEmail = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _restoreRememberedEmail();
  }

  Future<void> _restoreRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getString('deglitch_remembered_email');
    if (!mounted || remembered == null || remembered.isEmpty) return;
    setState(() {
      _emailController.text = remembered;
      _rememberEmail = true;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return authText(context, 'enterEmail');
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))
      return authText(context, 'invalidEmail');
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _loading) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final prefs = await SharedPreferences.getInstance();
      if (_rememberEmail) {
        await prefs.setString(
          'deglitch_remembered_email',
          _emailController.text.trim(),
        );
      } else {
        await prefs.remove('deglitch_remembered_email');
      }
      if (!mounted) return;
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
          const SizedBox(height: 24),
          AuthTitle(
            title: authText(context, 'welcomeBack'),
            subtitle: authText(context, 'loginSubtitle'),
          ),
          const SizedBox(height: 27),
          AuthTextField(
            controller: _emailController,
            hint: authText(context, 'email'),
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email, AutofillHints.username],
            validator: _validateEmail,
          ),
          const SizedBox(height: 13),
          AuthTextField(
            controller: _passwordController,
            hint: authText(context, 'password'),
            icon: Icons.lock_outline_rounded,
            obscureText: !_showPassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            validator: (value) => (value == null || value.isEmpty)
                ? authText(context, 'enterPassword')
                : null,
            suffixIcon: IconButton(
              tooltip: _showPassword ? 'Hide password' : 'Show password',
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
          const SizedBox(height: 7),
          Row(
            children: [
              SizedBox(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _rememberEmail,
                      onChanged: (value) =>
                          setState(() => _rememberEmail = value ?? false),
                      activeColor: deglitchBlue,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      authText(context, 'rememberMe'),
                      style: const TextStyle(
                        color: Color(0xFF6986A7),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/forgot-password'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  authText(context, 'forgotPassword'),
                  style: const TextStyle(
                    color: deglitchBlue,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AuthPrimaryButton(
            label: authText(context, _loading ? 'signingIn' : 'signIn'),
            onPressed: _submit,
            loading: _loading,
          ),
          const SizedBox(height: 24),
          AuthSocialButtons(onUnavailable: _socialUnavailable),
          const SizedBox(height: 18),
          AuthFooterLink(
            lead: authText(context, 'noAccount'),
            action: authText(context, 'createAccount'),
            onTap: () => context.go('/sign-up'),
          ),
        ],
      ),
    ),
  );
}
