import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import 'ward_heatmap_view.dart';
import 'mp_project_detail_modal.dart';
import '../../core/config/service_locator.dart';
import '../../services/local_persistence_service.dart';
import '../shared/user_profile_modal.dart';
import '../shared/floating_ai_assistant.dart';

/// MP Command Center Web Scaffold (MpDashboardModule)
/// Renders executive workspaces for Ward Deficit Heatmaps, MPLADS budget burn, and project sanctions.
/// Refactored for Executive Decision Support System ("What should I do today to improve my constituency?")
class MpDashboardModule extends StatefulWidget {
  final List<dynamic> syntheticProjects;

  const MpDashboardModule({
    super.key,
    required this.syntheticProjects,
  });

  @override
  State<MpDashboardModule> createState() => _MpDashboardModuleState();
}

class _MpDashboardModuleState extends State<MpDashboardModule> {
  int _selectedNavIndex = 0; // 0: Home & Briefing, 1: Priority Queue, 2: Capital Works, 3: Digital Twin, 4: Analytics, 5: Budget Burn, 6: Officers & Reports
  double _remainingMpladsFundINR = 50000000.0; // ₹5.00 Crore initial allocation
  late List<dynamic> _projectsList;
  String _searchQuery = '';
  int _unreadNotifs = 6;
  String _executiveBriefing = 'Good Morning Hon. MP. Today there are:\n'
      '• **12** Critical Development Needs awaiting your review\n'
      '• **3** Delayed Projects requiring contractor SLA escalation\n'
      '• **2** Budget Risks identified in Varachha Ward 8\n'
      '• **1** Municipal School in Adajan requiring urgent roof repair\n\n'
      '**AI Sanction Recommendation:** We recommend approving **Road Improvement Project RP-203** first because it impacts approximately 4,800 citizens and prevents monsoon traffic stalling.';
  bool _isLoadingBriefing = false;

  Future<void> _fetchAiBriefing() async {
    setState(() => _isLoadingBriefing = true);
    try {
      final aiRepo = ServiceLocator.instance.aiRepository;
      final reply = await aiRepo.chatAssistant('Summarize today\'s priorities and executive briefing', [], role: 'MP');
      if (mounted) {
        setState(() {
          _executiveBriefing = reply;
          _isLoadingBriefing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingBriefing = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _projectsList = LocalPersistenceService.projects.isNotEmpty
        ? List.from(LocalPersistenceService.projects)
        : List.from(widget.syntheticProjects);
    _remainingMpladsFundINR = LocalPersistenceService.mpladsFundBalanceINR;
  }

  @override
  void didUpdateWidget(covariant MpDashboardModule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.syntheticProjects != widget.syntheticProjects) {
      _projectsList = LocalPersistenceService.projects.isNotEmpty
          ? List.from(LocalPersistenceService.projects)
          : List.from(widget.syntheticProjects);
      _remainingMpladsFundINR = LocalPersistenceService.mpladsFundBalanceINR;
    }
  }

  void _handleSanction(Map<String, dynamic> newProject, double sanctionAmountINR) {
    LocalPersistenceService.saveSanction(newProject, sanctionAmountINR);
    setState(() {
      _remainingMpladsFundINR = LocalPersistenceService.mpladsFundBalanceINR;
      _projectsList = List.from(LocalPersistenceService.projects);
      _selectedNavIndex = 2; // Switch to Capital Works Queue to view new allocation
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚡ Allocated ₹${(sanctionAmountINR / 100000).toStringAsFixed(0)} Lakhs from MPLADS fund! Project prepended to active queue.'),
        backgroundColor: JanSetuColors.emeraldGreen,
      ),
    );
  }

  void _showDetailModal(Map<String, dynamic> item, {bool isProject = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MpProjectDetailModal(
        item: item,
        onSanction: !isProject
            ? () {
                _handleSanction({
                  'projectName': 'MPLADS Sanctioned Work: ${item['title']}',
                  'departmentId': item['department'] ?? 'Municipal Works',
                  'financials': {'sanctionedBudgetINR': item['costINR'] ?? 5000000.0, 'disbursedAmountINR': 1000000.0},
                  'progressPercentage': 15,
                  'currentStatus': 'SANCTIONED_MPLADS',
                  'timestamp': DateTime.now().toIso8601String(),
                }, (item['costINR'] as num?)?.toDouble() ?? 5000000.0);
              }
            : null,
      ),
    );
  }

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildNotificationCenterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JanSetuColors.darkBg,
      body: Stack(
        children: [
          Column(
            children: [
              // Sleek Top Executive Bar (Search & Notification Center)
              _buildTopExecutiveBar(),
              const Divider(color: JanSetuColors.darkBorder, height: 1),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 950;
                    if (isMobile) {
                      return Column(
                        children: [
                          Container(
                            height: 54,
                            color: JanSetuColors.darkSurface,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  _buildMobileNavPill(Icons.dashboard_rounded, 'Command Home', 0),
                                  const SizedBox(width: 8),
                                  _buildMobileNavPill(Icons.priority_high_rounded, 'Priority Queue', 1),
                                  const SizedBox(width: 8),
                                  _buildMobileNavPill(Icons.engineering_rounded, 'Works Queue', 2),
                                  const SizedBox(width: 8),
                                  _buildMobileNavPill(Icons.domain_rounded, 'Digital Twin', 3),
                                  const SizedBox(width: 8),
                                  _buildMobileNavPill(Icons.analytics_rounded, 'Analytics', 4),
                                  const SizedBox(width: 8),
                                  _buildMobileNavPill(Icons.account_balance_wallet_rounded, 'Budget Burn', 5),
                                  const SizedBox(width: 8),
                                  _buildMobileNavPill(Icons.people_alt_rounded, 'Officers & Reports', 6),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: JanSetuColors.darkBorder, height: 1),
                          Expanded(child: _buildSelectedWorkspace()),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        // Left Sidebar Navigation
                        Container(
                          width: 230,
                          color: JanSetuColors.darkSurface,
                          padding: const EdgeInsets.all(JanSetuTheme.space16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('EXECUTIVE DECISION SUITE', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(height: JanSetuTheme.space16),
                              _buildNavItem(Icons.dashboard_rounded, 'Command Home & Briefing', 0),
                              _buildNavItem(Icons.priority_high_rounded, 'AI Priority Queue', 1),
                              _buildNavItem(Icons.engineering_rounded, 'Capital Works Queue', 2),
                              _buildNavItem(Icons.domain_rounded, 'Constituency Digital Twin', 3),
                              _buildNavItem(Icons.analytics_rounded, 'Executive Analytics', 4),
                              _buildNavItem(Icons.account_balance_wallet_rounded, 'Fiscal Budget Burn', 5),
                              _buildNavItem(Icons.people_alt_rounded, 'Officers & Reports', 6),
                              const Spacer(),
                              const Divider(color: JanSetuColors.darkBorder),
                              const SizedBox(height: 8),
                              const Text('Hon. C. R. Patil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              const Text('Member of Parliament • Surat West', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ),
                        // Main Content Area
                        Expanded(child: _buildSelectedWorkspace()),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          // Floating AI Assistant
          const Positioned(
            right: 24,
            bottom: 24,
            child: FloatingAiAssistant(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopExecutiveBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: JanSetuColors.darkSurface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: JanSetuColors.saffronGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.how_to_vote_rounded, color: JanSetuColors.saffronGold, size: 22),
                ),
                const SizedBox(width: 14),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MP Executive — Hon. C.R. Patil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Surat West District • Executive Decision Support System', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 24),
            // Global Search Bar & Notification Bell
            Row(
              children: [
                Container(
                  width: 260,
                  height: 38,
                  decoration: BoxDecoration(
                    color: JanSetuColors.darkBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: JanSetuColors.darkBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Search Projects, Needs, Officers...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Working Notification Center Button
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_rounded, color: Colors.white),
                      onPressed: _showNotificationsSheet,
                    ),
                    if (_unreadNotifs > 0)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: JanSetuColors.crimsonAlert, shape: BoxShape.circle),
                        child: Text('$_unreadNotifs', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    JanSetuUserProfileModal.show(context, onAction: () => setState(() {}));
                  },
                  child: const CircleAvatar(
                    backgroundColor: JanSetuColors.electricBlue,
                    radius: 18,
                    child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutiveBriefingBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: JanSetuColors.electricBlue.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: JanSetuColors.electricBlue.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.wb_sunny_rounded, color: JanSetuColors.saffronGold, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hon. MP Command Center — Surat Constituency',
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'AI Synthesis • 6 Priorities • MPLADS Fund: ₹${(_remainingMpladsFundINR / 10000000).toStringAsFixed(2)} Cr Active',
                          style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: JanSetuColors.emeraldGreen),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: JanSetuColors.emeraldGreen, size: 14),
                    SizedBox(width: 6),
                    Text('SLA Velocity: +14%', style: TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedWorkspace() {
    switch (_selectedNavIndex) {
      case 0: // Command Home & Briefing + Ward Heatmap
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExecutiveBriefingBanner(),
              _buildWorkspace0Home(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: JanSetuColors.darkBorder, height: 32),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('GIS Ward Deficit Heatmap & Emergency 1-Tap Sanctions', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              WardHeatmapView(
                remainingMpladsFundINR: _remainingMpladsFundINR,
                onSanction: _handleSanction,
                banner: const SizedBox.shrink(),
                isEmbedded: true,
              ),
            ],
          ),
        );

      case 1: // AI Priority Queue & Approvals
        return _buildWorkspace1Queue();

      case 2: // Capital Works Queue & Projects
        return _buildWorkspace2Projects();

      case 3: // Constituency Digital Twin
        return _buildWorkspace3Twin();

      case 4: // Executive Visual Analytics
        return _buildWorkspace4Analytics();

      case 5: // Fiscal Budget Burn
        return _buildWorkspace5Budget();

      case 6: // Officer Management & Reports
        return _buildWorkspace6Officers();

      default:
        return _buildWorkspace0Home();
    }
  }

  // Workspace 0: Dashboard Home
  Widget _buildWorkspace0Home() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Date Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning Hon. MP 👋', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Today\'s Date: Monday, July 6, 2026 • District: Surat West', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 13)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.electricBlue, foregroundColor: Colors.white),
                onPressed: () => setState(() => _selectedNavIndex = 1),
                icon: const Icon(Icons.bolt_rounded, size: 18),
                label: const Text('Open Priority Queue'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Executive AI Daily Briefing Card
          JanSetuCard(
            backgroundColor: JanSetuColors.darkSurface,
            border: BorderSide(color: JanSetuColors.saffronGold.withValues(alpha: 0.5), width: 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: JanSetuColors.saffronGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.auto_awesome_rounded, color: JanSetuColors.saffronGold, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Flexible(
                          child: Text('Executive AI Daily Briefing', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: _isLoadingBriefing
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: JanSetuColors.saffronGold))
                              : const Icon(Icons.refresh_rounded, color: JanSetuColors.saffronGold, size: 18),
                          tooltip: 'Refresh AI Briefing',
                          onPressed: _isLoadingBriefing ? null : _fetchAiBriefing,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: JanSetuColors.crimsonAlert.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: const Text('🔥 2 Critical Actions', style: TextStyle(color: JanSetuColors.crimsonAlert, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: JanSetuColors.darkBorder, height: 24),
                Text(
                  _executiveBriefing,
                  style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.emeraldGreen, foregroundColor: Colors.white),
                      onPressed: () => setState(() => _selectedNavIndex = 1),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('View Priority Queue ➔'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: JanSetuColors.darkBorder)),
                      onPressed: () {
                        _showDetailModal({
                          'title': 'Road Improvement Project RP-203',
                          'department': 'Roads & Bridges',
                          'location': 'Varachha Ward 8',
                          'priorityScore': 94.8,
                          'costINR': 5000000.0,
                          'status': 'SANCTION_PENDING',
                          'description': 'AI recommended priority tender for 4-lane bitumen resurfacing across Varachha main arterial road.',
                        });
                      },
                      icon: const Icon(Icons.read_more_rounded, size: 16),
                      label: const Text('Read AI Reasoning'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Top KPI Summary Cards (No tables!)
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _buildKpiBox('Development Score', '84.2 / 100', 'Tier 1 Digital Twin', Icons.score_rounded, JanSetuColors.emeraldGreen),
              _buildKpiBox('Citizen Satisfaction', '92% Approval', '+4.2% MoM Growth', Icons.thumb_up_rounded, JanSetuColors.electricBlue),
              _buildKpiBox('Budget Remaining', '₹5.00 Crore', '100% Fund Available', Icons.account_balance_wallet_rounded, JanSetuColors.saffronGold),
              _buildKpiBox('Critical Needs', '12 Active', 'Requires 1-Tap Sanction', Icons.priority_high_rounded, JanSetuColors.crimsonAlert),
              _buildKpiBox('Delayed Projects', '3 Works', 'Contractor SLA Notice', Icons.timer_off_rounded, JanSetuColors.saffronGold),
              _buildKpiBox('Upcoming Meetings', '3 Townhalls', 'Next: Adajan at 4 PM', Icons.groups_rounded, JanSetuColors.electricBlue),
            ],
          ),
        ],
      ),
    );
  }

  // Workspace 1: AI Priority Queue
  Widget _buildWorkspace1Queue() {
    final needs = [
      {
        'title': 'Road Improvement Project RP-203',
        'department': 'Roads & Bridges',
        'location': 'Varachha Ward 8, Surat',
        'priorityScore': 94.8,
        'costINR': 5000000.0,
        'supportCount': 480,
        'status': 'SANCTION_PENDING',
        'summary': 'Severe arterial road degradation affecting 4,800 daily commuters. Zero duplicate tenders found.',
      },
      {
        'title': 'Adajan Ward 14 Storm Drainage Upgrade',
        'department': 'Water & Drainage',
        'location': 'Adajan Ward 14, Surat West',
        'priorityScore': 88.5,
        'costINR': 3500000.0,
        'supportCount': 342,
        'status': 'SANCTION_PENDING',
        'summary': 'Monsoon waterlogging prevention grid. AI verification confirms 100% SLA necessity.',
      },
      {
        'title': 'Municipal School 12 Roof & Solar Repair',
        'department': 'Education & Civic Works',
        'location': 'Udhna Ward 3, Surat',
        'priorityScore': 82.1,
        'costINR': 1500000.0,
        'supportCount': 210,
        'status': 'INSPECTION_REQ',
        'summary': 'School building structural reinforcement and rooftop 10kW solar grid installation.',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExecutiveBriefingBanner(),
          const SizedBox(height: 16),
          const Text('AI Priority Queue & Complete Approval Flow', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Ranked using Development Impact Score, Support Count, Affected Population, Urgency, and AI Confidence.', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          ...needs.map((item) => _buildPriorityQueueCard(item)),
        ],
      ),
    );
  }

  Widget _buildPriorityQueueCard(Map<String, dynamic> item) {
    final title = item['title'];
    final dept = item['department'];
    final loc = item['location'];
    final score = (item['priorityScore'] as num).toDouble();
    final cost = item['costINR'];
    final supp = item['supportCount'];
    final sum = item['summary'];
    final costText = '₹${(cost / 100000).toStringAsFixed(2)} Lakhs';

    return JanSetuCard(
      backgroundColor: JanSetuColors.darkSurface,
      border: BorderSide(color: JanSetuColors.getPriorityColor(score).withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: JanSetuColors.getPriorityColor(score).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Text('🔥 AI Score: ${score.toStringAsFixed(1)}', style: TextStyle(color: JanSetuColors.getPriorityColor(score), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Text('$dept • $loc', style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: JanSetuColors.electricBlue.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                child: Text('👍 $supp Citizens Supported', style: const TextStyle(color: JanSetuColors.electricBlue, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(sum, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const Divider(color: JanSetuColors.darkBorder, height: 24),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              Text('Estimated Outlay: $costText', style: const TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 14)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.emeraldGreen, foregroundColor: Colors.white),
                    onPressed: () {
                      _handleSanction({
                        'projectName': 'MPLADS Sanctioned: $title',
                        'departmentId': dept,
                        'financials': {'sanctionedBudgetINR': cost, 'disbursedAmountINR': 1000000.0},
                        'progressPercentage': 10,
                        'currentStatus': 'SANCTIONED_MPLADS',
                        'timestamp': DateTime.now().toIso8601String(),
                      }, cost);
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: const Text('Approve'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: JanSetuColors.electricBlue, side: const BorderSide(color: JanSetuColors.electricBlue)),
                    onPressed: () => _showDetailModal(item),
                    icon: const Icon(Icons.engineering_rounded, size: 16),
                    label: const Text('Assign Officer'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: JanSetuColors.darkBorder)),
                    onPressed: () => _showDetailModal(item),
                    icon: const Icon(Icons.info_outline_rounded, size: 16),
                    label: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Workspace 2: Capital Works Queue & Projects
  Widget _buildWorkspace2Projects() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExecutiveBriefingBanner(),
          const SizedBox(height: 16),
          const Text('SANCTIONED CONSTITUENCY PROJECTS QUEUE (CLICK TO VIEW METADATA TIMELINE)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const Text('Modern project cards displaying real-time contractor progress, fiscal disbursement, and milestone SLAs.', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          ..._projectsList.map((p) => _buildProjectCard(p)),
          if (_projectsList.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No active projects sanctioned yet.', style: TextStyle(color: Colors.grey)))),
        ],
      ),
    );
  }

  Widget _buildProjectCard(dynamic p) {
    final title = p['projectName'] ?? p['title'] ?? 'Sanctioned Project';
    final dept = p['departmentId'] ?? p['department'] ?? 'Municipal Works';
    final prog = (p['progressPercentage'] as num?)?.toInt() ?? 40;
    final status = p['currentStatus'] ?? p['status'] ?? 'IN_PROGRESS';
    final costINR = p['financials'] != null ? (p['financials']['sanctionedBudgetINR'] ?? 5000000.0) : (p['costINR'] ?? 5000000.0);
    final costText = '₹${(costINR / 100000).toStringAsFixed(1)} Lakhs';

    return JanSetuCard(
      backgroundColor: JanSetuColors.darkSurface,
      border: BorderSide(color: JanSetuColors.electricBlue.withValues(alpha: 0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('$dept • Officer: Shri R.K. Joshi • Contractor: Gujarat Civil Buildcon', style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: const TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Milestone Progress: $prog%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('Budget: $costText', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: prog / 100.0,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(JanSetuColors.electricBlue),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: JanSetuColors.darkBorder, height: 24),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: JanSetuColors.darkBorder)),
                onPressed: () => _showDetailModal({'title': title, 'department': dept, 'costINR': costINR, 'status': status}, isProject: true),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Open'),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: JanSetuColors.saffronGold, side: const BorderSide(color: JanSetuColors.saffronGold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⏸️ Project status updated to Paused/Resumed for inspection.'), duration: Duration(seconds: 2)));
                },
                icon: const Icon(Icons.pause_circle_outline_rounded, size: 16),
                label: const Text('Pause / Resume'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.electricBlue, foregroundColor: Colors.white),
                onPressed: () => _showDetailModal({'title': title, 'department': dept, 'costINR': costINR, 'status': status}, isProject: true),
                icon: const Icon(Icons.timeline_rounded, size: 16),
                label: const Text('Timeline'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Workspace 3: Constituency Digital Twin
  Widget _buildWorkspace3Twin() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExecutiveBriefingBanner(),
          const SizedBox(height: 16),
          const Text('Surat West Constituency Digital Twin Matrix', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Real-time spatial GIS simulation and municipal asset health indicators.', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _buildTwinMetricCard('Population Density', '3,12,400 Residents', '100% Digital ID Verified', Icons.people_alt_rounded, JanSetuColors.electricBlue),
              _buildTwinMetricCard('Educational Grid', '18 Municipal Schools', '100% Smart Classrooms', Icons.school_rounded, JanSetuColors.emeraldGreen),
              _buildTwinMetricCard('Healthcare Centers', '6 24x7 Hospitals', 'Zero ICU SLA Breach', Icons.local_hospital_rounded, JanSetuColors.emeraldGreen),
              _buildTwinMetricCard('Road & Bridge Network', '92% Paved Bitumen', '2 Flyovers Active', Icons.edit_road_rounded, JanSetuColors.electricBlue),
              _buildTwinMetricCard('Smart Water Supply', '98.2% Pipeline Grid', 'Optimal Bar Pressure', Icons.water_drop_rounded, JanSetuColors.electricBlue),
              _buildTwinMetricCard('Optical Internet', '100% Fiber Coverage', 'Gigabit Civic WiFi', Icons.wifi_rounded, JanSetuColors.emeraldGreen),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Ward Deficit Spatial Twin Visualizer', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          WardHeatmapView(
            remainingMpladsFundINR: _remainingMpladsFundINR,
            onSanction: _handleSanction,
            banner: const SizedBox.shrink(),
            isEmbedded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTwinMetricCard(String title, String val, String sub, IconData icon, Color color) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
                Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(sub, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Workspace 4: Executive Visual Analytics
  Widget _buildWorkspace4Analytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExecutiveBriefingBanner(),
          const SizedBox(height: 16),
          const Text('Executive Visual Analytics (No Large Tables)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Visual breakdowns of constituency deficit distribution, SLA resolution velocity, and citizen sentiment.', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final card1 = JanSetuCard(
                backgroundColor: JanSetuColors.darkSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Development Needs by Category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 16),
                    _buildChartBar('Roads & Bridges', 0.40, '40% (8 Works)', JanSetuColors.electricBlue),
                    _buildChartBar('Smart Water & Drainage', 0.30, '30% (6 Works)', JanSetuColors.emeraldGreen),
                    _buildChartBar('Power Grid & Solar', 0.20, '20% (4 Works)', JanSetuColors.saffronGold),
                    _buildChartBar('Sanitation & Hygiene', 0.10, '10% (2 Works)', JanSetuColors.crimsonAlert),
                  ],
                ),
              );
              final card2 = JanSetuCard(
                backgroundColor: JanSetuColors.darkSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Department SLA Performance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 16),
                    _buildChartBar('Water Dept (98.2% SLA)', 0.98, 'Rank #1', JanSetuColors.emeraldGreen),
                    _buildChartBar('Education Dept (94.5% SLA)', 0.94, 'Rank #2', JanSetuColors.emeraldGreen),
                    _buildChartBar('Roads Dept (78.0% SLA)', 0.78, 'Needs Focus', JanSetuColors.saffronGold),
                    _buildChartBar('Storm Drainage (62.0% SLA)', 0.62, 'Escalated', JanSetuColors.crimsonAlert),
                  ],
                ),
              );
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Expanded(child: card1), const SizedBox(width: 16), Expanded(child: card2)],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [card1, const SizedBox(height: 16), card2],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double val, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: val,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  // Workspace 5: Fiscal Budget Burn
  Widget _buildWorkspace5Budget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExecutiveBriefingBanner(),
          const SizedBox(height: 16),
          const Text('MPLADS Fiscal Budget & Fund Utilization Burn Rate', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Complete visual accounting of ₹5.00 Crore annual MPLADS entitlement.', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _buildKpiBox('Total Allocation', '₹5.00 Crore', 'FY 2026-27 Entitlement', Icons.account_balance_rounded, JanSetuColors.electricBlue),
              _buildKpiBox('Active Available', '₹${(_remainingMpladsFundINR / 10000000).toStringAsFixed(2)} Cr', 'Ready for Sanction', Icons.account_balance_wallet_rounded, JanSetuColors.emeraldGreen),
              _buildKpiBox('Committed Escrow', '₹1.20 Crore', 'PFMS Disbursed Stage 3', Icons.lock_clock_rounded, JanSetuColors.saffronGold),
              _buildKpiBox('Utilization Rate', '88.4%', 'Top 5% in Gujarat', Icons.trending_up_rounded, JanSetuColors.emeraldGreen),
            ],
          ),
          const SizedBox(height: 20),
          JanSetuCard(
            backgroundColor: JanSetuColors.darkSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Expenditure Burn Visualizer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 16),
                _buildChartBar('Q1 Disbursal (Apr - Jun)', 0.90, '₹1.80 Cr Disbursed', JanSetuColors.emeraldGreen),
                _buildChartBar('Q2 Disbursal (Jul - Sep)', 0.65, '₹1.30 Cr Disbursed', JanSetuColors.electricBlue),
                _buildChartBar('Q3 Projected Sanctions', 0.40, '₹0.80 Cr Planned', JanSetuColors.saffronGold),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Workspace 6: Officers & Reports
  Widget _buildWorkspace6Officers() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExecutiveBriefingBanner(),
          const SizedBox(height: 16),
          const Text('Ward Officer Management & Executive Report Generators', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Assign officers, monitor inspection due dates, and export executive briefings.', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final card1 = JanSetuCard(
                backgroundColor: JanSetuColors.darkSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Executive Report Generators', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 16),
                    _buildReportBtn('📄 Export PDF Report Placeholder', 'Download quarterly constituency audit in PDF format.'),
                    const SizedBox(height: 10),
                    _buildReportBtn('📊 Export Excel Ledger Placeholder', 'Download PFMS financial ledger in CSV/XLSX format.'),
                    const SizedBox(height: 10),
                    _buildReportBtn('🔗 Share Briefing Placeholder', 'Generate secure public briefing card for citizen sharing.'),
                    const SizedBox(height: 10),
                    _buildReportBtn('🖥️ Presentation Mode Placeholder', 'Enter full-screen kiosk visualizer for media townhalls.'),
                  ],
                ),
              );
              final card2 = JanSetuCard(
                backgroundColor: JanSetuColors.darkSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ward Executive Officers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 16),
                    _buildOfficerItem('Shri R.K. Joshi', 'Executive Engineer • Adajan Ward 14', 'Workload: Optimal (4 Works)', JanSetuColors.emeraldGreen),
                    const SizedBox(height: 12),
                    _buildOfficerItem('Smt. P.S. Mehta', 'Zonal Chief Engineer • Varachha Ward 8', 'Inspection Due in 1 Day', JanSetuColors.saffronGold),
                  ],
                ),
              );
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Expanded(child: card1), const SizedBox(width: 16), Expanded(child: card2)],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [card1, const SizedBox(height: 16), card2],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportBtn(String title, String sub) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('⚡ Generating $title... Done!'), backgroundColor: JanSetuColors.emeraldGreen, duration: const Duration(seconds: 2)));
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: JanSetuColors.darkBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: JanSetuColors.darkBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.download_rounded, color: JanSetuColors.electricBlue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficerItem(String name, String role, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: JanSetuColors.darkBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: JanSetuColors.darkBorder)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 18, child: const Icon(Icons.engineering_rounded, color: Colors.white, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(role, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
                Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCenterSheet() {
    final notifs = [
      {'title': '🚨 New High Priority Need', 'desc': 'Road collapse reported in Adajan Ward 14 (AI Confidence 94.8%).', 'time': '10m ago'},
      {'title': '⚠️ Project Delayed', 'desc': 'Varachha drainage pipe laying delayed by 4 days due to rainfall.', 'time': '1h ago'},
      {'title': '💰 Budget Warning', 'desc': 'Udhna Ward 3 contingency fund at 12% capacity.', 'time': '3h ago'},
      {'title': '📈 Citizen Trend', 'desc': '+28% upvote surge on Adajan Solar Promenade proposal.', 'time': '5h ago'},
      {'title': '👷 Officer Inspection Submitted', 'desc': 'Shri R.K. Joshi uploaded 4 geo-tagged site verification photos.', 'time': '1d ago'},
      {'title': '🏗️ Contractor Progress Uploaded', 'desc': 'Gujarat Civil Buildcon uploaded stage 3 completion certificate.', 'time': '2d ago'},
    ];

    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: JanSetuColors.darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: JanSetuColors.electricBlue, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Working Notification Center (6 Unread)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _unreadNotifs = 0),
                    child: const Text('Mark All Read', style: TextStyle(color: JanSetuColors.emeraldGreen)),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded, color: Colors.grey), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ],
          ),
          const Divider(color: JanSetuColors.darkBorder),
          Expanded(
            child: ListView.separated(
              itemCount: notifs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final n = notifs[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: JanSetuColors.darkBorder)),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active_rounded, color: JanSetuColors.saffronGold, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(n['desc']!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(n['time']!, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiBox(String title, String val, String sub, IconData icon, Color color) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
                Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(sub, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => setState(() => _selectedNavIndex = index),
        borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? JanSetuColors.electricBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavPill(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedNavIndex = index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? JanSetuColors.electricBlue : JanSetuColors.darkBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? JanSetuColors.electricBlue : JanSetuColors.darkBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
