import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';

/// MP Project & Grievance Detail Modal (MpProjectDetailModal)
/// Premium executive drill-down modal displaying comprehensive data:
/// Overview, Timeline, Budget, Milestones, Contractor, Officer, Documents,
/// Inspection Photos, Media, Audit Trail, Citizen Feedback, Nearby Projects, and AI Insights.
class MpProjectDetailModal extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onSanction;

  const MpProjectDetailModal({
    super.key,
    required this.item,
    this.onSanction,
  });

  @override
  State<MpProjectDetailModal> createState() => _MpProjectDetailModalState();
}

class _MpProjectDetailModalState extends State<MpProjectDetailModal> {
  int _expandedIndex = 0; // 0: Overview & AI Insights, 1: Timeline & Milestones, 2: Fiscal Budget & Personnel, 3: Evidence & Audit

  @override
  Widget build(BuildContext context) {
    final title = widget.item['title'] ?? 'Civic Infrastructure Work';
    final dept = widget.item['department'] ?? 'Municipal Works';
    final location = widget.item['location'] ?? 'Adajan Ward 14, Surat West';
    final score = (widget.item['priorityScore'] as num?)?.toDouble() ?? 88.5;
    final cost = widget.item['costINR'] ?? 500000;
    final status = widget.item['status'] ?? 'SANCTION_PENDING';
    final desc = widget.item['description'] ?? 'Critical civic infrastructure improvement reported by local citizens and verified by AI spatial monitoring.';
    final costText = '₹${(cost / 100000).toStringAsFixed(2)} Lakhs';

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: JanSetuColors.darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: JanSetuColors.electricBlue, width: 2)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: const BoxDecoration(
              color: JanSetuColors.darkSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: JanSetuColors.darkBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: JanSetuColors.electricBlue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.analytics_rounded, color: JanSetuColors.electricBlue, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$dept • $location',
                          style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Action Bar & KPI Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            color: JanSetuColors.darkSurface.withValues(alpha: 0.5),
            child: Row(
              children: [
                _buildSummaryBadge('AI Priority', '${score.toStringAsFixed(1)}/100', JanSetuColors.crimsonAlert),
                const SizedBox(width: 12),
                _buildSummaryBadge('Outlay Req.', costText, JanSetuColors.saffronGold),
                const SizedBox(width: 12),
                _buildSummaryBadge('Status', status, JanSetuColors.electricBlue),
                const Spacer(),
                if (status != 'SANCTIONED_MPLADS' && widget.onSanction != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: JanSetuColors.emeraldGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      widget.onSanction!();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('⚡ Sanctioned $costText from MPLADS fund for "$title"!'),
                          backgroundColor: JanSetuColors.emeraldGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.bolt_rounded, size: 18),
                    label: const Text('Sanction Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),

          // Expandable Navigation Tabs
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: JanSetuColors.darkSurface,
              border: Border(bottom: BorderSide(color: JanSetuColors.darkBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabBtn('Overview & AI Insights', 0),
                _buildTabBtn('Timeline & Milestones', 1),
                _buildTabBtn('Fiscal & Personnel', 2),
                _buildTabBtn('Evidence & Audit Trail', 3),
              ],
            ),
          ),

          // Accordion Content Workspace
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildExpandedSection(desc, costText, score),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBtn(String label, int index) {
    final isSel = _expandedIndex == index;
    return InkWell(
      onTap: () => setState(() => _expandedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSel ? JanSetuColors.electricBlue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSel ? Colors.white : JanSetuColors.darkTextSecondary,
            fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBadge(String label, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildExpandedSection(String desc, String costText, double score) {
    switch (_expandedIndex) {
      case 0: // Overview & AI Insights
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JanSetuCard(
              backgroundColor: JanSetuColors.darkSurface,
              border: BorderSide(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: JanSetuColors.emeraldGreen, size: 20),
                      SizedBox(width: 8),
                      Text('Gemini 2.5 Pro Strategic Synthesis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const Divider(color: JanSetuColors.darkBorder, height: 24),
                  Text(
                    'AI Confidence Score: ${score.toStringAsFixed(1)}% (High Verification)\n\n'
                    '• **Impact:** Resolving this issue immediately impacts ~4,800 residents across Adajan Ward 14.\n'
                    '• **Duplicate Detection:** Zero duplicate tenders found in SMC municipal registry.\n'
                    '• **Recommendation:** Immediate 1-Tap sanction from FY 2026-27 MPLADS Tranche 2 is advised to prevent severe monsoon structural degradation.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Project Scope & Overview', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: JanSetuColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: JanSetuColors.darkBorder),
              ),
              child: Text(
                desc,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Nearby Similar Projects in Constituency', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildNearbyProjectItem('Adajan Star Crossroad Drainage', 'Completed FY 2025 • ₹3.20 Lakhs'),
            const SizedBox(height: 8),
            _buildNearbyProjectItem('Rander Road Paving & Streetlights', 'Active Stage 4 • ₹14.50 Lakhs'),
          ],
        );

      case 1: // Timeline & Milestones
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('6-Stage Governance Timeline Engine', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMilestoneStep('1. Citizen Grievance & AI Intake', 'Geo-tagged report submitted with Voice & Photo evidence.', true, 'Completed'),
            _buildMilestoneStep('2. GIS Spatial Verification', 'Verified by Surat Municipal Corporation digital twin layers.', true, 'Completed'),
            _buildMilestoneStep('3. Executive Sanction & Budget', 'MPLADS Fund allocation ($costText outlay).', false, 'Pending Action'),
            _buildMilestoneStep('4. PFMS Tender Assignment', 'Contract assignment to empanelled civil contractor.', false, 'Scheduled'),
            _buildMilestoneStep('5. Physical Field Mobilization', 'On-site execution with GPS officer check-ins.', false, 'Scheduled'),
            _buildMilestoneStep('6. Citizen Social Audit & Sign-off', 'Final completion verification by local citizen voters.', false, 'Scheduled'),
          ],
        );

      case 2: // Fiscal & Personnel
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Budget Allocation & Fiscal Ledger', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            JanSetuCard(
              backgroundColor: JanSetuColors.darkSurface,
              child: Column(
                children: [
                  _buildFiscalRow('Sanctioned Outlay Required', costText),
                  const Divider(color: JanSetuColors.darkBorder),
                  _buildFiscalRow('Funding Source', 'MPLADS FY 2026-27 (Surat West)'),
                  const Divider(color: JanSetuColors.darkBorder),
                  _buildFiscalRow('PFMS Escrow Account', 'GUJ-SMC-8829-ESC'),
                  const Divider(color: JanSetuColors.darkBorder),
                  _buildFiscalRow('SLA Contractor Penalty', '₹5,000 / day post 15-day SLA'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Assigned Personnel & Governance Team', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildPersonnelCard('Ward Executive Officer', 'Shri R.K. Joshi', Icons.engineering_rounded, 'Active Inspection Due in 2 days'),
            const SizedBox(height: 12),
            _buildPersonnelCard('Empanelled Contractor', 'Gujarat Civil Buildcon Pvt. Ltd.', Icons.business_rounded, 'Class A Municipal Contractor (Rating: 4.8★)'),
          ],
        );

      case 3: // Evidence & Audit Trail
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Inspection Photos & Spatial Evidence', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildPhotoBox('📸 Initial Citizen Photo', 'Verified 12:45 PM today')),
                const SizedBox(width: 12),
                Expanded(child: _buildPhotoBox('🛰️ GIS Satellite Twin', 'Resolution: 0.5m Ortho')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Immutable Blockchain Audit Trail', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildAuditLog('12:45 PM - Grievance reported by verified citizen (UID: ***8821)'),
            _buildAuditLog('12:46 PM - Gemini 2.5 Pro classified need as Tier 1 Priority (94.8/100)'),
            _buildAuditLog('12:47 PM - Auto-routed to Hon. MP Command Center & State Admin Feed'),
            _buildAuditLog('01:15 PM - Ward Officer R.K. Joshi acknowledged geo-hash coordinates'),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildNearbyProjectItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: JanSetuColors.darkBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: JanSetuColors.emeraldGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneStep(String title, String subtitle, bool isDone, String badge) {
    final color = isDone ? JanSetuColors.emeraldGreen : JanSetuColors.saffronGold;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(isDone ? Icons.check_rounded : Icons.access_time_rounded, color: color, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(color: isDone ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(badge, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiscalRow(String key, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 13)),
          Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPersonnelCard(String role, String name, IconData icon, String note) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: JanSetuColors.darkBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: JanSetuColors.electricBlue, radius: 20, child: Icon(icon, color: Colors.white, size: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(note, style: const TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: JanSetuColors.electricBlue.withValues(alpha: 0.2),
              foregroundColor: JanSetuColors.electricBlue,
              elevation: 0,
            ),
            onPressed: () {},
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoBox(String label, String note) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: JanSetuColors.darkBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_rounded, color: JanSetuColors.electricBlue, size: 36),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(note, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildAuditLog(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: JanSetuColors.electricBlue, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12))),
        ],
      ),
    );
  }
}
