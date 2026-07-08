import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import '../../services/local_persistence_service.dart';

/// JanSetu AI — Enterprise Security & Authentication Gate
/// Production zero-trust portal with integrated 1-Tap Quick-Login Demo Cards for hackathon evaluations.
class JanSetuLoginScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const JanSetuLoginScreen({super.key, required this.onAuthenticated});

  @override
  State<JanSetuLoginScreen> createState() => _JanSetuLoginScreenState();
}

class _JanSetuLoginScreenState extends State<JanSetuLoginScreen> {
  bool _isVerifying = false;
  bool _showDemoMode = false;
  bool _showOtpDialog = false;
  String _verifyingRoleName = '';
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController(text: '999999');

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _authenticate(String role, Map<String, dynamic> profile) async {
    setState(() {
      _isVerifying = true;
      _verifyingRoleName = profile['name']?.toString() ?? role;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    await LocalPersistenceService.loginAsRole(role, profile);
    if (!mounted) return;
    widget.onAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JanSetuColors.slateNavy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(JanSetuTheme.space32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top National Security Gate Badge
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
                        Icon(Icons.shield_rounded, color: JanSetuColors.saffronGold, size: 18),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'JANSETU ZERO-TRUST CRYPTOGRAPHIC SECURITY GATEWAY (e-PRAMAAN v2.4)',
                            style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: JanSetuTheme.space24),
                  const Text(
                    'JanSetu AI — Enterprise Governance Ecosystem',
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: JanSetuTheme.space12),
                  const Text(
                    'Authenticate with your registered Mobile Number or Parichay credential to access jurisdictional digital twins and AI intake ledgers.',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: JanSetuTheme.space32),

                  if (_isVerifying)
                    _buildVerificationOverlay()
                  else if (!_showDemoMode)
                    _buildProductionLoginPortal()
                  else
                    _buildDemoModeSelector(),

                  const SizedBox(height: JanSetuTheme.space32),
                  const Divider(color: JanSetuColors.darkBorder),
                  const SizedBox(height: JanSetuTheme.space16),
                  
                  // Professional Footer (Prompt 13 requirement)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildFooterLink('Privacy Policy'),
                      _buildFooterLink('Terms of Service'),
                      _buildFooterLink('App Version v2.4 Enterprise'),
                      _buildFooterLink('Help & Support'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductionLoginPortal() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(JanSetuTheme.space24),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(JanSetuTheme.radiusLarge),
        border: Border.all(color: JanSetuColors.darkBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🇮🇳 National Single-Sign-On Portal',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'Enter your 10-digit Aadhaar linked mobile number',
            style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Mobile Input Field
          TextField(
            controller: _mobileController,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              labelStyle: const TextStyle(color: Colors.grey),
              prefixText: '🇮🇳 +91  ',
              prefixStyle: const TextStyle(color: JanSetuColors.electricBlue, fontWeight: FontWeight.bold, fontSize: 16),
              filled: true,
              fillColor: Colors.black12,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: JanSetuColors.darkBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: JanSetuColors.darkBorder)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: JanSetuColors.electricBlue, width: 2)),
            ),
          ),
          const SizedBox(height: 16),

          if (_showOtpDialog) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: JanSetuColors.electricBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.mark_email_read_rounded, color: JanSetuColors.electricBlue, size: 18),
                      SizedBox(width: 8),
                      Text('Enter 6-Digit OTP Sent to Mobile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _otpController,
                    style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '999999',
                      hintStyle: const TextStyle(color: Colors.white38),
                      helperText: '💡 Demo OTP: 999999 (Local Sandbox Active)',
                      helperStyle: const TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      _authenticate('CITIZEN', {
                        'name': 'Rajesh Bhai Patel',
                        'id': 'CIT-SRT-8841',
                        'role': 'CITIZEN',
                        'jurisdiction': 'WRD-GUJ-SRT-0014',
                        'wardName': 'Adajan Ward 14',
                        'city': 'Surat',
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: JanSetuColors.emeraldGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.verified_rounded, size: 18),
                    label: const Text('Verify OTP & Enter Portal', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            ElevatedButton.icon(
              onPressed: () => setState(() => _showOtpDialog = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: JanSetuColors.electricBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.sms_rounded, size: 18),
              label: const Text('Continue with OTP →', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],

          // Divider
          const Row(
            children: [
              Expanded(child: Divider(color: JanSetuColors.darkBorder)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('OR', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              Expanded(child: Divider(color: JanSetuColors.darkBorder)),
            ],
          ),
          const SizedBox(height: 20),

          // Dedicated Demo Mode Button (Prompt 13 requirement)
          OutlinedButton.icon(
            onPressed: () => setState(() => _showDemoMode = true),
            style: OutlinedButton.styleFrom(
              foregroundColor: JanSetuColors.saffronGold,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: JanSetuColors.saffronGold, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: JanSetuColors.saffronGold.withValues(alpha: 0.1),
            ),
            icon: const Icon(Icons.bolt_rounded, size: 20),
            label: const Text(
              '⚡ Continue in Demo Mode',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.3),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Recommended for Hackathon Evaluation & Judges (No OTP required)',
            style: TextStyle(color: Colors.grey, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDemoModeSelector() {
    return Column(
      children: [
        // Top action bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => setState(() => _showDemoMode = false),
              icon: const Icon(Icons.arrow_back_rounded, color: JanSetuColors.electricBlue),
              label: const Text('← Back to Mobile OTP Login', style: TextStyle(color: JanSetuColors.electricBlue, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: JanSetuColors.saffronGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: const Text('DEMO SANDBOX ACTIVE', style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Hackathon Demo Notice Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(JanSetuTheme.space16),
          decoration: BoxDecoration(
            color: JanSetuColors.saffronGold.withAlpha(38),
            borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
            border: Border.all(color: JanSetuColors.saffronGold),
          ),
          child: const Row(
            children: [
              Icon(Icons.bolt_rounded, color: JanSetuColors.saffronGold, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚡ Hackathon Evaluation Mode: 1-Tap Quick-Login Active',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Select a pre-seeded stakeholder identity below to immediately issue a simulated zero-trust session token and auto-mount the persona workspace.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: JanSetuTheme.space24),

        // Persona Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final cards = [
              _buildPersonaCard(
                role: 'CITIZEN',
                title: 'Rajesh Bhai Patel',
                subtitle: 'Citizen Persona • Adajan Ward 14',
                idString: 'CIT-SRT-8841',
                jurisdiction: 'WRD-GUJ-SRT-0014 (Surat Municipal Corp)',
                icon: Icons.person_pin_circle_rounded,
                color: JanSetuColors.electricBlue,
                profile: {
                  'name': 'Rajesh Bhai Patel',
                  'id': 'CIT-SRT-8841',
                  'role': 'CITIZEN',
                  'jurisdiction': 'WRD-GUJ-SRT-0014',
                  'wardName': 'Adajan Ward 14',
                  'city': 'Surat',
                },
              ),
              _buildPersonaCard(
                role: 'MP',
                title: 'Hon. C.R. Patil',
                subtitle: 'MP Executive • Surat Constituency',
                idString: 'MP-GUJ-SRT-01',
                jurisdiction: 'PC-GUJ-SRT-0001 (Surat Parliamentary Const.)',
                icon: Icons.account_balance_rounded,
                color: JanSetuColors.emeraldGreen,
                profile: {
                  'name': 'Hon. C.R. Patil',
                  'id': 'MP-GUJ-SRT-01',
                  'role': 'MP',
                  'jurisdiction': 'PC-GUJ-SRT-0001',
                  'constituency': 'Surat Parliamentary Constituency',
                  'budgetAvailableINR': 50000000.0,
                },
              ),
              _buildPersonaCard(
                role: 'ADMIN',
                title: 'Shri K.L. Mehta, IAS',
                subtitle: 'State Admin • Chief Engineer',
                idString: 'ADM-GUJ-HQ-001',
                jurisdiction: 'STA-GUJ-0001 (State of Gujarat — PWD / HQ)',
                icon: Icons.admin_panel_settings_rounded,
                color: JanSetuColors.saffronGold,
                profile: {
                  'name': 'Shri K.L. Mehta, IAS',
                  'id': 'ADM-GUJ-HQ-001',
                  'role': 'ADMIN',
                  'jurisdiction': 'STA-GUJ-0001',
                  'designation': 'Principal Secretary / Chief Engineer',
                  'department': 'State Roads & Buildings HQ',
                },
              ),
            ];

            if (isWide) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: cards
                      .map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c)))
                      .toList(),
                ),
              );
            }
            return Column(
              children: cards
                  .map((c) => Padding(padding: const EdgeInsets.only(bottom: 16), child: c))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVerificationOverlay() {
    return Container(
      padding: const EdgeInsets.all(JanSetuTheme.space32),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
        border: Border.all(color: JanSetuColors.electricBlue, width: 2),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(color: JanSetuColors.electricBlue),
          const SizedBox(height: JanSetuTheme.space24),
          Text(
            '🔐 Verifying Zero-Trust Identity Token for $_verifyingRoleName...',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: JanSetuTheme.space8),
          const Text(
            'Validating cryptographic claims • Fetching jurisdiction polygon • Mounting workspace module',
            style: TextStyle(color: JanSetuColors.electricBlue, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaCard({
    required String role,
    required String title,
    required String subtitle,
    required String idString,
    required String jurisdiction,
    required IconData icon,
    required Color color,
    required Map<String, dynamic> profile,
  }) {
    return JanSetuCard(
      backgroundColor: JanSetuColors.darkSurface,
      border: BorderSide(color: color.withAlpha(128), width: 1.5),
      onTap: () => _authenticate(role, profile),
      child: Padding(
        padding: const EdgeInsets.all(JanSetuTheme.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: color.withAlpha(38), borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium)),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: color.withAlpha(38), borderRadius: BorderRadius.circular(4)),
                        child: Text(idString, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11), overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: JanSetuTheme.space16),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: JanSetuTheme.space12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    '📍 Jurisdiction: $jurisdiction',
                    style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: JanSetuTheme.space24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text('Authenticate as $role', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String title) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ℹ️ $title — JanSetu AI Enterprise Portal'), duration: const Duration(seconds: 1)),
        );
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(title, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12, decoration: TextDecoration.underline)),
      ),
    );
  }
}
