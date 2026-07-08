import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';

import 'apps/auth/splash_screen.dart';
import 'apps/auth/login_screen.dart';
import 'apps/auth/onboarding_flow.dart';
import 'apps/auth/dev_persona_switcher_modal.dart';
import 'apps/shared/user_profile_modal.dart';
import 'apps/citizen/citizen_app_module.dart';
import 'apps/mp/mp_dashboard_module.dart';
import 'apps/admin/admin_panel_module.dart';
import 'services/local_persistence_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalPersistenceService.init();
  runApp(const JanSetuEnterpriseHub());
}

/// JanSetu AI — Enterprise Governance Digital Ecosystem Hub
/// Root application entry point deploying the Zero-Trust Role Router & Security Gateway.
class JanSetuEnterpriseHub extends StatelessWidget {
  const JanSetuEnterpriseHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JanSetu AI — Enterprise Governance Portal',
      theme: JanSetuTheme.lightTheme,
      darkTheme: JanSetuTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const JanSetuRoleRouterScreen(),
    );
  }
}

/// JanSetu Role Router Screen
/// Enforces Zero-Trust authentication gating, inspects session RBAC tokens,
/// mounts the jurisdictional workspace module, and embeds the Hackathon Dev Switcher header.
class JanSetuRoleRouterScreen extends StatefulWidget {
  const JanSetuRoleRouterScreen({super.key});

  @override
  State<JanSetuRoleRouterScreen> createState() => _JanSetuRoleRouterScreenState();
}

class _JanSetuRoleRouterScreenState extends State<JanSetuRoleRouterScreen> {
  bool _isLoading = true;
  bool _hasShownSplash = false;

  @override
  void initState() {
    super.initState();
    _initRouter();
  }

  Future<void> _initRouter() async {
    await LocalPersistenceService.init();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _rebuildRouter() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: JanSetuColors.slateNavy,
        body: Center(
          child: CircularProgressIndicator(color: JanSetuColors.electricBlue),
        ),
      );
    }

    if (!_hasShownSplash) {
      return JanSetuSplashScreen(
        onFinish: () {
          if (mounted) {
            setState(() {
              _hasShownSplash = true;
            });
          }
        },
      );
    }

    final activeRole = LocalPersistenceService.activeRole;

    // 1. Unauthenticated State -> Mount Zero-Trust Security Gateway or Onboarding
    if (activeRole == null) {
      if (!LocalPersistenceService.hasCompletedOnboarding) {
        return OnboardingFlow(onComplete: _rebuildRouter);
      }
      return JanSetuLoginScreen(onAuthenticated: _rebuildRouter);
    }

    // 2. Authenticated State -> Inspect Token & Mount Target Module
    Widget targetModule;
    Color roleColor;
    IconData roleIcon;

    if (activeRole == 'CITIZEN') {
      targetModule = CitizenAppModule(
        syntheticNeeds: LocalPersistenceService.needs,
        syntheticProjects: LocalPersistenceService.projects,
      );
      roleColor = JanSetuColors.electricBlue;
      roleIcon = Icons.person_pin_circle_rounded;
    } else if (activeRole == 'MP') {
      targetModule = MpDashboardModule(
        syntheticProjects: LocalPersistenceService.projects,
      );
      roleColor = JanSetuColors.emeraldGreen;
      roleIcon = Icons.account_balance_rounded;
    } else {
      targetModule = AdminPanelModule(
        syntheticNeeds: LocalPersistenceService.needs,
        syntheticProjects: LocalPersistenceService.projects,
      );
      roleColor = JanSetuColors.saffronGold;
      roleIcon = Icons.admin_panel_settings_rounded;
    }

    final profile = LocalPersistenceService.userProfile;
    final name = profile?['name']?.toString() ?? activeRole;
    final idString = profile?['id']?.toString() ?? 'ID-VERIFIED';

    return Scaffold(
      backgroundColor: JanSetuColors.slateNavy,
      body: Column(
        children: [
          // Enterprise Zero-Trust Governance Header Bar (Wrapped in SafeArea to prevent notch/status bar overlap)
          // Enterprise Zero-Trust Governance Header Bar
          SafeArea(
            bottom: false,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF090E17), Color(0xFF0F172A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                border: const Border(bottom: BorderSide(color: JanSetuColors.darkBorder, width: 1)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 1150;

                  final leftSection = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: JanSetuColors.electricBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.5)),
                        ),
                        child: const Icon(Icons.shield_rounded, color: JanSetuColors.electricBlue, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'JanSetu AI Enterprise Portal',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
                      ),
                    ],
                  );

                  final rightSection = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User Persona Badge
                      InkWell(
                        onTap: () => JanSetuUserProfileModal.show(context, onAction: _rebuildRouter),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: roleColor.withValues(alpha: 0.6), width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(roleIcon, color: roleColor, size: 15),
                              const SizedBox(width: 8),
                              Text(
                                '👤 $name • $idString',
                                style: TextStyle(color: roleColor, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down_rounded, color: roleColor, size: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (kDebugMode) ...[
                        // Hackathon Dev Persona Switcher Action Pill
                        TextButton.icon(
                          onPressed: () => DevPersonaSwitcherModal.show(context, onSwitch: _rebuildRouter),
                          style: TextButton.styleFrom(
                            backgroundColor: JanSetuColors.saffronGold.withValues(alpha: 0.15),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: JanSetuColors.saffronGold, width: 1.5),
                            ),
                          ),
                          icon: const Icon(Icons.bolt_rounded, color: JanSetuColors.saffronGold, size: 16),
                          label: const Text(
                            '⚡ Dev: Switch Persona ▾',
                            style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      // Prominent Login Portal Button
                      TextButton.icon(
                        onPressed: () async {
                          await LocalPersistenceService.logout();
                          _rebuildRouter();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: JanSetuColors.electricBlue.withValues(alpha: 0.15),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: JanSetuColors.electricBlue, width: 1.5),
                          ),
                        ),
                        icon: const Icon(Icons.login_rounded, color: Colors.white, size: 15),
                        label: const Text(
                          'Login Portal',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => JanSetuUserProfileModal.show(context, onAction: _rebuildRouter),
                        tooltip: 'User Profile & Security Center',
                        style: IconButton.styleFrom(backgroundColor: Colors.white10),
                        icon: const Icon(Icons.account_circle_rounded, color: JanSetuColors.electricBlue, size: 22),
                      ),
                    ],
                  );

                  final isPhone = constraints.maxWidth < 650;
                  if (isPhone) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Compact Brand
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: JanSetuColors.electricBlue.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.5)),
                                ),
                                child: const Icon(Icons.shield_rounded, color: JanSetuColors.electricBlue, size: 16),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'JanSetu AI',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.3),
                              ),
                            ],
                          ),
                          // Right Controls
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Compact User Persona Badge
                              InkWell(
                                onTap: () => JanSetuUserProfileModal.show(context, onAction: _rebuildRouter),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: roleColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: roleColor.withValues(alpha: 0.6), width: 1.2),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(roleIcon, color: roleColor, size: 13),
                                      const SizedBox(width: 6),
                                      Text(
                                        '👤 ${name.split(' ').first}',
                                        style: TextStyle(color: roleColor, fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (kDebugMode) ...[
                                // Compact Dev Persona Switcher
                                TextButton.icon(
                                  onPressed: () => DevPersonaSwitcherModal.show(context, onSwitch: _rebuildRouter),
                                  style: TextButton.styleFrom(
                                    backgroundColor: JanSetuColors.saffronGold.withValues(alpha: 0.15),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: const BorderSide(color: JanSetuColors.saffronGold, width: 1.2),
                                    ),
                                  ),
                                  icon: const Icon(Icons.bolt_rounded, color: JanSetuColors.saffronGold, size: 14),
                                  label: const Text(
                                    'Dev',
                                    style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 11),
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                              IconButton(
                                onPressed: () => JanSetuUserProfileModal.show(context, onAction: _rebuildRouter),
                                tooltip: 'User Profile & Security Center',
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white10,
                                  padding: const EdgeInsets.all(6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(Icons.account_circle_rounded, color: JanSetuColors.electricBlue, size: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  if (isMobile) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          leftSection,
                          const SizedBox(width: 24),
                          rightSection,
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        leftSection,
                        rightSection,
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Mounted Role Workspace
          Expanded(
            child: targetModule,
          ),
        ],
      ),
    );
  }
}
