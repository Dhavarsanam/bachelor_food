import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  Constants
// ─────────────────────────────────────────────
const _kOrange = Color(0xFFFF6B2C);
const _kOrangeLight = Color(0xFFFFF0EB);
const _kOrangeDark = Color(0xFFE84C0B);
const _kTextDark = Color(0xFF1A1A1A);
const _kTextMid = Color(0xFF6B6B6B);
const _kTextLight = Color(0xFFB0B0B0);
const _kBorder = Color(0xFFE8E8E8);
const _kShadow = Color(0x14000000);

// ─────────────────────────────────────────────
//  LoginScreen
// ─────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _mobileCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _mobileFocus = FocusNode();
  final _otpFocus = FocusNode();

  bool _showOtp = false;
  bool _isLoadingMobile = false;
  bool _isLoadingOtp = false;
  String? _mobileError;
  String? _otpError;
  String _maskedNumber = '';

  late final AnimationController _otpSlideCtrl;
  late final Animation<Offset> _otpSlideAnim;
  late final Animation<double> _otpFadeAnim;

  late final AnimationController _successCtrl;
  late final Animation<double> _successAnim;

  @override
  void initState() {
    super.initState();

    _otpSlideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _otpSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _otpSlideCtrl, curve: Curves.easeOutCubic));
    _otpFadeAnim =
        CurvedAnimation(parent: _otpSlideCtrl, curve: Curves.easeOut);

    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _successAnim =
        CurvedAnimation(parent: _successCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _otpCtrl.dispose();
    _mobileFocus.dispose();
    _otpFocus.dispose();
    _otpSlideCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  // ── Validation ──────────────────────────────
  bool _validateMobile() {
    final raw = _mobileCtrl.text.trim();
    if (raw.isEmpty) {
      setState(() => _mobileError = 'Please enter your mobile number.');
      return false;
    }
    if (raw.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(raw)) {
      setState(() => _mobileError = 'Enter a valid 10-digit mobile number.');
      return false;
    }
    setState(() => _mobileError = null);
    return true;
  }

  bool _validateOtp() {
    final otp = _otpCtrl.text.trim();
    if (otp.length != 6) {
      setState(() => _otpError = 'Enter the 6-digit OTP.');
      return false;
    }
    setState(() => _otpError = null);
    return true;
  }

  // ── Actions ─────────────────────────────────
  Future<void> _onContinue() async {
    if (!_validateMobile()) return;

    setState(() => _isLoadingMobile = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    final number = _mobileCtrl.text.trim();
    _maskedNumber =
    '+91 ${number.substring(0, 2)}****${number.substring(6)}';

    setState(() {
      _isLoadingMobile = false;
      _showOtp = true;
    });

    _otpSlideCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 120));
    if (mounted) FocusScope.of(context).requestFocus(_otpFocus);
  }

  // ✅ UPDATED: async gap fix + correct navigation
  Future<void> _onVerifyOtp() async {
    if (!_validateOtp()) return;

    setState(() => _isLoadingOtp = true);
    await Future.delayed(const Duration(milliseconds: 1400));

    if (_otpCtrl.text.trim() == '000000') {
      setState(() {
        _isLoadingOtp = false;
        _otpError = 'Incorrect OTP. Please try again.';
      });
      return;
    }

    _successCtrl.forward();
    setState(() => _isLoadingOtp = false);

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final navigator = Navigator.of(context);
    navigator.pushReplacementNamed('/dashboard');
  }

  void _onChangeNumber() {
    setState(() {
      _showOtp = false;
      _otpCtrl.clear();
      _otpError = null;
    });
    _otpSlideCtrl.reset();
    _successCtrl.reset();
    FocusScope.of(context).requestFocus(_mobileFocus);
  }

  // ─────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 36),
                _buildLogo(),
                const SizedBox(height: 40),
                _buildCard(),
                const SizedBox(height: 32),
                _buildFooterNote(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── AppBar ───────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _kOrange,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'B',
                style: TextStyle(
                  color: _kOrange,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Bachelor Foods',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: _kOrange,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  // ── Logo block ───────────────────────────────
  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _kOrange.withValues(alpha: 0.30),
                blurRadius: 28,
                spreadRadius: 2,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF8C42), _kOrangeDark],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 44,
                        height: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Bachelor Foods',
          style: TextStyle(
            color: _kTextDark,
            fontWeight: FontWeight.w800,
            fontSize: 26,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your favorite meals, delivered fast.',
          style: TextStyle(
            color: _kTextMid,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  // ── Main card ────────────────────────────────
  Widget _buildCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          const BoxShadow(
              color: _kShadow,
              blurRadius: 24,
              offset: Offset(0, 8)),
          BoxShadow(
            color: _kOrange.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: _kBorder, width: 1),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(),
          const SizedBox(height: 24),
          _buildMobileField(),
          if (_mobileError != null) ...[
            const SizedBox(height: 8),
            _buildErrorText(_mobileError!),
          ],
          const SizedBox(height: 20),
          if (_showOtp) ...[
            FadeTransition(
              opacity: _otpFadeAnim,
              child: SlideTransition(
                position: _otpSlideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOtpHeader(),
                    const SizedBox(height: 14),
                    _buildOtpField(),
                    if (_otpError != null) ...[
                      const SizedBox(height: 8),
                      _buildErrorText(_otpError!),
                    ],
                    const SizedBox(height: 20),
                    _buildVerifyButton(),
                    const SizedBox(height: 16),
                    _buildResendRow(),
                  ],
                ),
              ),
            ),
          ] else ...[
            _buildContinueButton(),
          ],
        ],
      ),
    );
  }

  // ── Card header ──────────────────────────────
  Widget _buildCardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _kOrangeLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Login / Sign up',
            style: TextStyle(
              color: _kOrange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _showOtp ? 'Verify your number' : 'Enter your mobile number',
          style: const TextStyle(
            color: _kTextDark,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _showOtp
              ? 'We sent a 6-digit OTP to $_maskedNumber'
              : 'We\'ll send you a one-time verification code.',
          style: const TextStyle(
            color: _kTextMid,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ── Mobile field ─────────────────────────────
  Widget _buildMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile Number',
          style: TextStyle(
            color: _kTextDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _mobileCtrl,
          focusNode: _mobileFocus,
          enabled: !_showOtp,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onChanged: (_) {
            if (_mobileError != null) setState(() => _mobileError = null);
          },
          style: const TextStyle(
            color: _kTextDark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
          decoration: InputDecoration(
            hintText: '98765 43210',
            hintStyle: const TextStyle(
              color: _kTextLight,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  const Text(
                    '+91',
                    style: TextStyle(
                      color: _kTextDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(width: 1, height: 22, color: _kBorder),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            suffixIcon: _showOtp
                ? GestureDetector(
              onTap: _onChangeNumber,
              child: const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: _kOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            )
                : null,
            suffixIconConstraints:
            const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: _showOtp ? const Color(0xFFF9F9F9) : Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kBorder),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  // ── OTP header ───────────────────────────────
  Widget _buildOtpHeader() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _kBorder)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Enter OTP',
            style: TextStyle(
              color: _kTextLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: _kBorder)),
      ],
    );
  }

  // ── OTP field ────────────────────────────────
  Widget _buildOtpField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'One-Time Password',
          style: TextStyle(
            color: _kTextDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _otpCtrl,
          focusNode: _otpFocus,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (_) {
            if (_otpError != null) setState(() => _otpError = null);
          },
          style: const TextStyle(
            color: _kTextDark,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 8,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '• • • • • •',
            hintStyle: const TextStyle(
              color: _kTextLight,
              fontSize: 18,
              letterSpacing: 6,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: _kOrangeLight,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              const BorderSide(color: Color(0xFFFFD4C2), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _kOrange, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // ── Continue button ──────────────────────────
  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoadingMobile ? null : _onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kOrange,
          disabledBackgroundColor: _kOrange.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isLoadingMobile
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
              'Continue',
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

  // ── Verify button ────────────────────────────
  Widget _buildVerifyButton() {
    return ScaleTransition(
      scale: _successAnim.drive(
        Tween(begin: 1.0, end: 0.96)
            .chain(CurveTween(curve: Curves.easeIn)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isLoadingOtp ? null : _onVerifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: _kOrange,
            disabledBackgroundColor: _kOrange.withValues(alpha: 0.6),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: _kOrange.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isLoadingOtp
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
              Icon(Icons.verified_rounded, size: 20),
              SizedBox(width: 8),
              Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Resend row ───────────────────────────────
  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't receive the OTP? ",
          style: TextStyle(color: _kTextMid, fontSize: 13),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('OTP resent!'),
                backgroundColor: _kOrange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: const Text(
            'Resend',
            style: TextStyle(
              color: _kOrange,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ── Error text ───────────────────────────────
  Widget _buildErrorText(String message) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded,
            color: Colors.redAccent, size: 14),
        const SizedBox(width: 5),
        Text(
          message,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Footer note ──────────────────────────────
  Widget _buildFooterNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(color: _kTextLight, fontSize: 12.5, height: 1.5),
          children: [
            TextSpan(text: 'By continuing, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                color: _kOrange,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: _kOrange,
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: _kOrange,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: _kOrange,
              ),
            ),
            TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}