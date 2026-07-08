import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';

/// JanSetu AI — Premium Enterprise Splash Screen
/// Implements Prompt 13 specifications: GoI inspired branding, National e-Pramaan seal,
/// Tagline ("AI should think. Humans should decide."), App Version v2.4, smooth fade animation, and auto-navigation.
class JanSetuSplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const JanSetuSplashScreen({super.key, required this.onFinish});

  @override
  State<JanSetuSplashScreen> createState() => _JanSetuSplashScreenState();
}

class _JanSetuSplashScreenState extends State<JanSetuSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();

    // Automatically navigate after 1.4 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JanSetuColors.slateNavy,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(JanSetuTheme.space32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Top National Emblem / e-Pramaan Seal
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: JanSetuColors.saffronGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: JanSetuColors.saffronGold.withValues(alpha: 0.6)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded, color: JanSetuColors.saffronGold, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'GOVERNMENT OF INDIA e-PRAMAAN INTEGRATED GATEWAY',
                          style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  
                  // Main JanSetu AI Logo & Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: JanSetuColors.electricBlue, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: JanSetuColors.electricBlue.withValues(alpha: 0.3),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.hub_rounded,
                      color: JanSetuColors.electricBlue,
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  const Text(
                    'JanSetu AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Tagline
                  const Text(
                    'AI should think. Humans should decide.',
                    style: TextStyle(
                      color: JanSetuColors.electricBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Universal Multimodal Digital Governance Ecosystem',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(),
                  
                  // Loading Progress Indicator
                  const SizedBox(
                    width: 180,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(JanSetuColors.saffronGold),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // App Version Footer
                  const Text(
                    'v2.4 (Enterprise Edition — Build 2026.07)',
                    style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Secured by Zero-Trust RBAC Architecture',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
