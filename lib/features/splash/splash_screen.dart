import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;
  late final AnimationController _progressCtrl;
  late final Animation<double> _progressAnim;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _particleCtrl;

  static const _splashDuration = Duration(seconds: 6);
  static const _orange = Color(0xFFFF6B2C);

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);

    _progressCtrl =
        AnimationController(vsync: this, duration: _splashDuration);
    _progressAnim =
        CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut);

    _shimmerCtrl =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();

    _particleCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();

    _startSequence();
  }

  Future<void> _startSequence() async {
    _fadeCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleCtrl.forward();
    _progressCtrl.forward();

    await Future.delayed(_splashDuration);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scaleCtrl.dispose();
    _progressCtrl.dispose();
    _shimmerCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            _buildDecorativeCircles(size),
            AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) => _buildParticles(size),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  ScaleTransition(
                    scale: _scaleAnim,
                    child: _buildLogoCard(),
                  ),

                  const SizedBox(height: 36),

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _buildTextBlock(),
                  ),

                  const Spacer(flex: 3),

                  _buildLoadingSection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF8C42),
            Color(0xFFFF6B2C),
            Color(0xFFD94A08),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircles(Size size) {
    return Stack(
      children: [
        Positioned(
          top: -size.width * 0.25,
          right: -size.width * 0.2,
          child: _glowCircle(size.width * 0.7, const Color(0xFFFFD180), 0.18),
        ),
        Positioned(
          bottom: size.height * 0.12,
          left: -size.width * 0.3,
          child: _glowCircle(size.width * 0.75, const Color(0xFFC0390B), 0.22),
        ),
      ],
    );
  }

  Widget _glowCircle(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }

  Widget _buildParticles(Size size) {
    final items = [
      (emoji: '🍕', x: 0.1),
      (emoji: '🍔', x: 0.8),
      (emoji: '🍜', x: 0.2),
      (emoji: '🥗', x: 0.6),
    ];

    return Stack(
      children: items.map((p) {
        final t = _particleCtrl.value;
        return Positioned(
          left: p.x * size.width,
          top: (1 - t) * size.height,
          child: Opacity(
            opacity: 0.5,
            child: Text(p.emoji, style: const TextStyle(fontSize: 20)),
          ),
        );
      }).toList(),
    );
  }

  // ✅ UPDATED: Circle badge removed, logo displayed directly in white card
  Widget _buildLogoCard() {
    return Container(
      width: 148,
      height: 148,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTextBlock() {
    return const Column(
      children: [
        Text(
          'Bachelor Food',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Your favorite meals, delivered fast.',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          const Text(
            'FINDING THE BEST FLAVORS NEAR YOU...',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 12),

          AnimatedBuilder(
            animation: _progressAnim,
            builder: (_, __) {
              return LinearProgressIndicator(
                value: _progressAnim.value,
                backgroundColor: Colors.white24,
                color: Colors.white,
                minHeight: 6,
              );
            },
          ),
        ],
      ),
    );
  }
}