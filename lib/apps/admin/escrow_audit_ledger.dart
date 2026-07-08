import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';

/// PFMS Smart Escrow Audit Ledger (EscrowAuditLedger)
/// Renders financial governance ledgers with 3-stage milestone tranche escrow statuses.
/// Enables State Chief Secretaries and Chief Engineers to authorize milestone releases or freeze escrow.
class EscrowAuditLedger extends StatelessWidget {
  final Map<String, dynamic> selectedTierData;
  final List<Map<String, dynamic>> ledgerProjects;
  final Function(int projectIndex) onAuthorizeTranche;
  final Function(int projectIndex) onFreezeEscrow;
  final Function(Map<String, dynamic> project)? onInspectProject;
  final Widget? headerWidget;

  const EscrowAuditLedger({
    super.key,
    required this.selectedTierData,
    required this.ledgerProjects,
    required this.onAuthorizeTranche,
    required this.onFreezeEscrow,
    this.onInspectProject,
    this.headerWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total financials for the selected tier
    double totalSanctioned = 0;
    double totalDisbursed = 0;
    for (final p in ledgerProjects) {
      totalSanctioned += (p['sanctionedLakhs'] as num).toDouble();
      totalDisbursed += (p['disbursedLakhs'] as num).toDouble();
    }
    final totalLocked = totalSanctioned - totalDisbursed;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (headerWidget != null) headerWidget!,
          // Governance Tier Banner & Financial Summary
          Container(
            padding: const EdgeInsets.all(JanSetuTheme.space16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1424),
              borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
              border: Border.all(color: JanSetuColors.saffronGold.withAlpha(102)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.shield_rounded, color: JanSetuColors.saffronGold, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'PFMS SMART ESCROW AUDIT LEDGER — ${selectedTierData['name'].toUpperCase()}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: JanSetuColors.saffronGold.withAlpha(51), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        'TIER ID: ${selectedTierData['id']}',
                        style: const TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: JanSetuTheme.space16),
                Row(
                  children: [
                    Expanded(child: _buildLedgerStat('Total Sanctioned Capital', '₹${totalSanctioned.toStringAsFixed(2)} Lakhs', JanSetuColors.electricBlue)),
                    const SizedBox(width: JanSetuTheme.space12),
                    Expanded(child: _buildLedgerStat('Disbursed Escrow Balance', '₹${totalDisbursed.toStringAsFixed(2)} Lakhs', JanSetuColors.emeraldGreen)),
                    const SizedBox(width: JanSetuTheme.space12),
                    Expanded(child: _buildLedgerStat('Locked in Smart Escrow', '₹${totalLocked.toStringAsFixed(2)} Lakhs', JanSetuColors.saffronGold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: JanSetuTheme.space24),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text('ACTIVE INFRASTRUCTURE CONTRACTS IN ${selectedTierData['name'].toUpperCase()} (CLICK TO VIEW METADATA)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const Text('3-Stage Tranche Verification Active', style: TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 11)),
            ],
          ),
          const SizedBox(height: JanSetuTheme.space12),
          if (ledgerProjects.isEmpty)
            const JanSetuStateView(state: JanSetuUIState.empty)
          else
            ...ledgerProjects.asMap().entries.map((entry) {
              final index = entry.key;
              final prj = entry.value;
              final isFrozen = prj['status'] == 'ESCROW_FROZEN';
              final isCompleted = prj['status'] == 'COMPLETED_RELEASED';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => onInspectProject?.call(prj),
                  borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
                  child: Container(
                    padding: const EdgeInsets.all(JanSetuTheme.space16),
                    decoration: BoxDecoration(
                      color: isFrozen ? JanSetuColors.crimsonAlert.withAlpha(25) : const Color(0xFF0D1424),
                      borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
                      border: Border.all(
                        color: isFrozen ? JanSetuColors.crimsonAlert : (isCompleted ? JanSetuColors.emeraldGreen : JanSetuColors.electricBlue.withAlpha(102)),
                        width: isFrozen || isCompleted ? 2.0 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                prj['projectName'],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isFrozen ? JanSetuColors.crimsonAlert : (isCompleted ? JanSetuColors.emeraldGreen : JanSetuColors.electricBlue),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                prj['status'],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 16,
                          runSpacing: 4,
                          children: [
                            Wrap(
                              spacing: 16,
                              runSpacing: 4,
                              children: [
                                Text('Contractor: ${prj['contractor']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                Text('Escrow ID: ${prj['escrowId']}', style: const TextStyle(color: JanSetuColors.saffronGold, fontSize: 12)),
                              ],
                            ),
                            const Text('Inspect AI Timeline & Audit Metadata ➔', style: TextStyle(color: JanSetuColors.electricBlue, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: JanSetuTheme.space16),
                        const Text('PFMS 3-STAGE SMART TRANCHE LEDGER:', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: JanSetuTheme.space8),
                        _buildTrancheRow('Tranche 1: Foundation (20%)', prj['tranche1'], '₹${(prj['sanctionedLakhs'] * 0.20).toStringAsFixed(1)} L'),
                        const SizedBox(height: 6),
                        _buildTrancheRow('Tranche 2: Structure Geo-Tag (50%)', prj['tranche2'], '₹${(prj['sanctionedLakhs'] * 0.50).toStringAsFixed(1)} L'),
                        const SizedBox(height: 6),
                        _buildTrancheRow('Tranche 3: Final Quality Audit (30%)', prj['tranche3'], '₹${(prj['sanctionedLakhs'] * 0.30).toStringAsFixed(1)} L'),
                        const SizedBox(height: JanSetuTheme.space16),
                        // Action Controls
                        if (!isFrozen && !isCompleted)
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ElevatedButton.icon(
                                  onPressed: () => onAuthorizeTranche(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: JanSetuColors.emeraldGreen,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                                  label: Text(
                                    'Authorize Tranche Release (₹${(prj['sanctionedLakhs'] * 0.50).toStringAsFixed(1)} L)',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: JanSetuTheme.space12),
                              Expanded(
                                flex: 2,
                                child: OutlinedButton.icon(
                                  onPressed: () => onFreezeEscrow(index),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: JanSetuColors.crimsonAlert,
                                    side: const BorderSide(color: JanSetuColors.crimsonAlert),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: const Icon(Icons.lock_rounded, size: 18),
                                  label: const Text(
                                    'Freeze Escrow & Audit',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (isFrozen)
                          Container(
                            padding: const EdgeInsets.all(JanSetuTheme.space12),
                            decoration: BoxDecoration(
                              color: JanSetuColors.crimsonAlert.withAlpha(51),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: JanSetuColors.crimsonAlert),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.warning_rounded, color: JanSetuColors.crimsonAlert, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'ESCROW FROZEN BY STATE VIGILANCE — Pending AI anomaly verification report.',
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.all(JanSetuTheme.space12),
                            decoration: BoxDecoration(
                              color: JanSetuColors.emeraldGreen.withAlpha(51),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: JanSetuColors.emeraldGreen),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.verified_rounded, color: JanSetuColors.emeraldGreen, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'ALL TRANCHES DISBURSED — Project completed and verified via citizen feedback.',
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildLedgerStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(JanSetuTheme.space12),
      decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withAlpha(76))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildTrancheRow(String stageName, String status, String amount) {
    Color statusColor;
    IconData icon;
    if (status == 'RELEASED') {
      statusColor = JanSetuColors.emeraldGreen;
      icon = Icons.check_circle_rounded;
    } else if (status == 'PENDING_AUDIT_RELEASE') {
      statusColor = JanSetuColors.saffronGold;
      icon = Icons.pending_actions_rounded;
    } else if (status == 'ESCROW_LOCKED') {
      statusColor = Colors.grey;
      icon = Icons.lock_outline_rounded;
    } else {
      statusColor = JanSetuColors.crimsonAlert;
      icon = Icons.error_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withAlpha(13), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Icon(icon, color: statusColor, size: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    stageName,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(amount, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withAlpha(51), borderRadius: BorderRadius.circular(4)),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
