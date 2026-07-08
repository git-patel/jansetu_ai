import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import '../../services/local_persistence_service.dart';

/// Hidden Dev-Mode Persona Switcher Bottom Sheet
/// Allows hackathon evaluators and presenters to switch between Citizen, MP, and State Admin personas
/// instantaneously without logging out, and provides 1-tap demo data reset controls.
class DevPersonaSwitcherModal extends StatelessWidget {
  final VoidCallback onSwitch;

  const DevPersonaSwitcherModal({super.key, required this.onSwitch});

  static void show(BuildContext context, {required VoidCallback onSwitch}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: JanSetuColors.slateNavy,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(JanSetuTheme.radiusLarge)),
      ),
      builder: (_) => DevPersonaSwitcherModal(onSwitch: onSwitch),
    );
  }

  Future<void> _switchPersona(BuildContext context, String role, Map<String, dynamic> profile) async {
    await LocalPersistenceService.loginAsRole(role, profile);
    if (!context.mounted) return;
    Navigator.of(context).pop();
    onSwitch();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚡ Dev Mode: Instantly mounted $role persona workspace for ${profile['name']}!'),
        backgroundColor: JanSetuColors.electricBlue,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  Future<void> _resetData(BuildContext context) async {
    await LocalPersistenceService.resetToDefaults();
    if (!context.mounted) return;
    Navigator.of(context).pop();
    onSwitch();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Demo data reset to initial synthetic Gujarat state! Portal unauthenticated.'),
        backgroundColor: JanSetuColors.electricBlue,
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await LocalPersistenceService.logout();
    if (!context.mounted) return;
    Navigator.of(context).pop();
    onSwitch();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔒 Session locked. Returned to zero-trust authentication gate.'),
        backgroundColor: JanSetuColors.slateNavy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeRole = LocalPersistenceService.activeRole ?? 'NONE';
    final activeName = LocalPersistenceService.userProfile?['name'] ?? 'Unauthenticated';

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.developer_mode_rounded, color: JanSetuColors.saffronGold, size: 22),
                      SizedBox(width: 8),
                      Text(
                        '⚡ Dev-Mode Persona Switcher',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Currently Mounted: $activeRole ($activeName)',
                style: const TextStyle(color: JanSetuColors.electricBlue, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Divider(color: JanSetuColors.darkBorder),
              const SizedBox(height: 12),

              const Text(
                '1-Tap Instant Persona Jump (Zero-Latency Workspace Mounting)',
                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

            // Citizen Option
            _buildSwitchItem(
              context,
              role: 'CITIZEN',
              title: '🧑‍🤝‍🧑 Citizen Persona — Rajesh Bhai Patel',
              subtitle: 'CIT-SRT-8841 • Adajan Ward 14, Surat (300 Grievances)',
              color: JanSetuColors.electricBlue,
              isSelected: activeRole == 'CITIZEN',
              profile: {
                'name': 'Rajesh Bhai Patel',
                'id': 'CIT-SRT-8841',
                'role': 'CITIZEN',
                'jurisdiction': 'WRD-GUJ-SRT-0014',
                'wardName': 'Adajan Ward 14',
                'city': 'Surat',
              },
            ),
            const SizedBox(height: 10),

            // MP Option
            _buildSwitchItem(
              context,
              role: 'MP',
              title: '🏛️ MP Executive — Hon. C.R. Patil',
              subtitle: 'MP-GUJ-SRT-01 • Surat Parliamentary Constituency (₹5.00 Cr Fund)',
              color: JanSetuColors.emeraldGreen,
              isSelected: activeRole == 'MP',
              profile: {
                'name': 'Hon. C.R. Patil',
                'id': 'MP-GUJ-SRT-01',
                'role': 'MP',
                'jurisdiction': 'PC-GUJ-SRT-0001',
                'constituency': 'Surat Parliamentary Constituency',
                'budgetAvailableINR': 50000000.0,
              },
            ),
            const SizedBox(height: 10),

            // Admin Option
            _buildSwitchItem(
              context,
              role: 'ADMIN',
              title: '🛡️ State Admin — Shri K.L. Mehta, IAS',
              subtitle: 'ADM-GUJ-HQ-001 • State Principal Secretary / Chief Engineer HQ',
              color: JanSetuColors.saffronGold,
              isSelected: activeRole == 'ADMIN',
              profile: {
                'name': 'Shri K.L. Mehta, IAS',
                'id': 'ADM-GUJ-HQ-001',
                'role': 'ADMIN',
                'jurisdiction': 'STA-GUJ-0001',
                'designation': 'Principal Secretary / Chief Engineer',
                'department': 'State Roads & Buildings HQ',
              },
            ),

            const SizedBox(height: JanSetuTheme.space24),
            const Divider(color: JanSetuColors.darkBorder),
            const SizedBox(height: JanSetuTheme.space16),

            // Footer Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _resetData(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: JanSetuColors.saffronGold),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.refresh_rounded, color: JanSetuColors.saffronGold, size: 18),
                    label: const Text('Reset Demo Data', style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: JanSetuColors.crimsonAlert,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 18),
                    label: const Text('Lock & Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildSwitchItem(
    BuildContext context, {
    required String role,
    required String title,
    required String subtitle,
    required Color color,
    required bool isSelected,
    required Map<String, dynamic> profile,
  }) {
    return InkWell(
      onTap: () => _switchPersona(context, role, profile),
      borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(51) : JanSetuColors.darkSurface,
          borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
          border: Border.all(color: isSelected ? color : JanSetuColors.darkBorder, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withAlpha(38), borderRadius: BorderRadius.circular(6)),
              child: Icon(isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 14),
          ],
        ),
      ),
    );
  }
}
