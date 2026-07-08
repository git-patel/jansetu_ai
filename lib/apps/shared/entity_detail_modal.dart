import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import '../../services/local_persistence_service.dart';

/// Entity Detail Modal (EntityDetailModal)
/// Implements Prompt 08 & Master Architecture: "Summary on feed cards, full metadata inside detail pages."
/// Features 7 clean expandable accordion sections: Timeline, AI Reasoning, Budget, Department, Documents, Inspection Reports, and Nearby Needs.
class EntityDetailModal extends StatefulWidget {
  final Map<String, dynamic> entity;
  final bool isProject;
  final VoidCallback? onActionTriggered;

  const EntityDetailModal({
    super.key,
    required this.entity,
    this.isProject = false,
    this.onActionTriggered,
  });

  @override
  State<EntityDetailModal> createState() => _EntityDetailModalState();
}

class _EntityDetailModalState extends State<EntityDetailModal> {
  late bool _isSupported;
  late int _upvotes;

  @override
  void initState() {
    super.initState();
    final idx = LocalPersistenceService.needs.indexOf(widget.entity);
    final userId = LocalPersistenceService.activeRole ?? 'USR-CTZ-8841';
    _isSupported = idx >= 0 ? LocalPersistenceService.isNeedSupported(idx, userId) : false;
    _upvotes = ((widget.entity['upvoteCount'] as num?)?.toInt() ?? 0);
  }

  void _toggleSupport() async {
    final idx = LocalPersistenceService.needs.indexOf(widget.entity);
    final userId = LocalPersistenceService.activeRole ?? 'USR-CTZ-8841';
    if (idx >= 0) {
      final res = await LocalPersistenceService.toggleSupportNeed(idx, userId);
      setState(() {
        _isSupported = res;
        _upvotes = res ? _upvotes + 1 : (_upvotes > 0 ? _upvotes - 1 : 0);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res ? '👍 You supported this Development Need!' : 'Support removed.'),
            backgroundColor: res ? JanSetuColors.emeraldGreen : Colors.grey[800],
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('👍 You supported this Development Need!'), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  String _formatDept(String deptId) {
    return deptId.replaceAll('DEPT_', '').replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isProject ? (widget.entity['projectName'] ?? 'Capital Infrastructure Work') : (widget.entity['titleEnglish'] ?? 'Civic Infrastructure Grievance');
    final vernTitle = widget.isProject ? '' : (widget.entity['titleVernacular'] ?? '');
    final deptId = widget.entity['departmentId'] ?? 'DEPT_ROADS_HIGHWAYS';
    final status = widget.entity['status'] ?? widget.entity['currentStatus'] ?? 'VERIFIED_AI';
    final id = widget.isProject ? (widget.entity['projectId'] ?? 'PRJ-2026-SRT-0001') : (widget.entity['needId'] ?? 'ND-2026-SRT-0001');

    final aiMap = widget.entity['aiIntelligence'] as Map<String, dynamic>? ?? {
      'confidence': 96.8,
      'duplicateScore': 8.5,
      'estimatedCostINR': 1500000.0,
      'estimatedBeneficiaries': 12500,
      'impactScore': 85.0,
    };

    final timelineMap = widget.entity['timeline'] as Map<String, dynamic>? ?? {
      'reportedDate': '2026-07-01',
      'verifiedDate': '2026-07-01',
      'approvedDate': widget.isProject ? '2026-07-02' : null,
      'tenderDate': widget.isProject ? '2026-07-03' : null,
      'constructionDate': (status == 'IN_EXECUTION' || status == 'MILESTONE_2_VERIFIED') ? '2026-07-04' : null,
      'completedDate': status == 'COMPLETED_RELEASED' ? '2026-07-05' : null,
    };

    final ancestries = widget.entity['ancestries'] as List<dynamic>? ?? [
      'IND', 'STATE-GUJ', 'DIST-SRT', 'CORP-SMC', 'ZONE-WEST', 'WRD-GUJ-SRT-0014'
    ];

    final ownership = widget.entity['ownership'] as Map<String, dynamic>?;
    final contractorName = ownership?['contractorName'] ?? widget.entity['contractor'] ?? 'L&T Civil Infrastructure Ltd';
    final gstin = ownership?['contractorGstin'] ?? '24AAACL0140P1Z1';

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      decoration: const BoxDecoration(
        color: JanSetuColors.slateNavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle & Title Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: JanSetuColors.darkBorder)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: JanSetuColors.electricBlue.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(id, style: const TextStyle(color: JanSetuColors.electricBlue, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _formatDept(deptId),
                                  style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 11, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (vernTitle.isNotEmpty)
                            Text(
                              vernTitle,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2),
                            ),
                          Text(
                            title,
                            style: TextStyle(
                              color: vernTitle.isNotEmpty ? JanSetuColors.darkTextSecondary : Colors.white,
                              fontSize: vernTitle.isNotEmpty ? 14 : 18,
                              fontWeight: vernTitle.isNotEmpty ? FontWeight.normal : FontWeight.bold,
                              fontStyle: vernTitle.isNotEmpty ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Expandable Sections (Accordion)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: Column(
                  children: [
                    // Section 1: Timeline (Expanded by default)
                    _buildAccordionSection(
                      title: '📅 Section 1: 6-Stage Visual Progress Timeline',
                      subtitle: 'Visual civic lifecycle from voice intake to 36-month defect warranty',
                      initiallyExpanded: true,
                      content: Column(
                        children: [
                          _buildTimelineStage(1, 'Reported by Citizen', 'Multimodal voice / photo intake verified', timelineMap['reportedDate'] != null, timelineMap['reportedDate'] ?? 'Completed'),
                          _buildTimelineStage(2, 'Verified by AI & Geohashed', 'Routed to Adajan Ward 14 officer', timelineMap['verifiedDate'] != null, timelineMap['verifiedDate'] ?? 'Completed'),
                          _buildTimelineStage(3, 'Sanctioned by Authority', 'MPLADS Fund or State Capital Outlay approved', timelineMap['approvedDate'] != null, timelineMap['approvedDate'] ?? (widget.isProject ? 'Completed' : 'Pending MP Sanction')),
                          _buildTimelineStage(4, 'Tender Awarded & Mobilized', 'Contractor: $contractorName (GSTIN: $gstin)', timelineMap['tenderDate'] != null, timelineMap['tenderDate'] ?? (widget.isProject ? 'Active Mobilization' : 'Awaiting Tender')),
                          _buildTimelineStage(5, 'Construction & Tranches 1-2', 'PFMS Escrow milestone release verified by geotag', timelineMap['constructionDate'] != null, timelineMap['constructionDate'] ?? (status == 'IN_EXECUTION' ? 'Active Execution' : 'Pending Milestone')),
                          _buildTimelineStage(6, 'Completed & 36M Defect Warranty', 'Final Tranche 3 released after citizen poll', timelineMap['completedDate'] != null, timelineMap['completedDate'] ?? '36-Month Warranty Period'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 2: AI Reasoning
                    _buildAccordionSection(
                      title: '🤖 Section 2: Gemini 2.5 Pro — Complete Civic Metadata Analysis',
                      subtitle: 'Multimodal verification, rationale & priority scoring',
                      content: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: JanSetuColors.darkSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AI Verification Rationale:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 4),
                            const Text('"High citizen witness density combined with satellite image geohash corroboration confirms genuine public infrastructure need. Zero duplicate overlap detected."', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontStyle: FontStyle.italic, fontSize: 12)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                _buildAiMetric('AI Confidence', '${aiMap['confidence']}%', JanSetuColors.emeraldGreen),
                                _buildAiMetric('Impact Score', '${aiMap['impactScore']}/100', JanSetuColors.electricBlue),
                                _buildAiMetric('Beneficiaries', '${aiMap['estimatedBeneficiaries']}', JanSetuColors.saffronGold),
                                _buildAiMetric('Duplicate Score', '${aiMap['duplicateScore']}% (Unique)', JanSetuColors.darkTextSecondary),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 3: Budget
                    _buildAccordionSection(
                      title: '💰 Section 3: Budget Allocation & Escrow',
                      subtitle: 'Cryptographic PFMS escrow tranches & financial outlay',
                      content: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Estimated Outlay:', style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 13)),
                                Text('₹${((aiMap['estimatedCostINR'] as num) / 100000).toStringAsFixed(1)} Lakhs INR', style: const TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                            const Divider(color: JanSetuColors.darkBorder, height: 20),
                            _buildTrancheRow('Tranche 1 (Mobilization - 30%)', 'Released on Sanction', JanSetuColors.emeraldGreen),
                            const SizedBox(height: 8),
                            _buildTrancheRow('Tranche 2 (Execution - 40%)', 'Requires Geotag Inspection', JanSetuColors.electricBlue),
                            const SizedBox(height: 8),
                            _buildTrancheRow('Tranche 3 (Defect Warranty - 30%)', '36-Month Post Completion', JanSetuColors.darkTextSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 4: Assigned Department, Officer & MP
                    _buildAccordionSection(
                      title: '🏛️ Section 4: Assigned Authorities & 11-Tier Spatial Lineage',
                      subtitle: 'Responsible department, officer in charge & MP jurisdiction',
                      content: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            _buildAuthorityRow(Icons.account_balance, 'Department', _formatDept(deptId)),
                            const Divider(color: JanSetuColors.darkBorder, height: 16),
                            _buildAuthorityRow(Icons.person_pin, 'Zonal Officer', 'Executive Engineer (Surat West Ward 14)'),
                            const Divider(color: JanSetuColors.darkBorder, height: 16),
                            _buildAuthorityRow(Icons.how_to_vote, 'MP Jurisdiction', 'Surat Parliamentary Constituency'),
                            const Divider(color: JanSetuColors.darkBorder, height: 16),
                            _buildAuthorityRow(Icons.engineering, 'Contractor', '$contractorName\nGSTIN: $gstin'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 5: Documents & Photos
                    _buildAccordionSection(
                      title: '📁 Section 5: Documents, Photos & Videos',
                      subtitle: 'Multimodal evidence attachments & survey files',
                      content: Column(
                        children: [
                          _buildAttachmentTile(Icons.image, '📸 site_survey_initial_photo.jpg', '2.4 MB • Uploaded by Citizen Witness'),
                          const SizedBox(height: 8),
                          _buildAttachmentTile(Icons.picture_as_pdf, '📄 citizen_petition_signed.pdf', '1.1 MB • 235 Resident Signatures'),
                          const SizedBox(height: 8),
                          _buildAttachmentTile(Icons.videocam, '🎥 ai_drone_inspection_feed.mp4', '14.2 MB • AI Geotag Verified'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 6: Inspection Reports & Audit Trail
                    _buildAccordionSection(
                      title: '🔍 Section 6: Inspection & Audit Trail',
                      subtitle: 'Cryptographic hash logs & 11-tier spatial lineage',
                      content: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(8), border: Border.all(color: JanSetuColors.darkBorder)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Spatial Lineage Tree (Domain A):', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(ancestries.join('  ➔  '), style: const TextStyle(color: JanSetuColors.electricBlue, fontSize: 11, fontFamily: 'monospace')),
                            const Divider(color: JanSetuColors.darkBorder, height: 20),
                            _buildAuditLog('PFMS Transaction ID', 'TXN-PFMS-20260704-994821'),
                            const SizedBox(height: 6),
                            _buildAuditLog('SHA-256 Ledger Hash', '0x8f4b2e1a9c3d...8841'),
                            const SizedBox(height: 6),
                            _buildAuditLog('Geospatial Geohash', 'te7uu1s (Lat: 21.1980, Lng: 72.7910)'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 7: Nearby Similar Needs
                    _buildAccordionSection(
                      title: '📍 Section 7: Nearby Similar Needs',
                      subtitle: 'Clustered public requirements in Ward 14 Surat',
                      content: Column(
                        children: [
                          _buildNearbyCard('🚧 Adajan Water Drainage Maintenance', '0.4 km away • 128 Citizens Support'),
                          const SizedBox(height: 8),
                          _buildNearbyCard('💡 Streetlight Repair Sector 4', '0.8 km away • 94 Citizens Support'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Interactive Action Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: JanSetuColors.darkSurface,
              border: Border(top: BorderSide(color: JanSetuColors.darkBorder)),
            ),
            child: _buildRoleActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionSection({
    required String title,
    required String subtitle,
    required Widget content,
    bool initiallyExpanded = false,
  }) {
    return Material(
      color: JanSetuColors.darkSurface.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: JanSetuColors.darkBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        iconColor: JanSetuColors.electricBlue,
        collapsedIconColor: Colors.grey,
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [content],
      ),
    );
  }

  Widget _buildAiMetric(String label, String val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
      ],
    );
  }

  Widget _buildTimelineStage(int step, String title, String subtitle, bool isCompleted, String statusText) {
    final color = isCompleted ? JanSetuColors.emeraldGreen : JanSetuColors.darkBorder;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? JanSetuColors.emeraldGreen : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                      : Text('$step', style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
                ),
              ),
              if (step < 6)
                Container(width: 2, height: 20, color: color),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(color: isCompleted ? Colors.white : JanSetuColors.darkTextSecondary, fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(statusText, style: TextStyle(color: isCompleted ? JanSetuColors.emeraldGreen : JanSetuColors.darkTextSecondary, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrancheRow(String tranche, String status, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(tranche, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAuthorityRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: JanSetuColors.electricBlue),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentTile(IconData icon, String filename, String meta) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: JanSetuColors.electricBlue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filename, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                Text(meta, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 10)),
              ],
            ),
          ),
          const Icon(Icons.download_rounded, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _buildAuditLog(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildNearbyCard(String title, String meta) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: JanSetuColors.darkSurface, borderRadius: BorderRadius.circular(8), border: Border.all(color: JanSetuColors.darkBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(meta, style: const TextStyle(color: JanSetuColors.electricBlue, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildRoleActions(BuildContext context) {
    final role = LocalPersistenceService.activeRole ?? 'CITIZEN';

    if (role == 'MP' && !widget.isProject) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            if (widget.onActionTriggered != null) widget.onActionTriggered!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: JanSetuColors.emeraldGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.verified_rounded),
          label: const Text('⚡ 1-Tap Sanction ₹15.00 Lakhs MPLADS Outlay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      );
    } else if (role == 'ADMIN' && widget.isProject) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            if (widget.onActionTriggered != null) widget.onActionTriggered!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: JanSetuColors.electricBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.lock_open_rounded),
          label: const Text('🔓 Authorize PFMS Tranche 2 Milestone Release', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      );
    } else {
      // Citizen / General Feed Actions
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _toggleSupport,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSupported ? JanSetuColors.emeraldGreen : JanSetuColors.electricBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(_isSupported ? Icons.thumb_up : Icons.thumb_up_alt_rounded, size: 18),
              label: Text(_isSupported ? 'Supported ($_upvotes)' : 'Support (+1)', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('📍 Link copied to clipboard. Track via Geohash te7uu1q.')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: JanSetuColors.darkBorder),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.share_rounded, size: 18),
              label: const Text('Share / Track'),
            ),
          ),
        ],
      );
    }
  }
}
