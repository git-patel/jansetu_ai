import 'package:flutter/material.dart';
import '../theme/jansetu_colors.dart';
import '../theme/jansetu_theme.dart';
import 'jansetu_card.dart';

/// Civic Grievance Card Widget (JanSetuNeedCard)
/// Displays development needs with priority badges, bilingual transcripts, clean AI summary, and action buttons.
class JanSetuNeedCard extends StatelessWidget {
  final String titleEnglish;
  final String titleVernacular;
  final String departmentId;
  final double priorityScore;
  final String status;
  final int upvoteCount;
  final String? locationName;
  final String? aiSummary;
  final bool isSupported;
  final int commentCount;
  final VoidCallback? onTap;
  final VoidCallback? onSupport;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onTrack;

  const JanSetuNeedCard({
    super.key,
    required this.titleEnglish,
    required this.titleVernacular,
    required this.departmentId,
    required this.priorityScore,
    required this.status,
    this.upvoteCount = 0,
    this.locationName,
    this.aiSummary,
    this.isSupported = false,
    this.commentCount = 0,
    this.onTap,
    this.onSupport,
    this.onComment,
    this.onShare,
    this.onTrack,
  });

  String _formatDept(String deptId) {
    return deptId.replaceAll('DEPT_', '').replaceAll('_', ' ');
  }

  String _formatStatus(String st) {
    switch (st) {
      case 'VERIFIED_AI':
        return 'AI Verified • Under Review';
      case 'ROUTED_TO_OFFICER':
        return 'Assigned to Officer';
      case 'SANCTIONED':
        return 'Sanctioned';
      case 'IN_EXECUTION':
        return 'Work in Progress';
      default:
        return st.replaceAll('_', ' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = JanSetuColors.getPriorityColor(priorityScore);
    final displayLocation = locationName ?? 'Adajan Ward';
    final displaySummary = aiSummary ?? 'AI verified civic requirement reported by local citizen witnesses.';

    return JanSetuCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Location Badge & Support Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: JanSetuColors.electricBlue),
                  const SizedBox(width: 4),
                  Text(
                    displayLocation,
                    style: const TextStyle(
                      color: JanSetuColors.electricBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    isSupported ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    size: 14,
                    color: isSupported ? JanSetuColors.emeraldGreen : Colors.grey[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$upvoteCount Citizens Support',
                    style: TextStyle(
                      color: isSupported ? JanSetuColors.emeraldGreen : Colors.grey[700],
                      fontWeight: isSupported ? FontWeight.bold : FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: JanSetuTheme.space12),
          // Title
          Text(
            '🚧 $titleVernacular / $titleEnglish',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: JanSetuTheme.space8),
          // Department & Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: JanSetuColors.electricBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_balance, size: 12, color: JanSetuColors.electricBlue),
                    const SizedBox(width: 4),
                    Text(
                      _formatDept(departmentId),
                      style: const TextStyle(
                        color: JanSetuColors.electricBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hourglass_top, size: 12, color: JanSetuColors.saffronGold),
                    const SizedBox(width: 4),
                    Text(
                      _formatStatus(status),
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: JanSetuTheme.space12),
          // AI Summary Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(JanSetuTheme.space12),
            decoration: BoxDecoration(
              color: JanSetuColors.electricBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
              border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 14, color: JanSetuColors.saffronGold),
                    SizedBox(width: 4),
                    Text(
                      'AI Summary & Rationale',
                      style: TextStyle(
                        color: JanSetuColors.saffronGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '"$displaySummary"',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: JanSetuTheme.space12),
          Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: JanSetuTheme.space8),
          // Action Buttons Bar: Support, Comment, Share, Track
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 4,
            runSpacing: 8,
            children: [
              _buildActionButton(
                icon: isSupported ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                label: isSupported ? 'Supported ($upvoteCount)' : 'Support ($upvoteCount)',
                color: isSupported ? JanSetuColors.emeraldGreen : Colors.grey[300]!,
                onTap: onSupport,
              ),
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                label: 'Comments ($commentCount)',
                color: Colors.grey[300]!,
                onTap: onComment,
              ),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                color: Colors.grey[300]!,
                onTap: onShare,
              ),
              _buildActionButton(
                icon: Icons.info_outline,
                label: 'View Details',
                color: JanSetuColors.saffronGold,
                onTap: onTap,
              ),
              _buildActionButton(
                icon: Icons.my_location,
                label: 'View Timeline ➔',
                color: JanSetuColors.electricBlue,
                onTap: onTrack ?? onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
