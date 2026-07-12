import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import 'spatial_tree_navigator.dart';
import 'escrow_audit_ledger.dart';
import '../../core/config/service_locator.dart';
import '../../services/local_persistence_service.dart';
import '../shared/entity_detail_modal.dart';
import '../shared/floating_ai_assistant.dart';

/// Admin Command Panel Web Scaffold (AdminPanelModule)
/// Executive State Intelligence Platform ("Is the State improving?")
/// Features 10 Role-Tailored Workspaces, visual KPI dashboards, drill-down modals, and PFMS Escrow controls.
class AdminPanelModule extends StatefulWidget {
  final List<dynamic> syntheticNeeds;
  final List<dynamic> syntheticProjects;

  const AdminPanelModule({
    super.key,
    required this.syntheticNeeds,
    required this.syntheticProjects,
  });

  @override
  State<AdminPanelModule> createState() => _AdminPanelModuleState();
}

class _AdminPanelModuleState extends State<AdminPanelModule> {
  int _selectedTierIndex = 6; // Default Tier 7: Adajan Ward 14
  late Map<String, dynamic> _selectedTierData;
  int _activeTab = 0; // 0..9 (10 Executive Workspaces)

  late List<Map<String, dynamic>> _ledgerProjects;
  String _globalSearchQuery = '';
  String _alertFilter = 'ALL';
  String _userRoleFilter = 'ALL';
  String _gisLayer = 'DEVELOPMENT_HEATMAP';

  // State Intelligence Data
  late List<Map<String, dynamic>> _districts;
  late List<Map<String, dynamic>> _mps;
  late List<Map<String, dynamic>> _departments;
  late List<Map<String, dynamic>> _alerts;
  late List<Map<String, dynamic>> _auditLogs;
  late List<Map<String, dynamic>> _userDirectory;
  late List<Map<String, dynamic>> _monitoredProjects;

  String _stateAiSummary = '🤖 **State Intelligence Copilot Executive Briefing:**\n'
      '• **Overall Governance Index:** 86.4 / 100 (Up +3.2 MoM across 33 districts)\n'
      '• **Escrow Verification Health:** 99.4% automated via AI Geo-witnessing\n'
      '• **Immediate Action Required:** Resolve escrow freeze on Surat Flyover Extension Stage 3 (₹1.5Cr locked due to geotag discrepancy).\n'
      '• **Fiscal Outlay Forecast:** Expected +22% grievance surge in coastal districts due to monsoon arrival.';
  bool _isLoadingStateSummary = false;

  Future<void> _fetchStateAiSummary() async {
    setState(() => _isLoadingStateSummary = true);
    try {
      final aiRepo = ServiceLocator.instance.aiRepository;
      final reply = await aiRepo.chatAssistant('Generate comprehensive executive state report and briefing', [], role: 'ADMIN');
      if (mounted) {
        setState(() {
          _stateAiSummary = reply;
          _isLoadingStateSummary = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingStateSummary = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedTierData = SpatialTreeNavigator.hierarchyTiers[_selectedTierIndex];
    _initLedgerProjects();
    _initSyntheticStateData();
  }

  void _initLedgerProjects() {
    if (LocalPersistenceService.ledgerProjects.isNotEmpty) {
      _ledgerProjects = List.from(LocalPersistenceService.ledgerProjects);
    } else {
      _ledgerProjects = [
        {
          'projectName': 'Gaurav Path Express Flyover Construction',
          'contractor': 'L&T Infrastructure Ltd',
          'escrowId': 'PFMS-ESC-2026-8891',
          'sanctionedLakhs': 90.0,
          'disbursedLakhs': 18.0,
          'status': 'IN_EXECUTION',
          'tranche1': 'RELEASED',
          'tranche2': 'PENDING_AUDIT_RELEASE',
          'tranche3': 'ESCROW_LOCKED',
        },
        {
          'projectName': 'Adajan Ward 14 Smart Water Metering Grid',
          'contractor': 'Tata Projects & Sensors',
          'escrowId': 'PFMS-ESC-2026-9044',
          'sanctionedLakhs': 45.0,
          'disbursedLakhs': 45.0,
          'status': 'COMPLETED_RELEASED',
          'tranche1': 'RELEASED',
          'tranche2': 'RELEASED',
          'tranche3': 'RELEASED',
        },
        {
          'projectName': 'Surat West Stormwater Drainage Resilience Grid',
          'contractor': 'Gujarat Civil Works Corp',
          'escrowId': 'PFMS-ESC-2026-7721',
          'sanctionedLakhs': 60.0,
          'disbursedLakhs': 12.0,
          'status': 'IN_EXECUTION',
          'tranche1': 'RELEASED',
          'tranche2': 'PENDING_AUDIT_RELEASE',
          'tranche3': 'ESCROW_LOCKED',
        },
      ];
    }
  }

  void _initSyntheticStateData() {
    _districts = [
      {'name': 'Surat District', 'code': 'SRT-01', 'score': 86.4, 'projects': 14, 'needs': 42, 'budget': '₹420 Cr', 'satisfaction': '94.1%', 'health': 'OPTIMAL', 'priority': 'HIGH', 'issues': 'Monsoon Drainage, Flyover Traffic'},
      {'name': 'Ahmedabad District', 'code': 'AMD-02', 'score': 82.1, 'projects': 18, 'needs': 68, 'budget': '₹510 Cr', 'satisfaction': '89.5%', 'health': 'ATTENTION', 'priority': 'CRITICAL', 'issues': 'Metro Expansion Feeder, Water Quality'},
      {'name': 'Vadodara District', 'code': 'VAD-03', 'score': 84.8, 'projects': 11, 'needs': 31, 'budget': '₹280 Cr', 'satisfaction': '91.2%', 'health': 'OPTIMAL', 'priority': 'MEDIUM', 'issues': 'Vishwamitri Riverfront, Smart Solar Grid'},
      {'name': 'Rajkot District', 'code': 'RJK-04', 'score': 79.5, 'projects': 9, 'needs': 45, 'budget': '₹210 Cr', 'satisfaction': '86.4%', 'health': 'ATTENTION', 'priority': 'HIGH', 'issues': 'AIIMS Access Road, Industrial Effluents'},
      {'name': 'Gandhinagar District', 'code': 'GND-05', 'score': 91.0, 'projects': 15, 'needs': 18, 'budget': '₹350 Cr', 'satisfaction': '96.8%', 'health': 'EXCELLENT', 'priority': 'LOW', 'issues': 'GIFT City Phase 3 Transport Sync'},
      {'name': 'Bhavnagar District', 'code': 'BHV-06', 'score': 76.2, 'projects': 7, 'needs': 39, 'budget': '₹150 Cr', 'satisfaction': '84.0%', 'health': 'MODERATE', 'priority': 'MEDIUM', 'issues': 'Alang Shipyard Coastal Highway'},
      {'name': 'Jamnagar District', 'code': 'JAM-07', 'score': 88.3, 'projects': 12, 'needs': 24, 'budget': '₹310 Cr', 'satisfaction': '93.5%', 'health': 'OPTIMAL', 'priority': 'LOW', 'issues': 'Refinery Corridor Green Belt'},
      {'name': 'Junagadh District', 'code': 'JUN-08', 'score': 74.8, 'projects': 6, 'needs': 52, 'budget': '₹130 Cr', 'satisfaction': '81.2%', 'health': 'ATTENTION', 'priority': 'CRITICAL', 'issues': 'Girnar Ropeway Parking & Rural Water'},
    ];

    _mps = [
      {'name': 'Hon. C.R. Patil', 'constituency': 'Surat West', 'score': 94.5, 'projects': 14, 'budget': '₹5.00 Cr (88% Utilized)', 'satisfaction': '94.1%', 'pending': 12, 'delayed': 1, 'badge': 'RANK #1 LEADER'},
      {'name': 'Shri Amit Shah', 'constituency': 'Gandhinagar', 'score': 91.2, 'projects': 15, 'budget': '₹5.00 Cr (92% Utilized)', 'satisfaction': '96.8%', 'pending': 8, 'delayed': 0, 'badge': 'OPTIMAL EXECUTION'},
      {'name': 'Smt. Poonamben Maadam', 'constituency': 'Jamnagar', 'score': 88.0, 'projects': 12, 'budget': '₹5.00 Cr (82% Utilized)', 'satisfaction': '93.5%', 'pending': 15, 'delayed': 2, 'badge': 'VERY GOOD'},
      {'name': 'Shri Mansukh Mandaviya', 'constituency': 'Porbandar', 'score': 85.4, 'projects': 10, 'budget': '₹5.00 Cr (76% Utilized)', 'satisfaction': '89.0%', 'pending': 22, 'delayed': 1, 'badge': 'STABLE'},
      {'name': 'Shri Parshottam Rupala', 'constituency': 'Rajkot', 'score': 79.5, 'projects': 9, 'budget': '₹5.00 Cr (64% Utilized)', 'satisfaction': '86.4%', 'pending': 31, 'delayed': 3, 'badge': 'REQUIRES REVIEW'},
    ];

    _departments = [
      {'name': 'Roads & Highways Dept', 'icon': Icons.edit_road_rounded, 'score': 78.0, 'projects': 210, 'delay': '6.2 Days Avg', 'budget': '₹620 Cr', 'officers': 340, 'risk': 'MODERATE HIGH', 'trend': 0.78, 'aiRec': 'Expedite bitumen testing audits in Surat & Rajkot zones.'},
      {'name': 'Smart Water & Drainage', 'icon': Icons.water_drop_rounded, 'score': 98.2, 'projects': 180, 'delay': '1.1 Days Avg', 'budget': '₹410 Cr', 'officers': 280, 'risk': 'LOW', 'trend': 0.98, 'aiRec': 'Expand IoT water meters from Ward 14 to all municipal corporations.'},
      {'name': 'Education & Schools', 'icon': Icons.school_rounded, 'score': 89.4, 'projects': 140, 'delay': '2.4 Days Avg', 'budget': '₹290 Cr', 'officers': 190, 'risk': 'LOW', 'trend': 0.89, 'aiRec': 'Fast-track STEM laboratory computer allocations.'},
      {'name': 'Healthcare & Hospitals', 'icon': Icons.health_and_safety_rounded, 'score': 92.1, 'projects': 95, 'delay': '1.8 Days Avg', 'budget': '₹310 Cr', 'officers': 220, 'risk': 'LOW', 'trend': 0.92, 'aiRec': 'Deploy mobile telemedicine vans to Dang and tribal belts.'},
      {'name': 'Power Grid & Solar', 'icon': Icons.solar_power_rounded, 'score': 94.6, 'projects': 110, 'delay': '1.5 Days Avg', 'budget': '₹350 Cr', 'officers': 160, 'risk': 'LOW', 'trend': 0.95, 'aiRec': 'Solar rooftop grid saturation target 100% on schedule.'},
      {'name': 'Public Transport & Metro', 'icon': Icons.train_rounded, 'score': 81.5, 'projects': 45, 'delay': '4.8 Days Avg', 'budget': '₹480 Cr', 'officers': 110, 'risk': 'MODERATE', 'trend': 0.81, 'aiRec': 'Resolve last-mile feeder bus route overlaps in Ahmedabad.'},
      {'name': 'Agriculture & Irrigation', 'icon': Icons.agriculture_rounded, 'score': 86.0, 'projects': 130, 'delay': '3.2 Days Avg', 'budget': '₹220 Cr', 'officers': 210, 'risk': 'LOW', 'trend': 0.86, 'aiRec': 'Saurashtra Narmada canal desilting required before July.'},
      {'name': 'Digital Infrastructure', 'icon': Icons.wifi_rounded, 'score': 96.8, 'projects': 88, 'delay': '0.8 Days Avg', 'budget': '₹140 Cr', 'officers': 90, 'risk': 'LOW', 'trend': 0.97, 'aiRec': '5G fiber optic municipal rollout reaching 99.4% coverage.'},
    ];

    _alerts = [
      {'id': 'ALT-01', 'title': 'Budget Exhausted: Varachha Ward 8', 'desc': 'MPLADS tranche depleted for Stormwater Drainage. Emergency ₹50L allocation requested.', 'type': 'CRITICAL', 'time': '10m ago', 'read': false},
      {'id': 'ALT-02', 'title': 'Department Delay: Roads & Highways', 'desc': 'Saurashtra Highway overlay delayed by 8 days due to material transport disruption.', 'type': 'WARNING', 'time': '1h ago', 'read': false},
      {'id': 'ALT-03', 'title': 'Officer Overloaded: Shri R.K. Joshi', 'desc': 'Zonal Engineer assigned to 18 simultaneous inspections in Surat. Re-routing recommended.', 'type': 'WARNING', 'time': '3h ago', 'read': false},
      {'id': 'ALT-04', 'title': 'AI Detected Duplicate Project Tender', 'desc': 'Tender #TR-9902 (Adajan Water Pipeline) overlaps 94% with ongoing contract #TR-8841.', 'type': 'CRITICAL', 'time': '5h ago', 'read': false},
      {'id': 'ALT-05', 'title': 'Monsoon Waterlogging Alert: Coastal Zonal', 'desc': 'IMD forecast indicates heavy rain. Direct emergency drainage pumping units to Surat West.', 'type': 'INFO', 'time': '1d ago', 'read': true},
      {'id': 'ALT-06', 'title': 'PFMS Escrow Tranche Ready for Release', 'desc': 'Vesu Solar Grid Phase 2 AI witness audit corroborated. ₹35L ready for disbursal.', 'type': 'INFO', 'time': '1d ago', 'read': true},
    ];

    _auditLogs = [
      {'action': 'Authorized Tranche Release #1', 'target': 'Gaurav Path Express Flyover', 'user': 'Shri K.L. Mehta, IAS', 'time': 'Today, 11:42 AM', 'hash': '0x8f9a...44c1'},
      {'action': 'Frozen Escrow Account', 'target': 'Surat Flyover Extension Stage 3', 'user': 'State Vigilance AI', 'time': 'Yesterday, 04:15 PM', 'hash': '0x3a1b...99d2'},
      {'action': 'Approved MPLADS Allocation', 'target': 'Adajan Ward 14 Smart Water Metering', 'user': 'Hon. C.R. Patil, MP', 'time': '04 Jul 2026', 'hash': '0x7e2c...11a8'},
      {'action': 'Contractor SLA Penalty Activated', 'target': 'L&T Infrastructure Ltd (Saurashtra Grid)', 'user': 'Chief Engineer WRD', 'time': '02 Jul 2026', 'hash': '0x1c4e...88b5'},
      {'action': 'Citizen Grievance Upgraded to Tender', 'target': 'Varachha Ward 8 Drainage Deficit', 'user': 'AI Governance Copilot', 'time': '01 Jul 2026', 'hash': '0x9d8f...33e4'},
    ];

    _userDirectory = [
      {'name': 'Shri K.L. Mehta, IAS', 'role': 'State Administrator', 'district': 'Gandhinagar (HQ)', 'email': 'cs.gujarat@gov.in', 'status': 'ACTIVE', 'id': 'ADM-001'},
      {'name': 'Hon. C.R. Patil', 'role': 'Member of Parliament', 'district': 'Surat West', 'email': 'cr.patil@sansad.nic.in', 'status': 'ACTIVE', 'id': 'MP-SRT-01'},
      {'name': 'Shri R.K. Joshi', 'role': 'Zonal Executive Engineer', 'district': 'Surat Corporation', 'email': 'rk.joshi@suratmunicipal.org', 'status': 'ACTIVE', 'id': 'ENG-SRT-14'},
      {'name': 'Dr. Smt. Neha Desai', 'role': 'Chief Medical Officer', 'district': 'Ahmedabad Zone', 'email': 'n.desai@health.gujarat.gov.in', 'status': 'ACTIVE', 'id': 'OFF-AMD-09'},
      {'name': 'Shri Vikram Patel', 'role': 'Contractor Supervisor', 'district': 'L&T Infra Group', 'email': 'vpatel@lntecc.com', 'status': 'SUSPENDED', 'id': 'CON-8841'},
      {'name': 'Aarav Shah', 'role': 'Verified Citizen Lead', 'district': 'Adajan Ward 14', 'email': 'aarav.shah@gmail.com', 'status': 'ACTIVE', 'id': 'CIT-9912'},
    ];

    _monitoredProjects = [
      {'title': 'Gaurav Path Express Flyover', 'district': 'Surat', 'dept': 'Roads & Highways', 'budget': '₹90.0 Lakh', 'progress': 0.65, 'risk': 'MODERATE', 'contractor': 'L&T Infra Ltd', 'officer': 'Shri R.K. Joshi', 'status': 'IN_EXECUTION'},
      {'title': 'Adajan Ward 14 Smart Water Metering Grid', 'district': 'Surat', 'dept': 'Smart Water & Drainage', 'budget': '₹45.0 Lakh', 'progress': 1.0, 'risk': 'LOW', 'contractor': 'Tata Projects & Sensors', 'officer': 'Shri A.M. Vyas', 'status': 'COMPLETED'},
      {'title': 'Surat West Stormwater Drainage Grid', 'district': 'Surat', 'dept': 'Smart Water & Drainage', 'budget': '₹60.0 Lakh', 'progress': 0.35, 'risk': 'HIGH', 'contractor': 'Gujarat Civil Works', 'officer': 'Shri R.K. Joshi', 'status': 'IN_EXECUTION'},
      {'title': 'Saurashtra Narmada Pipeline Extension', 'district': 'Rajkot', 'dept': 'Agriculture & Irrigation', 'budget': '₹120.0 Lakh', 'progress': 0.45, 'risk': 'HIGH', 'contractor': 'Sadbhav Eng Group', 'officer': 'Shri P.V. Mehta', 'status': 'PAUSED'},
      {'title': 'GIFT City Phase 3 Autonomous Transport Sync', 'district': 'Gandhinagar', 'dept': 'Public Transport', 'budget': '₹250.0 Lakh', 'progress': 0.85, 'risk': 'LOW', 'contractor': 'Siemens Mobility', 'officer': 'Dr. K.S. Rao', 'status': 'IN_EXECUTION'},
    ];
  }

  void _handleTierSelected(int index, Map<String, dynamic> data) {
    setState(() {
      _selectedTierIndex = index;
      _selectedTierData = data;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🌐 Spatial Tree filtered to ${data['name']} (${data['id']})'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _authorizeTranche(int index) {
    setState(() {
      final prj = _ledgerProjects[index];
      if (prj['tranche2'] == 'PENDING_AUDIT_RELEASE') {
        prj['tranche2'] = 'RELEASED';
        prj['disbursedLakhs'] = (prj['disbursedLakhs'] as num).toDouble() + ((prj['sanctionedLakhs'] as num).toDouble() * 0.50);
        prj['status'] = 'MILESTONE_VERIFIED';
      } else if (prj['tranche3'] != 'RELEASED') {
        prj['tranche3'] = 'RELEASED';
        prj['disbursedLakhs'] = (prj['sanctionedLakhs'] as num).toDouble();
        prj['status'] = 'COMPLETED_RELEASED';
      }
      LocalPersistenceService.updateLedgerProject(index, prj);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Authorized milestone escrow tranche! Disbursed funds via PFMS blockchain smart contract.'),
        backgroundColor: JanSetuColors.emeraldGreen,
      ),
    );
  }

  void _freezeEscrow(int index) {
    setState(() {
      final prj = _ledgerProjects[index];
      prj['status'] = 'ESCROW_FROZEN';
      if (prj['tranche2'] == 'PENDING_AUDIT_RELEASE') {
        prj['tranche2'] = 'ESCROW_LOCKED';
      }
      LocalPersistenceService.updateLedgerProject(index, prj);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔒 Escrow frozen! State Vigilance quality audit inquiry initiated for ${_ledgerProjects[index]['contractor']}.'),
        backgroundColor: JanSetuColors.crimsonAlert,
      ),
    );
  }

  void _showDetailModal(String id, String title, String dept, String status, {bool isProject = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EntityDetailModal(
        entity: {
          'id': id,
          'title': title,
          'departmentId': dept,
          'status': status,
          'description': 'State Intelligence & PFMS Escrow Audit ledger metadata. AI-verified milestone completion with 3-stage blockchain smart contract locks.',
          'estimatedCostINR': 9000000.0,
          'estimatedBeneficiaries': 120000,
          'confidence': 98.4,
          'duplicateScore': 1.1,
          'upvotes': 340,
          'witnesses': 89,
        },
        isProject: isProject,
      ),
    );
  }

  void _showDistrictDetailModal(Map<String, dynamic> district) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: JanSetuColors.darkBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: JanSetuColors.saffronGold, width: 2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: JanSetuColors.saffronGold.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.location_city_rounded, color: JanSetuColors.saffronGold, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${district['name']} (${district['code']}) — Intelligence Drill-Down', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      Text('Development Score: ${district['score']}/100 • Citizen Satisfaction: ${district['satisfaction']}', style: const TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close_rounded, color: Colors.grey), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(color: JanSetuColors.darkBorder, height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildSectionHeader('📊 District Executive Overview'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildMiniStatBox('Active Projects', '${district['projects']}', Icons.construction_rounded, JanSetuColors.electricBlue),
                      _buildMiniStatBox('Open Needs', '${district['needs']}', Icons.record_voice_over_rounded, JanSetuColors.saffronGold),
                      _buildMiniStatBox('Allocated Outlay', '${district['budget']}', Icons.account_balance_wallet_rounded, JanSetuColors.emeraldGreen),
                      _buildMiniStatBox('Health Status', '${district['health']}', Icons.verified_user_rounded, district['health'] == 'OPTIMAL' || district['health'] == 'EXCELLENT' ? JanSetuColors.emeraldGreen : JanSetuColors.crimsonAlert),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('🤖 Gemini 2.5 Pro District AI Insights'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡 AI Strategic Recommendation:', style: TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text('District exhibits rapid SLA resolution velocity in urban centers, but rural water connectivity in ${district['name']} requires urgent ₹35 Lakh emergency allocation before monsoon saturation. Top citizen reported issues: ${district['issues']}.', style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('🚧 Active District Works & Pipeline'),
                  const SizedBox(height: 12),
                  ..._monitoredProjects.where((p) => p['district'] == district['name'].toString().replaceAll(' District', '') || district['code'] == 'SRT-01').map((p) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: JanSetuColors.darkBorder)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('${p['dept']} • Budget: ${p['budget']} • Contractor: ${p['contractor']}', style: const TextStyle(color: Colors.white60, fontSize: 12), overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: JanSetuColors.electricBlue.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                              child: Text('${((p['progress'] as double) * 100).toInt()}% Done', style: const TextStyle(color: JanSetuColors.electricBlue, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMpDetailModal(Map<String, dynamic> mp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: JanSetuColors.electricBlue.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.person_pin_circle_rounded, color: JanSetuColors.electricBlue, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${mp['name']} (${mp['constituency']})', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      Text('Development Score: ${mp['score']}/100 • Performance: ${mp['badge']}', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close_rounded, color: Colors.grey), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(color: JanSetuColors.darkBorder, height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildSectionHeader('📈 MP Constituency Execution Metrics'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildMiniStatBox('Sanctioned Works', '${mp['projects']}', Icons.work_history_rounded, JanSetuColors.electricBlue),
                      _buildMiniStatBox('MPLADS Outlay', '${mp['budget']}', Icons.savings_rounded, JanSetuColors.emeraldGreen),
                      _buildMiniStatBox('Citizen Approval', '${mp['satisfaction']}', Icons.thumb_up_alt_rounded, JanSetuColors.saffronGold),
                      _buildMiniStatBox('Delayed Tenders', '${mp['delayed']}', Icons.timer_off_rounded, mp['delayed'] == 0 ? JanSetuColors.emeraldGreen : JanSetuColors.crimsonAlert),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('📜 Sanctioned Works History & Tranche Status'),
                  const SizedBox(height: 12),
                  ..._ledgerProjects.map((prj) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: JanSetuColors.darkBorder)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prj['projectName'] ?? 'Project', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('Escrow ID: ${prj['escrowId']} • Contractor: ${prj['contractor']}', style: const TextStyle(color: Colors.white60, fontSize: 11), overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                              child: Text(prj['status'] ?? 'VERIFIED', style: const TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JanSetuColors.slateNavy,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;
              if (isMobile) {
                return Column(
                  children: [
                    // Sleek Top Mobile Tier Selector Pill Bar
                    Container(
                      height: 52,
                      color: const Color(0xFF0D1424),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: SpatialTreeNavigator.hierarchyTiers.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final tier = entry.value;
                            final isSel = _selectedTierIndex == idx;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => _handleTierSelected(idx, tier),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSel ? JanSetuColors.saffronGold : Colors.white10,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: isSel ? JanSetuColors.saffronGold : Colors.grey.withAlpha(51)),
                                  ),
                                  child: Text(
                                    'T${tier['tier']}: ${tier['name']}',
                                    style: TextStyle(
                                      color: isSel ? JanSetuColors.slateNavy : Colors.white,
                                      fontSize: 12,
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Divider(color: JanSetuColors.darkBorder, height: 1),
                    Expanded(
                      child: _buildMainContentArea(isMobile: true),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  // Spatial Hierarchy Tree (Preserved for 100% E2E test compatibility)
                  SpatialTreeNavigator(
                    selectedTierIndex: _selectedTierIndex,
                    onTierSelected: _handleTierSelected,
                  ),
                  // Main Executive Workspace
                  Expanded(
                    child: _buildMainContentArea(isMobile: false),
                  ),
                ],
              );
            },
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

  Widget _buildMainContentArea({required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 12 : JanSetuTheme.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive Top Bar Suite & Workspace Switcher
          _buildExecutiveTopBar(isMobile),
          const SizedBox(height: 14),
          // Active Workspace Switcher Pills (10 Workspaces)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildWorkspaceTab('0. Home Command', 0, Icons.dashboard_rounded),
                _buildWorkspaceTab('1. State & Districts', 1, Icons.map_rounded),
                _buildWorkspaceTab('2. MPs & Constituencies', 2, Icons.how_to_reg_rounded),
                _buildWorkspaceTab('3. Dept Intelligence', 3, Icons.account_balance_rounded),
                _buildWorkspaceTab('4. Budget & Escrow', 4, Icons.account_balance_wallet_rounded),
                _buildWorkspaceTab('5. Projects & Audit', 5, Icons.rule_folder_rounded),
                _buildWorkspaceTab('6. Alert Center', 6, Icons.notification_important_rounded),
                _buildWorkspaceTab('7. User Directory', 7, Icons.manage_accounts_rounded),
                _buildWorkspaceTab('8. GIS Twin', 8, Icons.layers_rounded),
                _buildWorkspaceTab('9. Reports & Settings', 9, Icons.settings_applications_rounded),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Workspace Content Renderer
          Expanded(
            child: _renderActiveWorkspace(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveTopBar(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: JanSetuColors.saffronGold.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: JanSetuColors.saffronGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.shield_rounded, color: JanSetuColors.saffronGold, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('STATE INTELLIGENCE PLATFORM — COMMAND CENTER', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('Active Tier: ${_selectedTierData['name']} • Gujarat 33 Districts', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: '🔍 Global Search projects, MPs, officers...',
                      hintStyle: const TextStyle(color: Colors.white54, fontSize: 11),
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    ),
                    onChanged: (val) => setState(() => _globalSearchQuery = val),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16), border: Border.all(color: JanSetuColors.emeraldGreen)),
                child: const Text('● LIVE STATE FEED', style: TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceTab(String label, int tabIndex, IconData icon) {
    final isSelected = _activeTab == tabIndex;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _activeTab = tabIndex),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? JanSetuColors.saffronGold : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? JanSetuColors.saffronGold : Colors.grey.withAlpha(51)),
            boxShadow: isSelected ? [BoxShadow(color: JanSetuColors.saffronGold.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? JanSetuColors.slateNavy : Colors.grey),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? JanSetuColors.slateNavy : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderActiveWorkspace(bool isMobile) {
    switch (_activeTab) {
      case 0:
        return _buildWorkspace0Home(isMobile);
      case 1:
        return _buildWorkspace1Districts(isMobile);
      case 2:
        return _buildWorkspace2MPs(isMobile);
      case 3:
        return _buildWorkspace3Departments(isMobile);
      case 4:
        return _buildWorkspace4Budget(isMobile);
      case 5:
        return _buildWorkspace5ProjectsAndAudit(isMobile);
      case 6:
        return _buildWorkspace6Alerts(isMobile);
      case 7:
        return _buildWorkspace7UserDirectory(isMobile);
      case 8:
        return _buildWorkspace8GisTwin(isMobile);
      case 9:
        return _buildWorkspace9ReportsAndSettings(isMobile);
      default:
        return _buildWorkspace0Home(isMobile);
    }
  }

  // ==========================================
  // WORKSPACE 0: STATE HOME COMMAND CENTER
  // ==========================================
  Widget _buildWorkspace0Home(bool isMobile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Greeting & State Health Answer ("Is the State improving?")
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF141F36), JanSetuColors.saffronGold.withValues(alpha: 0.15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: JanSetuColors.saffronGold.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: JanSetuColors.saffronGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.wb_sunny_rounded, color: JanSetuColors.saffronGold, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good Morning State Administrator — Shri K.L. Mehta, IAS 👋',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Today: 07 July 2026 • State: Gujarat (33 Districts) • Statewide Spatial Grid Active',
                            style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 13, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: JanSetuColors.emeraldGreen.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: JanSetuColors.emeraldGreen, width: 1.5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up_rounded, color: JanSetuColors.emeraldGreen, size: 18),
                      SizedBox(width: 8),
                      Flexible(child: Text('IS THE STATE IMPROVING? YES (+14% MoM SLA Velocity)', style: TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // AI State Intelligence Copilot Briefing Box
          JanSetuCard(
            backgroundColor: JanSetuColors.darkSurface,
            border: BorderSide(color: JanSetuColors.electricBlue.withValues(alpha: 0.5), width: 1.5),
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
                          decoration: BoxDecoration(color: JanSetuColors.electricBlue.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.auto_awesome_rounded, color: JanSetuColors.electricBlue, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Flexible(
                          child: Text('AI State Intelligence Copilot Executive Briefing', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: _isLoadingStateSummary
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: JanSetuColors.electricBlue))
                              : const Icon(Icons.refresh_rounded, color: JanSetuColors.electricBlue, size: 18),
                          tooltip: 'Refresh AI State Summary',
                          onPressed: _isLoadingStateSummary ? null : _fetchStateAiSummary,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: const Text('✨ Live PFMS Sync', style: TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: JanSetuColors.darkBorder, height: 24),
                Text(
                  _stateAiSummary,
                  style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 4 Primary Executive KPI Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final w = (constraints.maxWidth - (isMobile ? 12 : 36)) / (isMobile ? 2 : 4);
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildKpiCard('OVERALL DEV SCORE', '86.4 / 100', 'Top 3 State Index', Icons.analytics_rounded, JanSetuColors.emeraldGreen, w),
                  _buildKpiCard('AI HEALTH SCORE', '98.2%', 'Automated Escrow Audits', Icons.auto_awesome_rounded, JanSetuColors.electricBlue, w),
                  _buildKpiCard('CITIZEN SATISFACTION', '94.1%', '+2.4% vs Last Qtr', Icons.thumb_up_alt_rounded, JanSetuColors.saffronGold, w),
                  _buildKpiCard('BUDGET UTILIZATION', '₹1,420 / ₹1,800 Cr', '78.8% Disbursed Velocity', Icons.savings_rounded, JanSetuColors.emeraldGreen, w),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          // Critical Alerts & High Priority Districts Row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return Column(
                  children: [
                    _buildCriticalAlertsBanner(),
                    const SizedBox(height: 16),
                    _buildHighPriorityDistrictsGrid(),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildCriticalAlertsBanner()),
                  const SizedBox(width: 16),
                  Expanded(flex: 6, child: _buildHighPriorityDistrictsGrid()),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          // Embedded PFMS Smart Escrow Audit Ledger (100% E2E test compatibility!)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: JanSetuColors.darkBorder)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(child: Text('⚡ STATE FISCAL OUTLAY — TRANCHE RELEASE QUEUE', style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                    SizedBox(width: 8),
                    Flexible(child: Text('1-Tap Blockchain Tranche Authorization', style: TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 380,
                  child: EscrowAuditLedger(
                    selectedTierData: _selectedTierData,
                    ledgerProjects: _ledgerProjects,
                    onAuthorizeTranche: _authorizeTranche,
                    onFreezeEscrow: _freezeEscrow,
                    onInspectProject: (prj) => _showDetailModal(prj['escrowId'] ?? 'PFMS-ESC-001', prj['projectName'] ?? 'Project', 'DEPT_URBAN_DEV', prj['status'] ?? 'IN_EXECUTION', isProject: true),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Departments Requiring Attention & Budget Risks
          _buildSectionHeader('⚠️ Departments Requiring Attention & Fiscal Budget Risks'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildRiskCard('Roads & Highways Dept', 'SLA Efficiency: 78% • 6.2 Days Avg Delay', 'Contractor bitumen quality audits required in Surat & Rajkot.', Icons.edit_road_rounded, JanSetuColors.crimsonAlert),
              _buildRiskCard('Surat Flyover Extension', 'Escrow Locked: ₹1.5 Crore in Stage 3', 'Geotag audit failure. Emergency quality inspection initiated.', Icons.lock_clock_rounded, JanSetuColors.crimsonAlert),
              _buildRiskCard('Saurashtra Water Grid', 'Contractor SLA Breach Penalty Activated', '8 days overdue target. L&T Infrastructure notified.', Icons.warning_amber_rounded, JanSetuColors.saffronGold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String sub, IconData icon, Color col, double width) {
    return Container(
      width: width.clamp(140, 400),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: col.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [BoxShadow(color: col.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: TextStyle(color: col, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 4),
              Icon(icon, color: col, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 11), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildCriticalAlertsBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: JanSetuColors.crimsonAlert.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notification_important_rounded, color: JanSetuColors.crimsonAlert, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('🚨 LIVE CRITICAL GOVERNANCE ALERTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          ..._alerts.take(3).map((a) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8), border: Border.all(color: a['type'] == 'CRITICAL' ? JanSetuColors.crimsonAlert : JanSetuColors.saffronGold, width: 0.8)),
                child: Row(
                  children: [
                    Icon(a['type'] == 'CRITICAL' ? Icons.error_rounded : Icons.warning_amber_rounded, color: a['type'] == 'CRITICAL' ? JanSetuColors.crimsonAlert : JanSetuColors.saffronGold, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                          Text(a['desc']!, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(a['time']!, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              )),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => setState(() => _activeTab = 6), child: const Text('View All Alerts →', style: TextStyle(color: JanSetuColors.saffronGold, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }

  Widget _buildHighPriorityDistrictsGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.location_city_rounded, color: JanSetuColors.electricBlue, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text('🏙️ HIGH PRIORITY DISTRICTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Flexible(child: Text('Tap to Drill-Down', style: TextStyle(color: Colors.white54, fontSize: 11), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _districts.take(4).map((d) => InkWell(
                  onTap: () => _showDistrictDetailModal(d),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 190,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10), border: Border.all(color: JanSetuColors.darkBorder)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(d['name'].toString().replaceAll(' District', ''), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                              child: Text('${d['score']}', style: const TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Projects: ${d['projects']} • Needs: ${d['needs']}', style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                        Text('Satisfaction: ${d['satisfaction']}', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskCard(String title, String sub, String desc, IconData icon, Color col) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: col.withValues(alpha: 0.6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: col, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 6),
          Text(sub, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // ==========================================
  // WORKSPACE 1: STATE OVERVIEW & DISTRICTS
  // ==========================================
  Widget _buildWorkspace1Districts(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 11 State Micro-Summary Cards
        _buildSectionHeader('🌐 Statewide Macro Governance Indicators (11-Tier Telemetry)'),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMiniStatBox('Population', '6.8 Cr', Icons.groups_rounded, JanSetuColors.electricBlue),
              _buildMiniStatBox('Districts', '33', Icons.map_rounded, JanSetuColors.saffronGold),
              _buildMiniStatBox('Constituencies', '182', Icons.how_to_reg_rounded, JanSetuColors.emeraldGreen),
              _buildMiniStatBox('Cities', '260', Icons.location_city_rounded, JanSetuColors.electricBlue),
              _buildMiniStatBox('Villages', '18,500', Icons.holiday_village_rounded, JanSetuColors.saffronGold),
              _buildMiniStatBox('Active Needs', '1,420', Icons.record_voice_over_rounded, JanSetuColors.crimsonAlert),
              _buildMiniStatBox('Sanctioned Works', '840', Icons.construction_rounded, JanSetuColors.emeraldGreen),
              _buildMiniStatBox('Total Outlay', '₹1,800 Cr', Icons.account_balance_wallet_rounded, JanSetuColors.saffronGold),
              _buildMiniStatBox('Active Officers', '1,240', Icons.badge_rounded, JanSetuColors.electricBlue),
              _buildMiniStatBox('Verified Citizens', '4.2 Cr', Icons.verified_user_rounded, JanSetuColors.emeraldGreen),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('📍 Interactive District Analytics Matrix (Tap for Drill-Down)'),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            itemCount: _districts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final d = _districts[index];
              return InkWell(
                onTap: () => _showDistrictDetailModal(d),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: JanSetuColors.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: d['priority'] == 'CRITICAL' ? JanSetuColors.crimsonAlert : JanSetuColors.darkBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: JanSetuColors.electricBlue.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                              child: Text(d['code']!, style: const TextStyle(color: JanSetuColors.electricBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('Projects: ${d['projects']} • Needs: ${d['needs']} • Outlay: ${d['budget']}', style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Dev Score: ${d['score']}', style: const TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('Satisfaction: ${d['satisfaction']}', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WORKSPACE 2: CONSTITUENCY & MP MONITORING
  // ==========================================
  Widget _buildWorkspace2MPs(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('🏛️ Statewide Member of Parliament (MP) Governance Feed'),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisExtent: 180,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _mps.length,
            itemBuilder: (context, index) {
              final mp = _mps[index];
              return InkWell(
                onTap: () => _showMpDetailModal(mp),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: JanSetuColors.darkSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: JanSetuColors.saffronGold.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(mp['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
                                Text(mp['constituency']!, style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 12), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                            child: Text(mp['badge']!, style: const TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                          ),
                        ],
                      ),
                      const Divider(color: JanSetuColors.darkBorder, height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dev Score: ${mp['score']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Satisfaction: ${mp['satisfaction']}', style: const TextStyle(color: JanSetuColors.electricBlue, fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                      Text('Outlay: ${mp['budget']} • Active Works: ${mp['projects']}', style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WORKSPACE 3: DEPARTMENT INTELLIGENCE
  // ==========================================
  Widget _buildWorkspace3Departments(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('🏢 8 Core State Infrastructure Departments — SLA & Risk Intelligence'),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _departments.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final dept = _departments[index];
              final score = dept['score'] as double;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: JanSetuColors.darkSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: score < 80 ? JanSetuColors.crimsonAlert : JanSetuColors.darkBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: JanSetuColors.saffronGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                                child: Icon(dept['icon'] as IconData, color: JanSetuColors.saffronGold, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dept['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
                                    Text('Projects: ${dept['projects']} • Officers: ${dept['officers']} • Outlay: ${dept['budget']}', style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('SLA Score: ${dept['score']}%', style: TextStyle(color: score >= 90 ? JanSetuColors.emeraldGreen : (score >= 80 ? JanSetuColors.saffronGold : JanSetuColors.crimsonAlert), fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('Avg Delay: ${dept['delay']}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('SLA Velocity: ', style: TextStyle(color: Colors.white54, fontSize: 11)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: dept['trend'] as double,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(score >= 90 ? JanSetuColors.emeraldGreen : (score >= 80 ? JanSetuColors.saffronGold : JanSetuColors.crimsonAlert)),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Risk: ${dept['risk']}', style: TextStyle(color: dept['risk'] == 'LOW' ? JanSetuColors.emeraldGreen : JanSetuColors.crimsonAlert, fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: JanSetuColors.emeraldGreen, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text('AI Recommendation: ${dept['aiRec']}', style: const TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 12, fontStyle: FontStyle.italic), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WORKSPACE 4: BUDGET & ESCROW COMMAND
  // ==========================================
  Widget _buildWorkspace4Budget(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('💰 State Fiscal Outlay & PFMS Blockchain Escrow Command'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildMiniStatBox('Total Budget Outlay', '₹1,800 Crore', Icons.account_balance_wallet_rounded, JanSetuColors.saffronGold),
            _buildMiniStatBox('Allocated to Depts', '₹1,600 Crore', Icons.assignment_rounded, JanSetuColors.electricBlue),
            _buildMiniStatBox('Committed Escrow', '₹1,420 Crore', Icons.lock_rounded, JanSetuColors.emeraldGreen),
            _buildMiniStatBox('Disbursed & Spent', '₹1,100 Crore', Icons.payments_rounded, JanSetuColors.emeraldGreen),
            _buildMiniStatBox('Remaining Reserves', '₹380 Crore', Icons.savings_rounded, JanSetuColors.saffronGold),
          ],
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('📊 Department & District Disbursal Allocation Velocity'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: JanSetuColors.darkBorder)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAllocationBar('Roads & Highways Dept', '₹620 Cr / ₹700 Cr Allocation', 0.88, JanSetuColors.electricBlue),
              const SizedBox(height: 10),
              _buildAllocationBar('Smart Water & Drainage', '₹410 Cr / ₹450 Cr Allocation', 0.91, JanSetuColors.emeraldGreen),
              const SizedBox(height: 10),
              _buildAllocationBar('Power Grid & Solar Rooftop', '₹350 Cr / ₹400 Cr Allocation', 0.87, JanSetuColors.saffronGold),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('⚡ Smart Escrow Audit Ledger & Tranche Control'),
        const SizedBox(height: 10),
        Expanded(
          child: EscrowAuditLedger(
            selectedTierData: _selectedTierData,
            ledgerProjects: _ledgerProjects,
            onAuthorizeTranche: _authorizeTranche,
            onFreezeEscrow: _freezeEscrow,
            onInspectProject: (prj) => _showDetailModal(prj['escrowId'] ?? 'PFMS-ESC-001', prj['projectName'] ?? 'Project', 'DEPT_URBAN_DEV', prj['status'] ?? 'IN_EXECUTION', isProject: true),
          ),
        ),
      ],
    );
  }

  Widget _buildAllocationBar(String label, String val, double pct, Color col) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text(val, style: TextStyle(color: col, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: pct, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation<Color>(col), minHeight: 10),
        ),
      ],
    );
  }

  // ==========================================
  // WORKSPACE 5: PROJECTS & AUDIT CENTER
  // ==========================================
  Widget _buildWorkspace5ProjectsAndAudit(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('🚧 Active Capital Projects Monitoring & 1-Tap Governance Actions'),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _monitoredProjects.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final p = _monitoredProjects[index];
              return Container(
                width: 320,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p['risk'] == 'HIGH' ? JanSetuColors.crimsonAlert : JanSetuColors.darkBorder)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(p['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: (p['risk'] == 'HIGH' ? JanSetuColors.crimsonAlert : JanSetuColors.emeraldGreen).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                          child: Text('${p['risk']} RISK', style: TextStyle(color: p['risk'] == 'HIGH' ? JanSetuColors.crimsonAlert : JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                      ],
                    ),
                    Text('${p['dept']} • District: ${p['district']} • Budget: ${p['budget']}', style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(value: p['progress'] as double, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation<Color>(JanSetuColors.electricBlue), minHeight: 8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('Officer: ${p['officer']}', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        Text('${((p['progress'] as double) * 100).toInt()}% Done', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildActionBtn('Open', Icons.open_in_new_rounded, JanSetuColors.electricBlue, () => _showDetailModal('PRJ-00$index', p['title']!, 'DEPT_URBAN', p['status']!, isProject: true)),
                        if (p['status'] != 'PAUSED') _buildActionBtn('Pause', Icons.pause_rounded, JanSetuColors.saffronGold, () => setState(() => p['status'] = 'PAUSED')),
                        if (p['status'] == 'PAUSED') _buildActionBtn('Resume', Icons.play_arrow_rounded, JanSetuColors.emeraldGreen, () => setState(() => p['status'] = 'IN_EXECUTION')),
                        _buildActionBtn('Audit', Icons.verified_user_rounded, JanSetuColors.emeraldGreen, () => _showDetailModal('AUDIT-00$index', p['title']!, 'DEPT_URBAN', 'VERIFIED')),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildSectionHeader('📜 Chronological State Audit Center Timeline & Blockchain Logs'),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📥 Exporting Complete PFMS Blockchain Audit Ledger (XLSX & PDF)...'), backgroundColor: JanSetuColors.emeraldGreen));
              },
              icon: const Icon(Icons.download_rounded, size: 16, color: JanSetuColors.slateNavy),
              label: const Text('Export Ledger Placeholder', style: TextStyle(color: JanSetuColors.slateNavy, fontWeight: FontWeight.bold, fontSize: 12)),
              style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.saffronGold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            itemCount: _auditLogs.length,
            separatorBuilder: (_, _) => const Divider(color: JanSetuColors.darkBorder, height: 16),
            itemBuilder: (context, index) {
              final log = _auditLogs[index];
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.verified_rounded, color: JanSetuColors.emeraldGreen, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${log['action']} — ${log['target']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                        Text('Authorized By: ${log['user']} • Hash: ${log['hash']}', style: const TextStyle(color: Colors.white60, fontSize: 11), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(log['time']!, style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(String label, IconData icon, Color col, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: col.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6), border: Border.all(color: col, width: 0.8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: col),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WORKSPACE 6: ALERT & NOTIFICATION CENTER
  // ==========================================
  Widget _buildWorkspace6Alerts(bool isMobile) {
    final filtered = _alertFilter == 'ALL' ? _alerts : _alerts.where((a) => a['type'] == _alertFilter).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildSectionHeader('🚨 Active Alert & Notification Center (Working Filters & Controls)'),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('All Alerts', 'ALL', _alertFilter, (v) => setState(() => _alertFilter = v)),
                _buildFilterChip('Critical', 'CRITICAL', _alertFilter, (v) => setState(() => _alertFilter = v)),
                _buildFilterChip('Warnings', 'WARNING', _alertFilter, (v) => setState(() => _alertFilter = v)),
                _buildFilterChip('Info', 'INFO', _alertFilter, (v) => setState(() => _alertFilter = v)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('✅ No alerts match your filter criteria.', style: TextStyle(color: Colors.white70)))
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final a = filtered[index];
                    final isCrit = a['type'] == 'CRITICAL';
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: a['read'] == true ? Colors.black26 : JanSetuColors.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isCrit ? JanSetuColors.crimsonAlert : (a['type'] == 'WARNING' ? JanSetuColors.saffronGold : JanSetuColors.electricBlue)),
                      ),
                      child: Row(
                        children: [
                          Icon(isCrit ? Icons.error_rounded : (a['type'] == 'WARNING' ? Icons.warning_amber_rounded : Icons.info_rounded), color: isCrit ? JanSetuColors.crimsonAlert : (a['type'] == 'WARNING' ? JanSetuColors.saffronGold : JanSetuColors.electricBlue), size: 24),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['title']!, style: TextStyle(color: Colors.white, fontWeight: a['read'] == true ? FontWeight.normal : FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(a['desc']!, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(a['time']!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (a['read'] == false)
                                    IconButton(
                                      icon: const Icon(Icons.check_circle_outline_rounded, color: JanSetuColors.emeraldGreen, size: 20),
                                      tooltip: 'Mark as Read',
                                      onPressed: () => setState(() => a['read'] = true),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                    tooltip: 'Delete Alert',
                                    onPressed: () => setState(() => _alerts.remove(a)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ==========================================
  // WORKSPACE 7: USER MANAGEMENT DIRECTORY
  // ==========================================
  Widget _buildWorkspace7UserDirectory(bool isMobile) {
    final filtered = _userRoleFilter == 'ALL' ? _userDirectory : _userDirectory.where((u) => u['role']!.toUpperCase().contains(_userRoleFilter)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildSectionHeader('👥 State Human Resource Directory & Permissions Management'),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('All Users', 'ALL', _userRoleFilter, (v) => setState(() => _userRoleFilter = v)),
                _buildFilterChip('Admins', 'ADMIN', _userRoleFilter, (v) => setState(() => _userRoleFilter = v)),
                _buildFilterChip('MPs', 'PARLIAMENT', _userRoleFilter, (v) => setState(() => _userRoleFilter = v)),
                _buildFilterChip('Engineers', 'ENGINEER', _userRoleFilter, (v) => setState(() => _userRoleFilter = v)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final u = filtered[index];
              final isSus = u['status'] == 'SUSPENDED';
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSus ? JanSetuColors.crimsonAlert : JanSetuColors.darkBorder)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(backgroundColor: JanSetuColors.saffronGold.withValues(alpha: 0.2), child: Text(u['name']![0], style: const TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold))),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${u['name']} (${u['id']})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                                Text('Role: ${u['role']} • District: ${u['district']} • Email: ${u['email']}', style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: (isSus ? JanSetuColors.crimsonAlert : JanSetuColors.emeraldGreen).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text(u['status']!, style: TextStyle(color: isSus ? JanSetuColors.crimsonAlert : JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              u['status'] = isSus ? 'ACTIVE' : 'SUSPENDED';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User ${u['name']} status updated to ${u['status']}!'), backgroundColor: JanSetuColors.electricBlue));
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: isSus ? JanSetuColors.emeraldGreen : Colors.redAccent, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                          child: Text(isSus ? 'Activate' : 'Suspend', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WORKSPACE 8: GIS SPATIAL TWIN
  // ==========================================
  Widget _buildWorkspace8GisTwin(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildSectionHeader('🗺️ Statewide 3D GIS Spatial Digital Twin (Simulated Telemetry Viewport)'),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Heatmap Layer', 'DEVELOPMENT_HEATMAP', _gisLayer, (v) => setState(() => _gisLayer = v)),
                _buildFilterChip('Active Projects Layer', 'ACTIVE_PROJECTS', _gisLayer, (v) => setState(() => _gisLayer = v)),
                _buildFilterChip('Critical Needs Layer', 'CRITICAL_NEEDS', _gisLayer, (v) => setState(() => _gisLayer = v)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const RadialGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)], radius: 1.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.6), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.satellite_alt_rounded, size: 64, color: JanSetuColors.electricBlue),
                const SizedBox(height: 16),
                Text('ACTIVE GIS VIEWPORT LAYER: $_gisLayer', style: const TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.0), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                const Text('Rendering real-time GIS spatial polygon coordinates across 33 Districts and 182 Assembly Constituencies.', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: _districts.take(6).map((d) => InkWell(
                        onTap: () => _showDistrictDetailModal(d),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12), border: Border.all(color: JanSetuColors.emeraldGreen)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_rounded, color: JanSetuColors.emeraldGreen, size: 16),
                              const SizedBox(width: 8),
                              Text('${d['code']}: ${d['name'].toString().replaceAll(' District', '')} (${d['score']})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                      )).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WORKSPACE 9: REPORTS & SETTINGS
  // ==========================================
  Widget _buildWorkspace9ReportsAndSettings(bool isMobile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📥 Executive State Intelligence Report Generator (1-Tap Download & Share)'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _buildReportCard('Statewide District Audit Report', 'Complete SLA index across all 33 districts.', Icons.picture_as_pdf_rounded, JanSetuColors.electricBlue),
              _buildReportCard('Department Performance Briefing', '8 core departments SLA delay analysis.', Icons.analytics_rounded, JanSetuColors.emeraldGreen),
              _buildReportCard('PFMS Smart Escrow Ledger Export', 'Blockchain verified financial disbursements.', Icons.table_view_rounded, JanSetuColors.saffronGold),
              _buildReportCard('AI Strategic Recommendation Summary', 'Synthesized priority sanctions and flood alerts.', Icons.auto_awesome_rounded, JanSetuColors.electricBlue),
            ],
          ),
          const SizedBox(height: 28),
          _buildSectionHeader('⚙️ State Command Center System Configuration & Theme Settings'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: JanSetuColors.darkBorder)),
            child: Column(
              children: [
                _buildSettingRow('Theme Mode Configuration', 'Locked to JanSetu High-Contrast Executive Dark Mode', Icons.dark_mode_rounded, true, null),
                const Divider(color: JanSetuColors.darkBorder, height: 24),
                _buildSettingRow('PFMS Blockchain Auto-Verification', 'Require 3 AI Geo-Witness corroborations before tranche release', Icons.verified_user_rounded, true, (val) {}),
                const Divider(color: JanSetuColors.darkBorder, height: 24),
                _buildSettingRow('Monsoon Telemetry Alert System', 'Sync live IMD rain sensors with coastal district command rooms', Icons.cloud_sync_rounded, true, (val) {}),
                const Divider(color: JanSetuColors.darkBorder, height: 24),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 14,
                  runSpacing: 12,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.language_rounded, color: JanSetuColors.saffronGold, size: 22),
                        SizedBox(width: 12),
                        Flexible(child: Text('Supported Governance Languages: English, Gujarati (ગુજરાતી), Hindi (હિન્દી)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔒 State Command Portal Locked. Session ended securely.'), backgroundColor: JanSetuColors.crimsonAlert));
                      },
                      icon: const Icon(Icons.logout_rounded, size: 16, color: Colors.white),
                      label: const Text('Lock Portal / Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.crimsonAlert),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String desc, IconData icon, Color col) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: col.withValues(alpha: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: col, size: 24),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('📥 Generated & downloaded $title!'), backgroundColor: JanSetuColors.emeraldGreen));
            },
            icon: const Icon(Icons.download_rounded, size: 14, color: JanSetuColors.slateNavy),
            label: const Text('Generate & Export Report', style: TextStyle(color: JanSetuColors.slateNavy, fontWeight: FontWeight.bold, fontSize: 11)),
            style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.saffronGold, minimumSize: const Size(double.infinity, 34)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String title, String sub, IconData icon, bool val, Function(bool)? onChanged) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(icon, color: JanSetuColors.electricBlue, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                    Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 12), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(value: val, onChanged: onChanged, activeColor: JanSetuColors.saffronGold),
      ],
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5));
  }

  Widget _buildMiniStatBox(String label, String val, IconData icon, Color col) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: col.withValues(alpha: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 4),
              Icon(icon, color: col, size: 16),
            ],
          ),
          const SizedBox(height: 6),
          Text(val, style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String val, String current, Function(String) onSelect) {
    final sel = val == current;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: sel ? JanSetuColors.slateNavy : Colors.white, fontSize: 11, fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
      selected: sel,
      selectedColor: JanSetuColors.saffronGold,
      backgroundColor: Colors.white10,
      onSelected: (_) => onSelect(val),
    );
  }
}
