import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import '../../services/local_persistence_service.dart';

/// Onboarding Flow (OnboardingFlow)
/// Implements Prompt 13 Application Entry Flow:
/// Slide 0: Language Selection (First Launch Only) with GoI Tagline
/// Slide 1: Welcome Page 1 — "Report Development Needs with AI."
/// Slide 2: Welcome Page 2 — "Track Projects Transparently."
/// Slide 3: Welcome Page 3 — "Build Better Communities Together."
class OnboardingFlow extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingFlow({super.key, required this.onComplete});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'native': 'English', 'code': 'EN', 'flag': '🌐'},
    {'name': 'Gujarati', 'native': 'ગુજરાતી', 'code': 'GU', 'flag': '🇮🇳'},
    {'name': 'Hindi', 'native': 'હિન્દી', 'code': 'HI', 'flag': '🇮🇳'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = LocalPersistenceService.selectedLanguage;
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    await LocalPersistenceService.completeOnboarding(_selectedLanguage);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Scaffold(
      backgroundColor: JanSetuColors.slateNavy,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // Top Brand Header & Skip Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: JanSetuColors.electricBlue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: JanSetuColors.electricBlue),
                          ),
                          child: const Icon(Icons.hub_rounded, color: JanSetuColors.electricBlue, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'JanSetu AI',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: JanSetuColors.saffronGold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'v2.4 ENTERPRISE',
                            style: TextStyle(color: JanSetuColors.saffronGold, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    if (_currentPage < 3)
                      TextButton(
                        onPressed: _finishOnboarding,
                        child: const Text('Skip to Login →', style: TextStyle(color: JanSetuColors.darkTextSecondary)),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Main PageView Slides
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    children: [
                      _buildLanguageSlide(isWide),
                      _buildWelcomePage1(isWide),
                      _buildWelcomePage2(isWide),
                      _buildWelcomePage3(isWide),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Bottom Pagination Dots & Next Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(4, (idx) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          height: 6,
                          width: _currentPage == idx ? 24 : 6,
                          decoration: BoxDecoration(
                            color: _currentPage == idx ? JanSetuColors.electricBlue : JanSetuColors.darkBorder,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                    ElevatedButton.icon(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == 3 ? JanSetuColors.emeraldGreen : JanSetuColors.electricBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                      ),
                      icon: Icon(_currentPage == 3 ? Icons.check_circle_rounded : Icons.arrow_forward_rounded, size: 18),
                      label: Text(
                        _currentPage == 3 ? 'Get Started' : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSlide(bool isWide) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_rounded, size: isWide ? 64 : 48, color: JanSetuColors.saffronGold),
          const SizedBox(height: 12),
          Text(
            'AI Should Think.\nHumans Should Decide.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? 26 : 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.translate_rounded, size: 40, color: JanSetuColors.electricBlue),
          const SizedBox(height: 12),
          const Text(
            'Select Your Preferred Language\nતમારી પસંદગીની ભાષા પસંદ કરો',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'JanSetu AI translates voice and text across 22 Scheduled Indian dialects automatically.',
            textAlign: TextAlign.center,
            style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Column(
            children: _languages.map((lang) {
              final isSelected = _selectedLanguage == lang['name'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedLanguage = lang['name']!);
                    LocalPersistenceService.setLanguage(lang['name']!);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? JanSetuColors.electricBlue.withValues(alpha: 0.2) : JanSetuColors.darkSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? JanSetuColors.electricBlue : JanSetuColors.darkBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(lang['flag']!, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang['native']!,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : JanSetuColors.darkTextPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                lang['name']!,
                                style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: JanSetuColors.electricBlue)
                        else
                          const Icon(Icons.circle_outlined, color: JanSetuColors.darkBorder),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage1(bool isWide) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mic_rounded, size: 64, color: JanSetuColors.emeraldGreen),
          const SizedBox(height: 24),
          const Text(
            'Report Development Needs with AI.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildBulletPoint(
            Icons.record_voice_over_rounded,
            'Voice or Photo Grievances',
            'Report potholes, broken streetlights, or water shortages in 10 seconds without typing in any dialect.',
          ),
          _buildBulletPoint(
            Icons.route_rounded,
            'Automated Spatial Lineage Routing',
            'Gemini 2.5 Pro identifies GPS coordinates and routes your issue to the correct 11-tier ward officer.',
          ),
          _buildBulletPoint(
            Icons.verified_rounded,
            'Zero Bureaucracy Intake',
            'Citizens never need to understand complicated government departments or long bureaucratic forms.',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage2(bool isWide) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_balance_rounded, size: 64, color: JanSetuColors.saffronGold),
          const SizedBox(height: 24),
          const Text(
            'Track Projects Transparently.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildBulletPoint(
            Icons.analytics_rounded,
            'Universal Digital Twin',
            'Every ward in Gujarat has a living 15-parameter development score updated via real-time feedback.',
          ),
          _buildBulletPoint(
            Icons.verified_user_rounded,
            'MPLADS 1-Tap Sanctioning',
            'Members of Parliament evaluate AI priority queues and sanction ₹50+ Lakh capital works instantly.',
          ),
          _buildBulletPoint(
            Icons.lock_clock_rounded,
            'PFMS Smart Escrow Assurance',
            'Funds are released in 3 milestone tranches only after geo-tagged photographic inspection by state engineers.',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage3(bool isWide) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.groups_rounded, size: 64, color: JanSetuColors.electricBlue),
          const SizedBox(height: 24),
          const Text(
            'Build Better Communities Together.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildBulletPoint(
            Icons.thumb_up_alt_rounded,
            'LinkedIn-Style Community Corroboration',
            'Neighbors upvote and corroborate local grievances to increase priority velocity for MP sanctioning.',
          ),
          _buildBulletPoint(
            Icons.sentiment_very_satisfied_rounded,
            'Living Development Scores',
            'Participate in local governance and watch your constituency\'s infrastructure health score improve in real time.',
          ),
          _buildBulletPoint(
            Icons.security_rounded,
            'Zero-Trust Security Gateway',
            'Government of India e-Pramaan integrated cryptographic architecture ensures absolute data privacy and integrity.',
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: JanSetuColors.darkSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: JanSetuColors.darkBorder),
            ),
            child: Icon(icon, color: JanSetuColors.electricBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
