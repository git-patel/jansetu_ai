import 'package:flutter/material.dart';
import '../theme/jansetu_colors.dart';
import '../theme/jansetu_theme.dart';
import 'jansetu_card.dart';

/// Sanctioned Project Progress Card (JanSetuProjectCard)
/// Displays capital works execution, financial escrow amounts, and milestone steps.
class JanSetuProjectCard extends StatelessWidget {
  final String projectName;
  final String departmentId;
  final double sanctionedBudgetINR;
  final double disbursedAmountINR;
  final int progressPercentage;
  final String status;
  final VoidCallback? onTap;

  const JanSetuProjectCard({
    super.key,
    required this.projectName,
    required this.departmentId,
    required this.sanctionedBudgetINR,
    required this.disbursedAmountINR,
    required this.progressPercentage,
    required this.status,
    this.onTap,
  });

  String _formatINR(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    }
    return '₹${(amount / 100000).toStringAsFixed(1)} Lakh';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = progressPercentage == 100;
    final progressColor = isCompleted ? JanSetuColors.emeraldGreen : JanSetuColors.electricBlue;

    return JanSetuCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
                ),
                child: Text(
                  status.replaceAll('_', ' '),
                  style: TextStyle(color: progressColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              Text(
                _formatINR(sanctionedBudgetINR),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: JanSetuColors.slateNavy),
              ),
            ],
          ),
          const SizedBox(height: JanSetuTheme.space12),
          Text(
            projectName,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: JanSetuTheme.space16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress ($progressPercentage%)',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              Text(
                'Disbursed: ${_formatINR(disbursedAmountINR)}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: JanSetuColors.emeraldGreen),
              ),
            ],
          ),
          const SizedBox(height: JanSetuTheme.space8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressPercentage / 100.0,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: JanSetuTheme.space12),
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Cryptographic Escrow Linked • 3 Milestones',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
