import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  Constants
// ─────────────────────────────────────────────
const _kOrange = Color(0xFFFF6B2C);
const _kOrangeDark = Color(0xFFE84C0B);
const _kOrangeLight = Color(0xFFFFF0EB);
const _kTextDark = Color(0xFF1A1A1A);
const _kTextMid = Color(0xFF6B6B6B);
const _kTextLight = Color(0xFFB0B0B0);
const _kBorder = Color(0xFFE8E8E8);
const _kSuccess = Color(0xFF4CAF50);

// ─────────────────────────────────────────────
//  CreateAccountScreen
// ─────────────────────────────────────────────
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool _isLoading = false;
  String? _nameError;
  String? _emailError;
  String? _phoneNumber;

  @override
  void initState() {
    super.initState();
    // Get phone number from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        setState(() {
          _phoneNumber = args;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  // ── Validation ──────────────────────────────
  bool _validateName() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Please enter your full name.');
      return false;
    }
    if (name.length < 3) {
      setState(() => _nameError = 'Name must be at least 3 characters.');
      return false;
    }
    setState(() => _nameError = null);
    return true;
  }

  bool _validateEmail() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'Please enter your email address.');
      return false;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Enter a valid email address.');
      return false;
    }
    setState(() => _emailError = null);
    return true;
  }

  // ── Create Account ──────────────────────────
  Future<void> _onCreateAccount() async {
    final isNameValid = _validateName();
    final isEmailValid = _validateEmail();

    if (!isNameValid || !isEmailValid) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully!'),
        backgroundColor: _kSuccess,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // Navigate to dashboard
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  // ─────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textPrimary = isDark ? Colors.white : _kTextDark;
    final textSecondary = isDark ? const Color(0xFF999999) : _kTextMid;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: _kOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: _kOrange,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(textPrimary, textSecondary),
                const SizedBox(height: 32),

                // Form Section
                _buildForm(textPrimary),
                const SizedBox(height: 32),

                // Create Account Button
                _buildCreateButton(),
                const SizedBox(height: 24),

                // Terms & Conditions
                _buildTermsText(textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _kOrangeLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              '👤',
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Complete Your Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _phoneNumber != null
              ? 'Creating account for +91 $_phoneNumber'
              : 'Tell us about yourself to get started',
          style: TextStyle(
            fontSize: 14,
            color: textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(Color textPrimary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        Text(
          'Full Name',
          style: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameCtrl,
          focusNode: _nameFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            _validateName();
            FocusScope.of(context).requestFocus(_emailFocus);
          },
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
          style: TextStyle(
            color: textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            hintStyle: TextStyle(color: _kTextLight, fontSize: 14),
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 22),
            filled: true,
            fillColor: isDark(context) ? const Color(0xFF1E1E1E) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kOrange, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            errorText: _nameError,
          ),
        ),

        const SizedBox(height: 20),

        // Email Field
        Text(
          'Email Address',
          style: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailCtrl,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onEditingComplete: _onCreateAccount,
          onChanged: (_) {
            if (_emailError != null) setState(() => _emailError = null);
          },
          style: TextStyle(
            color: textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            hintStyle: TextStyle(color: _kTextLight, fontSize: 14),
            prefixIcon: const Icon(Icons.email_outlined, size: 22),
            filled: true,
            fillColor: isDark(context) ? const Color(0xFF1E1E1E) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kOrange, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            errorText: _emailError,
          ),
        ),

        const SizedBox(height: 16),

        // Phone Number Display (Readonly)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _kOrangeLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kOrange.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _kOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.phone_android_rounded, color: _kOrange, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mobile Number',
                      style: TextStyle(
                        fontSize: 12,
                        color: _kTextMid,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _phoneNumber != null ? '+91 $_phoneNumber' : 'Not provided',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _kTextDark,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.verified_rounded, color: _kSuccess, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onCreateAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kOrange,
          disabledBackgroundColor: _kOrange.withOpacity(0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsText(Color textSecondary) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: textSecondary,
            fontSize: 12,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'By creating an account, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: const TextStyle(
                color: _kOrange,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: _kOrange,
              ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                color: _kOrange,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: _kOrange,
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }

  // Helper function to check if dark mode is enabled
  bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}