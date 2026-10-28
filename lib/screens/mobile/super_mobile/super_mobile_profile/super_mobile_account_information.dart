import 'package:de_glitch/screens/mobile/super_mobile/super_mobile_profile/super_mobile_settings_components.dart';
import 'package:flutter/material.dart';

@immutable
class AccountInformationData {
  const AccountInformationData({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.country,
  });

  final String fullName;
  final String email;
  final String phone;
  final String country;
}

/// Account details editor. Pass [onSave] to persist changes to your account API.
class SuperMobileAccountInformation extends StatefulWidget {
  const SuperMobileAccountInformation({
    super.key,
    this.initialName = 'Elijah Fullah',
    this.initialEmail = 'elijah@example.com',
    this.initialPhone = '',
    this.initialCountry = 'Sierra Leone',
    this.onSave,
    this.onChangePassword,
  });

  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialCountry;
  final Future<void> Function(AccountInformationData data)? onSave;
  final VoidCallback? onChangePassword;

  @override
  State<SuperMobileAccountInformation> createState() =>
      _SuperMobileAccountInformationState();
}

class _SuperMobileAccountInformationState
    extends State<SuperMobileAccountInformation> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late String _country;
  bool _saving = false;

  static const _countries = <String>[
    'Sierra Leone',
    'China',
    'Japan',
    'Singapore',
    'United States',
    'United Kingdom',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
    _email = TextEditingController(text: widget.initialEmail);
    _phone = TextEditingController(text: widget.initialPhone);
    _country = widget.initialCountry;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? 'Enter your $label.' : null;

  String? _emailValidator(String? value) {
    final required = _required(value, 'email address');
    if (required != null) return required;
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    final data = AccountInformationData(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      country: _country,
    );
    setState(() => _saving = true);
    try {
      await widget.onSave?.call(data);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      dgShowMessage(
        context,
        widget.onSave == null
            ? 'Changes validated. Connect account storage to save them permanently.'
            : 'Account information saved.',
      );
    } catch (error) {
      if (mounted)
        dgShowMessage(context, 'Could not save account information: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DgPageScaffold(
      title: 'Account Information',
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const DgPanel(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: DgColors.paleBlue,
                    child: Icon(
                      Icons.person_rounded,
                      color: DgColors.blue,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your account',
                          style: TextStyle(
                            color: DgColors.deepBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Keep your contact details up to date.',
                          style: TextStyle(
                            color: DgColors.mutedBlue,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DgSectionHeading('Personal details'),
            _input(
              'Full name',
              _name,
              icon: Icons.badge_outlined,
              validator: (v) => _required(v, 'full name'),
            ),
            const SizedBox(height: 12),
            _input(
              'Email address',
              _email,
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            const SizedBox(height: 12),
            _input(
              'Phone number (optional)',
              _phone,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const DgSectionHeading('Region'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: DgColors.line),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _countries.contains(_country) ? _country : 'Other',
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: DgColors.mutedBlue,
                  ),
                  items: _countries
                      .map(
                        (country) => DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _country = value);
                  },
                ),
              ),
            ),
            const DgSectionHeading('Sign-in and security'),
            DgPanel(
              padding: EdgeInsets.zero,
              child: DgSettingsTile(
                icon: Icons.lock_outline_rounded,
                title: 'Change password',
                subtitle: 'Update your sign-in credentials',
                onTap: () => widget.onChangePassword != null
                    ? widget.onChangePassword!()
                    : dgShowMessage(
                        context,
                        'Connect this action to your authentication flow.',
                      ),
              ),
            ),
            const SizedBox(height: 18),
            DgPrimaryButton(
              label: 'Save changes',
              icon: Icons.save_outlined,
              isLoading: _saving,
              onPressed: _save,
            ),
            const SizedBox(height: 8),
            const Text(
              'Changes are stored only when an account persistence callback is connected.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DgColors.mutedBlue,
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: DgColors.mutedBlue, size: 21),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: DgColors.mutedBlue, fontSize: 13),
        errorStyle: const TextStyle(fontSize: 11),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: DgColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: DgColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: DgColors.blue, width: 1.5),
        ),
      ),
    );
  }
}
