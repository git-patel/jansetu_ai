import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import 'ai_intake_modal.dart';
import 'my_area_view.dart';
import '../shared/entity_detail_modal.dart';
import '../shared/floating_ai_assistant.dart';
import '../shared/jansetu_comment_modal.dart';
import '../shared/jansetu_share_modal.dart';
import '../../services/local_persistence_service.dart';
import '../shared/user_profile_modal.dart';

/// Citizen Application Screen Scaffold (CitizenAppModule)
/// Streamlined mobile-first Home Screen & Community Feed per Prompt 08:
/// "Good Morning Harsh 👋", primary Report button, and strictly ordered content sections.
class CitizenAppModule extends StatefulWidget {
  final List<dynamic> syntheticNeeds;
  final List<dynamic> syntheticProjects;

  const CitizenAppModule({
    super.key,
    required this.syntheticNeeds,
    required this.syntheticProjects,
  });

  @override
  State<CitizenAppModule> createState() => _CitizenAppModuleState();
}

class _CitizenAppModuleState extends State<CitizenAppModule> {
  int _selectedTab = 0; // 0: Home / Feed, 1: Projects, 2: My Area
  String _selectedCategoryFilter = 'All';
  late List<dynamic> _needsList;

  @override
  void initState() {
    super.initState();
    _needsList = LocalPersistenceService.needs.isNotEmpty
        ? List.from(LocalPersistenceService.needs)
        : List.from(widget.syntheticNeeds);
  }

  @override
  void didUpdateWidget(covariant CitizenAppModule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.syntheticNeeds != widget.syntheticNeeds) {
      _needsList = LocalPersistenceService.needs.isNotEmpty
          ? List.from(LocalPersistenceService.needs)
          : List.from(widget.syntheticNeeds);
    }
  }

  void _showEntityDetail(Map<String, dynamic> item, bool isProject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EntityDetailModal(
        entity: item,
        isProject: isProject,
        onActionTriggered: () => setState(() {}),
      ),
    );
  }

  void _openAiIntake() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AiIntakeModal(
        onSubmit: (newNeed) {
          LocalPersistenceService.saveNeed(newNeed);
          setState(() {
            _needsList = List.from(LocalPersistenceService.needs);
            _selectedTab = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Verified Grievance submitted! AI auto-routed to Roads & Buildings Dept.'),
              backgroundColor: JanSetuColors.emeraldGreen,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Tab bar selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16, vertical: JanSetuTheme.space12),
            child: Row(
              children: [
                Expanded(child: _buildTabBtn(0, 'Home & Feed', Icons.home_rounded)),
                const SizedBox(width: 8),
                Expanded(child: _buildTabBtn(1, 'Ward Projects', Icons.engineering_rounded)),
                const SizedBox(width: 8),
                Expanded(child: _buildTabBtn(2, 'My Area', Icons.map_rounded)),
              ],
            ),
          ),
          // Content Feed
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _selectedTab == 2
          ? const FloatingAiAssistant()
          : FloatingActionButton.extended(
              onPressed: _openAiIntake,
              backgroundColor: JanSetuColors.electricBlue,
              icon: const Icon(Icons.mic_rounded, color: Colors.white),
              label: const Text('1-Tap Report Issue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
    );
  }

  Widget _buildTabBtn(int idx, String label, IconData icon) {
    final isSelected = _selectedTab == idx;
    return ElevatedButton.icon(
      onPressed: () => setState(() => _selectedTab = idx),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? JanSetuColors.electricBlue : JanSetuColors.darkSurface,
        foregroundColor: isSelected ? Colors.white : Colors.white70,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        elevation: isSelected ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: isSelected ? JanSetuColors.electricBlue : JanSetuColors.darkBorder),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 1:
        return _buildProjectsList();
      case 2:
        return const MyAreaView();
      case 0:
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildQuickActionChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSel = _selectedCategoryFilter == key;
    return InkWell(
      onTap: () => setState(() => _selectedCategoryFilter = key),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? JanSetuColors.saffronGold : JanSetuColors.darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSel ? JanSetuColors.saffronGold : JanSetuColors.darkBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSel ? Colors.black : Colors.white70,
            fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  /// Prompt 08 Streamlined Home Screen
  Widget _buildHomeScreen() {
    final userId = LocalPersistenceService.activeRole ?? 'USR-CTZ-8841';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80), // Padding for FAB
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Greeting & Primary CTA
          Container(
            margin: const EdgeInsets.all(JanSetuTheme.space16),
            padding: const EdgeInsets.all(JanSetuTheme.space24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.4), width: 1.5),
              boxShadow: [
                BoxShadow(color: JanSetuColors.electricBlue.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Good Morning ${LocalPersistenceService.userProfile?['name']?.toString() ?? 'Harsh'} 👋', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: JanSetuColors.emeraldGreen, size: 14),
                          SizedBox(width: 4),
                          Text('94.2% AI Accuracy', style: TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Adajan Ward 14, Surat • 14 Civic Assets Live • How can we improve your neighborhood today?', style: TextStyle(color: JanSetuColors.saffronGold, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                // Quick Micro-Stats Bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    Widget buildBox(String title, String val, Color valColor) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(val, style: TextStyle(color: valColor, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }
                    final box1 = buildBox('🚧 ACTIVE WORKS', '14 Projects', Colors.white);
                    final box2 = buildBox('💧 SANCTIONED', '₹2.50 Crore', JanSetuColors.emeraldGreen);
                    final box3 = buildBox('⚡ AI VERIFIED', '100% Escrow', JanSetuColors.electricBlue);
                    if (constraints.maxWidth > 500) {
                      return Row(children: [Expanded(child: box1), const SizedBox(width: 8), Expanded(child: box2), const SizedBox(width: 8), Expanded(child: box3)]);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [box1, const SizedBox(height: 8), box2, const SizedBox(height: 8), box3],
                    );
                  },
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openAiIntake,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: JanSetuColors.electricBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 6,
                      shadowColor: JanSetuColors.electricBlue.withValues(alpha: 0.5),
                    ),
                    icon: const Icon(Icons.campaign_rounded, size: 22),
                    label: const Text('📢 Report Need (1-Tap AI Voice/Text)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Development Score & What's Happening Around Me Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            padding: const EdgeInsets.all(JanSetuTheme.space16),
            decoration: BoxDecoration(
              color: JanSetuColors.slateNavy.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: JanSetuColors.saffronGold.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.analytics_rounded, color: JanSetuColors.saffronGold, size: 20),
                        SizedBox(width: 8),
                        Text('What is happening around me?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: JanSetuColors.saffronGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                      child: const Text('Score: 84.2/100', style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Surat West is currently undergoing 14 active smart-city infrastructure upgrades. Pothole repairs on Gaurav Path and 24x7 water pipeline installations in Adajan are prioritized by AI.', style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.3)),
                const SizedBox(height: 12),
                // Quick Actions Bar
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickActionChip('🚨 1-Tap Emergency', () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🚨 Emergency Civic Hotline: 1916 (Connected to Surat Municipal Control Room)'), backgroundColor: JanSetuColors.crimsonAlert));
                      }),
                      const SizedBox(width: 8),
                      _buildQuickActionChip('🗺️ Ward Map', () => setState(() => _selectedTab = 1)),
                      const SizedBox(width: 8),
                      _buildQuickActionChip('📞 Officer Contact', () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📞 Nodal Officer: Shri R.K. Patel (Adajan Ward 14) • Phone: +91 98240-XXXXX'), backgroundColor: JanSetuColors.electricBlue));
                      }),
                      const SizedBox(width: 8),
                      _buildQuickActionChip('💰 Budget Breakdown', () => setState(() => _selectedTab = 1)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Strictly Ordered Section 1: Nearby Active Projects
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('1. Nearby Active Projects', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                TextButton(
                  onPressed: () => setState(() => _selectedTab = 1),
                  child: const Text('View All ➔', style: TextStyle(color: JanSetuColors.electricBlue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (widget.syntheticProjects.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
              child: _buildProjectMiniCard(widget.syntheticProjects[0] as Map<String, dynamic>),
            ),

          const SizedBox(height: JanSetuTheme.space24),

          // Strictly Ordered Section 2: Nearby High Priority Needs (Community Feed)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            child: Text('2. Nearby High Priority Needs (Feed)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: JanSetuTheme.space12),
          // Interactive Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            child: Row(
              children: [
                _buildFilterChip('All', '🔥 All Needs'),
                const SizedBox(width: 8),
                _buildFilterChip('Critical', '🚨 High AI (>80)'),
                const SizedBox(width: 8),
                _buildFilterChip('DEPT_ROADS_HIGHWAYS', '🚧 Roads & Bridges'),
                const SizedBox(width: 8),
                _buildFilterChip('DEPT_WATER_RESOURCES', '💧 Water & Drainage'),
                const SizedBox(width: 8),
                _buildFilterChip('DEPT_POWER_ENERGY', '⚡ Energy & Light'),
              ],
            ),
          ),
          const SizedBox(height: JanSetuTheme.space12),
          Builder(
            builder: (context) {
              var feedNeeds = _needsList.where((n) => n['submittedByMe'] != true).toList();
              if (_selectedCategoryFilter == 'Critical') {
                feedNeeds = feedNeeds.where((n) => ((n['priorityScore'] as num?)?.toDouble() ?? 0) >= 80).toList();
              } else if (_selectedCategoryFilter != 'All') {
                feedNeeds = feedNeeds.where((n) => n['departmentId'] == _selectedCategoryFilter).toList();
              }
              if (feedNeeds.isEmpty) {
                return const JanSetuStateView(state: JanSetuUIState.empty);
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
                itemCount: feedNeeds.length,
                separatorBuilder: (_, _) => const SizedBox(height: JanSetuTheme.space16),
                itemBuilder: (context, index) {
                  final need = feedNeeds[index] as Map<String, dynamic>;
                  final originalIndex = LocalPersistenceService.needs.indexOf(need);
                  final upvotes = (need['upvoteCount'] as num?)?.toInt() ?? 15;
                  final commentsList = List<Map<String, dynamic>>.from(need['comments'] ?? []);
                  final commentCount = (need['commentCount'] as num?)?.toInt() ?? commentsList.length;
                  final isSup = originalIndex >= 0 ? LocalPersistenceService.isNeedSupported(originalIndex, userId) : false;
                  final aiRationale = need['aiIntelligence']?['rationale'] ??
                      'AI verified public infrastructure requirement reported by local citizen witnesses.';

                  return JanSetuNeedCard(
                    titleEnglish: need['titleEnglish'] ?? 'Infrastructure Grievance',
                    titleVernacular: need['titleVernacular'] ?? 'નાગરિક ફરિયાદ',
                    departmentId: need['departmentId'] ?? 'DEPT_ROADS_HIGHWAYS',
                    priorityScore: (need['priorityScore'] as num?)?.toDouble() ?? 80.0,
                    status: need['status'] ?? 'VERIFIED_AI',
                    upvoteCount: upvotes,
                    locationName: 'Adajan Ward 14',
                    aiSummary: aiRationale,
                    isSupported: isSup,
                    commentCount: commentCount,
                    onTap: () => _showEntityDetail(need, false),
                    onTrack: () => _showEntityDetail(need, false),
                    onSupport: () async {
                      if (originalIndex >= 0) {
                        final res = await LocalPersistenceService.toggleSupportNeed(originalIndex, userId);
                        setState(() {});
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res ? '👍 You supported this Development Need!' : 'Support removed.'),
                              backgroundColor: res ? JanSetuColors.emeraldGreen : Colors.grey[800],
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    onComment: () {
                      if (originalIndex >= 0) {
                        JanSetuCommentModal.show(
                          context,
                          needIndex: originalIndex,
                          needTitle: need['titleEnglish'] ?? 'Grievance',
                          comments: commentsList,
                          onCommentsUpdated: () => setState(() {}),
                        );
                      }
                    },
                  onShare: () {
                    JanSetuShareModal.show(
                      context,
                      title: need['titleEnglish'] ?? 'Civic Report',
                      location: 'Adajan Ward 14, Surat',
                      aiSummary: aiRationale,
                      status: need['status'] ?? 'Under Review',
                      supportCount: upvotes,
                      needId: need['needId'] ?? 'ND-2026-SRT-0104',
                    );
                  },
                );
              },
            );
            },
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Strictly Ordered Section 3: Community Updates
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            child: Text('3. Community Updates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: JanSetuTheme.space12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            child: JanSetuCard(
              backgroundColor: JanSetuColors.saffronGold.withValues(alpha: 0.1),
              border: BorderSide(color: JanSetuColors.saffronGold.withValues(alpha: 0.4)),
              child: const Row(
                children: [
                  Icon(Icons.event_note_rounded, color: JanSetuColors.saffronGold, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📢 Ward 14 Citizen Townhall This Sunday', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                        SizedBox(height: 2),
                        Text('Join SMC Zonal Officers & Hon. MP at Adajan Community Hall to review Tranche 2 drainage works.', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Strictly Ordered Section 4: Upcoming Development Plans
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            child: Text('4. Upcoming Development Plans', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: JanSetuTheme.space12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            child: JanSetuCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.eco_rounded, color: JanSetuColors.emeraldGreen, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🌱 FY 2026-27 Solar Promenade Extension', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                        SizedBox(height: 2),
                        Text('Proposed Outlay: ₹5.00 Crore • Adajan Riverfront green energy pathway currently undergoing environmental audit.', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Strictly Ordered Section 5: My Requests
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
            child: Text('5. My Requests (Your Submissions)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: JanSetuTheme.space12),
          Builder(
            builder: (context) {
              final submitted = _needsList.where((n) => n['submittedByMe'] == true).toList();
              final myNeed = submitted.isNotEmpty ? submitted[0] as Map<String, dynamic> : {
                'titleEnglish': 'My Grievance - Streetlight Defect',
                'titleVernacular': 'મારી ફરિયાદ - સ્ટ્રીટલાઈટ ખામી',
                'departmentId': 'DEPT_STREETLIGHTS',
                'priorityScore': 88.5,
                'status': 'VERIFIED_AI',
                'upvoteCount': 235,
              };
              final isSub = submitted.isNotEmpty;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: JanSetuTheme.space16),
                child: JanSetuNeedCard(
                  titleEnglish: myNeed['titleEnglish'] ?? 'My Grievance',
                  titleVernacular: myNeed['titleVernacular'] ?? 'મારી ફરિયાદ',
                  departmentId: myNeed['departmentId'] ?? 'DEPT_ROADS_HIGHWAYS',
                  priorityScore: (myNeed['priorityScore'] as num?)?.toDouble() ?? 88.5,
                  status: myNeed['status'] ?? 'VERIFIED_AI',
                  upvoteCount: (myNeed['upvoteCount'] as num?)?.toInt() ?? 235,
                  locationName: isSub ? 'Adajan Ward 14 (AI Geotagged)' : 'Adajan Ward 14 (Your Report)',
                  aiSummary: isSub ? (myNeed['aiIntelligence']?['rationale'] ?? 'AI verified public infrastructure requirement reported by you.') : 'Reported by you. AI verification complete, pending tender mobilization.',
                  isSupported: true,
                  onTap: () => _showEntityDetail(myNeed, false),
                  onTrack: () => _showEntityDetail(myNeed, false),
                ),
              );
            },
          ),
          const SizedBox(height: JanSetuTheme.space24),
        ],
      ),
    );
  }

  Widget _buildProjectMiniCard(Map<String, dynamic> prj) {
    return JanSetuProjectCard(
      projectName: prj['projectName'] ?? 'Capital Infrastructure Project',
      departmentId: prj['departmentId'] ?? 'DEPT_ROADS_HIGHWAYS',
      sanctionedBudgetINR: (prj['financials']?['sanctionedBudgetINR'] as num?)?.toDouble() ?? 1000000.0,
      disbursedAmountINR: (prj['financials']?['disbursedAmountINR'] as num?)?.toDouble() ?? 400000.0,
      progressPercentage: (prj['progressPercentage'] as num?)?.toInt() ?? 40,
      status: prj['currentStatus'] ?? 'IN_EXECUTION',
      onTap: () => _showEntityDetail(prj, true),
    );
  }

  Widget _buildProjectsList() {
    if (widget.syntheticProjects.isEmpty) {
      return const JanSetuStateView(state: JanSetuUIState.empty);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(JanSetuTheme.space16),
      itemCount: widget.syntheticProjects.length,
      separatorBuilder: (_, _) => const SizedBox(height: JanSetuTheme.space12),
      itemBuilder: (context, index) {
        final prj = widget.syntheticProjects[index] as Map<String, dynamic>;
        return JanSetuProjectCard(
          projectName: prj['projectName'] ?? 'Capital Infrastructure Project',
          departmentId: prj['departmentId'] ?? 'DEPT_ROADS_HIGHWAYS',
          sanctionedBudgetINR: (prj['financials']?['sanctionedBudgetINR'] as num?)?.toDouble() ?? 1000000.0,
          disbursedAmountINR: (prj['financials']?['disbursedAmountINR'] as num?)?.toDouble() ?? 400000.0,
          progressPercentage: (prj['progressPercentage'] as num?)?.toInt() ?? 40,
          status: prj['currentStatus'] ?? 'IN_EXECUTION',
          onTap: () => _showEntityDetail(prj, true),
        );
      },
    );
  }
}
