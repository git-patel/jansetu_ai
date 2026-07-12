import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import '../../services/local_persistence_service.dart';
import '../auth/dev_persona_switcher_modal.dart';

/// JanSetu AI — Enterprise Cryptographic Identity & User Profile Modal
/// Displays verified e-Pramaan claims, spatial jurisdictional polygon boundaries,
/// role-specific SLA analytics, stakeholder-specific tools, and portal session controls.
class JanSetuUserProfileModal extends StatefulWidget {
  final VoidCallback onAction;

  const JanSetuUserProfileModal({super.key, required this.onAction});

  static void show(BuildContext context, {required VoidCallback onAction}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: JanSetuColors.slateNavy,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(JanSetuTheme.radiusLarge)),
      ),
      builder: (_) => JanSetuUserProfileModal(onAction: onAction),
    );
  }

  @override
  State<JanSetuUserProfileModal> createState() => _JanSetuUserProfileModalState();
}

class _JanSetuUserProfileModalState extends State<JanSetuUserProfileModal> {
  Future<void> _logoutToLoginPortal(BuildContext context) async {
    await LocalPersistenceService.logout();
    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onAction();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔒 Session terminated. Returned to JanSetu Zero-Trust Login Portal.'),
        backgroundColor: JanSetuColors.electricBlue,
      ),
    );
  }

  Future<void> _resetAndLogout(BuildContext context) async {
    await LocalPersistenceService.resetToDefaults();
    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onAction();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Synthetic state reset to default Gujarat baseline. Unauthenticated.'),
        backgroundColor: JanSetuColors.saffronGold,
      ),
    );
  }

  void _showEditProfileDialog() {
    final profile = LocalPersistenceService.userProfile ?? {};
    final nameCtrl = TextEditingController(text: profile['name']?.toString() ?? 'Rajesh Bhai Patel');
    final phoneCtrl = TextEditingController(text: profile['phone']?.toString() ?? '9999999999');
    final langCtrl = TextEditingController(text: LocalPersistenceService.selectedLanguage);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: const Text('Edit Gov Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: langCtrl.text,
              dropdownColor: JanSetuColors.slateNavy,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Preferred Language',
                labelStyle: TextStyle(color: Colors.grey),
              ),
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Gujarati', child: Text('ગુજરાતી')),
                DropdownMenuItem(value: 'Hindi', child: Text('हिन्दी')),
              ],
              onChanged: (val) {
                if (val != null) langCtrl.text = val;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newProfile = Map<String, dynamic>.from(profile);
              newProfile['name'] = nameCtrl.text;
              newProfile['phone'] = phoneCtrl.text;
              await LocalPersistenceService.loginAsRole(LocalPersistenceService.activeRole ?? 'CITIZEN', newProfile);
              await LocalPersistenceService.setLanguage(langCtrl.text);
              Navigator.pop(ctx);
              setState(() {});
              widget.onAction();
            },
            style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.electricBlue),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showMyRequestsDialog() {
    final needs = LocalPersistenceService.needs;
    final myNeeds = needs.where((n) => n['submittedByMe'] == true || n['creatorUserId'] == 'USR-CTZ-7721').toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: Text('My AI Requests (${myNeeds.length})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: myNeeds.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('No active grievances submitted yet.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: myNeeds.length,
                  itemBuilder: (c, idx) {
                    final item = myNeeds[idx] as Map;
                    return ListTile(
                      title: Text(item['titleEnglish'] ?? 'Grievance', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('Status: ${item['status']}', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 11)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.electricBlue)),
          ),
        ],
      ),
    );
  }

  void _showSupportedRequestsDialog() {
    final needs = LocalPersistenceService.needs;
    final supported = needs.where((n) {
      final idx = needs.indexOf(n);
      return LocalPersistenceService.isNeedSupported(idx, 'USR-CTZ-7721') || LocalPersistenceService.isNeedSupported(idx, 'CITIZEN');
    }).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: Text('Supported Request Feed (${supported.length})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: supported.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('You have not supported any request yet.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: supported.length,
                  itemBuilder: (c, idx) {
                    final item = supported[idx] as Map;
                    return ListTile(
                      title: Text(item['titleEnglish'] ?? 'Grievance', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('Category: ${item['category'] ?? 'Roads'}', style: const TextStyle(color: JanSetuColors.electricBlue, fontSize: 11)),
                      trailing: const Icon(Icons.thumb_up_alt_rounded, size: 14, color: JanSetuColors.emeraldGreen),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.electricBlue)),
          ),
        ],
      ),
    );
  }

  void _showMyCommentsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: const Text('My Recent Comments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('"Potholes are causing severe traffic here!"', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 13)),
              subtitle: Text('On Gaurav Path Road • 2 hours ago', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ),
            Divider(color: JanSetuColors.darkBorder),
            ListTile(
              title: Text('"Glad this got routed to SMC West Zone!"', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 13)),
              subtitle: Text('On Drainage Leakage • Yesterday', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.electricBlue)),
          ),
        ],
      ),
    );
  }

  void _showMpConstituencyOversight() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: const Text('Surat Parliamentary Constituency Oversight', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatDialogRow('Active Projects', '12 Infrastructure Works'),
            _buildStatDialogRow('SLA Resolution', '95.6% On-Time Performance'),
            _buildStatDialogRow('MPLADS Utilized', '₹3.40 Crore of ₹5.0 Crore'),
            _buildStatDialogRow('Citizen Rating', '4.7 / 5.0 (Surat West Zone)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.emeraldGreen)),
          ),
        ],
      ),
    );
  }

  void _showMpBudgetLedger() {
    final fundBalance = LocalPersistenceService.mpladsFundBalanceINR;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: const Text('MPLADS Fund Ledger Accounts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatDialogRow('Total Allocated', '₹5,00,00,000'),
            _buildStatDialogRow('Active Projects', '₹1,50,00,000'),
            _buildStatDialogRow('Remaining Balance', "₹${fundBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.emeraldGreen)),
          ),
        ],
      ),
    );
  }

  void _showMpApprovalsQueue() {
    final needs = LocalPersistenceService.needs;
    final pending = needs.where((n) => (n as Map)['status'] == 'VERIFIED_AI').toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: Text('Pending MP Approvals Queue (${pending.length})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: pending.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('All citizen requests have been approved or rejected.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: pending.length,
                  itemBuilder: (c, idx) {
                    final item = pending[idx] as Map;
                    return ListTile(
                      title: Text(item['titleEnglish'] ?? 'Grievance', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('Priority score: ${item['priorityScore'] ?? '90'}', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 11)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.emeraldGreen)),
          ),
        ],
      ),
    );
  }

  void _showAdminDepartments() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: const Text('State Departments & Secretaries', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatDialogRow('Roads & Buildings', 'Shri A.K. Patel, IAS'),
            _buildStatDialogRow('Water & Sanitation', 'Smt. R. Sivaraman, IAS'),
            _buildStatDialogRow('Electricity & Power', 'Shri N.J. Mehta, Chief Eng'),
            _buildStatDialogRow('Health & Sanitation', 'Dr. V.G. Sharma, Director'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.saffronGold)),
          ),
        ],
      ),
    );
  }

  void _showAdminDistricts() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: const Text('District Performance Index', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatDialogRow('Surat West Zone', 'Index: 94.2/100 (HIGH)'),
            _buildStatDialogRow('Ahmedabad Municipal', 'Index: 88.5/100 (HIGH)'),
            _buildStatDialogRow('Vadodara Central', 'Index: 81.0/100 (MEDIUM)'),
            _buildStatDialogRow('Gandhinagar PWD', 'Index: 92.4/100 (HIGH)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.saffronGold)),
          ),
        ],
      ),
    );
  }

  void _showAdminUsers() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: JanSetuColors.slateNavy,
        title: const Text('Public & Stakeholder Directory', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatDialogRow('Verified Citizens', '4,88,410 active users'),
            _buildStatDialogRow('Nodal Officers Assigned', '124 active engineers'),
            _buildStatDialogRow('Constituency Reps', '26 Lok Sabha members'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: JanSetuColors.saffronGold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPersonaOptions(String activeRole) {
    if (activeRole == 'CITIZEN') {
      return Column(
        children: [
          _buildActionTile('✍️ Edit Gov Profile Settings', 'Update name, mobile, and preferred language preference', _showEditProfileDialog),
          _buildActionTile('📋 View My Submitted Requests', 'Browse status and routing details of your grievances', _showMyRequestsDialog),
          _buildActionTile('🤝 Supported Grievances Feed', 'See other neighborhood requests that you upvoted', _showSupportedRequestsDialog),
          _buildActionTile('💬 My Recent Discussions', 'View thread comments and response timelines', _showMyCommentsDialog),
        ],
      );
    } else if (activeRole == 'MP') {
      return Column(
        children: [
          _buildActionTile('🏛️ Constituency Oversight & Performance', 'Track Surat Constituency GIS metrics & SLA status', _showMpConstituencyOversight),
          _buildActionTile('💰 MPLADS Budget Ledger Balance', 'Audit real-time escrow accounts and fund remaining', _showMpBudgetLedger),
          _buildActionTile('✍️ Active Project Approvals Queue', 'Directly approve or reject AI-routed public works', _showMpApprovalsQueue),
        ],
      );
    } else {
      return Column(
        children: [
          _buildActionTile('🏢 State Nodal Departments Registry', 'Audit municipal secretaries, ministries, and roles', _showAdminDepartments),
          _buildActionTile('🗺️ District Performance Matrix Index', 'Compare development and citizen satisfaction by area', _showAdminDistricts),
          _buildActionTile('👥 Users & Officers Public Directory', 'Oversee verified citizens, engineers, and Reps', _showAdminUsers),
        ],
      );
    }
  }

  Widget _buildActionTile(String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: JanSetuColors.darkBorder),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: JanSetuColors.electricBlue, size: 14),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeRole = LocalPersistenceService.activeRole ?? 'CITIZEN';
    final profile = LocalPersistenceService.userProfile ?? {};
    final name = profile['name']?.toString() ?? 'Rajesh Bhai Patel';
    final idString = profile['id']?.toString() ?? 'CIT-SRT-8841';

    Color roleColor;
    IconData roleIcon;
    String roleBadgeLabel;
    String jurisdictionLabel;
    String designationLabel;
    List<Widget> analyticsWidgets;

    if (activeRole == 'CITIZEN') {
      roleColor = JanSetuColors.electricBlue;
      roleIcon = Icons.person_pin_circle_rounded;
      roleBadgeLabel = 'VERIFIED CITIZEN IDENTIFIER';
      jurisdictionLabel = profile['jurisdiction']?.toString() ?? 'WRD-GUJ-SRT-0014 (Adajan Ward 14, Surat)';
      designationLabel = 'Resident Stakeholder • Surat Municipal Corporation';
      analyticsWidgets = [
        _buildStatCard('Active Grievances', '300 Ward Issues', JanSetuColors.electricBlue, Icons.report_problem_rounded),
        _buildStatCard('AI Resolution SLA', '94.2% On-Time', JanSetuColors.emeraldGreen, Icons.check_circle_outline_rounded),
        _buildStatCard('Ward Twin Score', '84.2 / 100', JanSetuColors.saffronGold, Icons.analytics_rounded),
      ];
    } else if (activeRole == 'MP') {
      roleColor = JanSetuColors.emeraldGreen;
      roleIcon = Icons.account_balance_rounded;
      roleBadgeLabel = 'PARLIAMENTARY EXECUTIVE AUTHORITY';
      jurisdictionLabel = profile['jurisdiction']?.toString() ?? 'PC-GUJ-SRT-0001 (Surat Parliamentary Constituency)';
      designationLabel = profile['constituency']?.toString() ?? 'Member of Parliament • Lok Sabha Executive';
      final fundBalance = LocalPersistenceService.mpladsFundBalanceINR;
      analyticsWidgets = [
        _buildStatCard('MPLADS Available', '₹${(fundBalance / 10000000).toStringAsFixed(2)} Cr', JanSetuColors.emeraldGreen, Icons.account_balance_wallet_rounded),
        _buildStatCard('Sanctioned Queue', '${LocalPersistenceService.projects.length} Works', JanSetuColors.electricBlue, Icons.engineering_rounded),
        _buildStatCard('Constituency Index', '91.8 / 100', JanSetuColors.saffronGold, Icons.thumb_up_alt_rounded),
      ];
    } else {
      roleColor = JanSetuColors.saffronGold;
      roleIcon = Icons.admin_panel_settings_rounded;
      roleBadgeLabel = 'STATE GOVERNANCE & AUDIT PRINCIPAL';
      jurisdictionLabel = profile['jurisdiction']?.toString() ?? 'STA-GUJ-0001 (State of Gujarat — PWD & Urban HQ)';
      designationLabel = profile['designation']?.toString() ?? 'Principal Secretary / Chief Engineer HQ';
      analyticsWidgets = [
        _buildStatCard('PFMS Escrow Ledgers', '${LocalPersistenceService.ledgerProjects.length} Active Tranches', JanSetuColors.saffronGold, Icons.account_balance_rounded),
        _buildStatCard('Spatial Tiers', '11-Tier GIS Grid', JanSetuColors.electricBlue, Icons.layers_rounded),
        _buildStatCard('Blockchain Audit', '100% Verified', JanSetuColors.emeraldGreen, Icons.verified_user_rounded),
      ];
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(roleIcon, color: roleColor, size: 24),
                      const SizedBox(width: 10),
                      const Text(
                        'User Identity & Security Center',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hero Identity Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: roleColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
                  border: Border.all(color: roleColor, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: roleColor, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            roleBadgeLabel,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.verified, color: JanSetuColors.emeraldGreen, size: 14),
                            const SizedBox(width: 4),
                            const Text('e-Pramaan v2.4 Active', style: TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      designationLabel,
                      style: TextStyle(color: roleColor, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🪪 Cryptographic Gov-ID: $idString', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('📍 Spatial Jurisdiction: $jurisdictionLabel', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text('🔐 SHA-256 Token Hash: 0x94F8B3A1C9D2E077F4A8B92C3D1E5A6B7C8D9E0F', style: TextStyle(color: roleColor.withAlpha(200), fontFamily: 'monospace', fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Role Analytics Grid
              const Text(
                'JURISDICTIONAL PERFORMANCE & SLA METRICS',
                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),
              Row(
                children: analyticsWidgets
                    .map((w) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: w)))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Stakeholder Specific Tools
              Text(
                'STAKEHOLDER SPECIFIC SERVICES & MANAGEMENT',
                style: TextStyle(color: roleColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),
              _buildPersonaOptions(activeRole),
              const SizedBox(height: 16),
              const Divider(color: JanSetuColors.darkBorder),
              const SizedBox(height: 16),

              // Action Buttons
              const Text(
                'SESSION & PORTAL GOVERNANCE CONTROLS',
                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  if (kDebugMode) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          DevPersonaSwitcherModal.show(context, onSwitch: widget.onAction);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: JanSetuColors.saffronGold.withAlpha(51),
                          foregroundColor: JanSetuColors.saffronGold,
                          side: const BorderSide(color: JanSetuColors.saffronGold),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.bolt_rounded, size: 18),
                        label: const Text('Switch Persona', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _logoutToLoginPortal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: JanSetuColors.electricBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const Text('Login Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _resetAndLogout(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: JanSetuColors.crimsonAlert),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.refresh_rounded, color: JanSetuColors.crimsonAlert, size: 18),
                    label: const Text('Reset Demo Data & Return to Zero-Trust Gate', style: TextStyle(color: JanSetuColors.crimsonAlert, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
