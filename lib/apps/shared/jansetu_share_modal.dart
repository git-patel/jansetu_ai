import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';

/// Meaningful Share Preview Modal (JanSetuShareModal)
/// Implements Prompt 08 share card generation: Title, Location, AI Summary, Status, Support Count, and Deep Link.
class JanSetuShareModal extends StatelessWidget {
  final String title;
  final String location;
  final String aiSummary;
  final String status;
  final int supportCount;
  final String needId;

  const JanSetuShareModal({
    super.key,
    required this.title,
    required this.location,
    required this.aiSummary,
    required this.status,
    required this.supportCount,
    required this.needId,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String location,
    required String aiSummary,
    required String status,
    required int supportCount,
    required String needId,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => JanSetuShareModal(
        title: title,
        location: location,
        aiSummary: aiSummary,
        status: status,
        supportCount: supportCount,
        needId: needId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deepLink = 'https://jansetu.gov.in/need/$needId';

    return Container(
      padding: const EdgeInsets.all(JanSetuTheme.space24),
      decoration: const BoxDecoration(
        color: JanSetuColors.slateNavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(JanSetuTheme.radiusLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle & Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Share Civic Report',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: JanSetuTheme.space12),
          Text(
            'Generate preview card to share across WhatsApp, Telegram, or Community groups.',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
          const SizedBox(height: JanSetuTheme.space16),
          // Preview Card
          Container(
            padding: const EdgeInsets.all(JanSetuTheme.space16),
            decoration: BoxDecoration(
              color: JanSetuColors.darkSurface,
              borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
              border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: JanSetuColors.electricBlue),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: JanSetuColors.electricBlue),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: JanSetuColors.emeraldGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: JanSetuColors.emeraldGreen),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: JanSetuColors.darkBorder),
                  ),
                  child: Text(
                    '"$aiSummary"',
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: JanSetuColors.saffronGold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.thumb_up, size: 14, color: JanSetuColors.emeraldGreen),
                    const SizedBox(width: 4),
                    Text(
                      '$supportCount Citizens Support • JanSetu AI Development Twin',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: JanSetuTheme.space16),
          // Deep Link Placeholder
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: JanSetuColors.darkSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: JanSetuColors.darkBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.link, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    deepLink,
                    style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: deepLink));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Deep Link copied to clipboard!'), duration: Duration(seconds: 2)),
                    );
                  },
                  child: const Text('COPY', style: TextStyle(color: JanSetuColors.electricBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: JanSetuTheme.space24),
          // Action Buttons (Max 2 CTAs)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: '$title\n$location\n"$aiSummary"\n$deepLink'));
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report summary & link copied to clipboard!'), duration: Duration(seconds: 2)),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy Summary'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: JanSetuColors.darkBorder),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening WhatsApp / Community Share...'), duration: Duration(seconds: 2)),
                    );
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share Report'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: JanSetuColors.electricBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
