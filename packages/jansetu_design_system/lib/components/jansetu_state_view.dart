import 'package:flutter/material.dart';
import '../theme/jansetu_colors.dart';
import '../theme/jansetu_theme.dart';

enum JanSetuUIState {
  loading,
  empty,
  offline,
  permissionDenied,
  noResults,
  noInternet,
  aiError,
  serverError,
  retry,
  maintenance,
}

/// Universal 10-State UI Handler Widget (JanSetuStateView)
/// Renders standardized empty, error, offline, and shimmer states.
class JanSetuStateView extends StatelessWidget {
  final JanSetuUIState state;
  final String? customMessage;
  final VoidCallback? onRetryAction;

  const JanSetuStateView({
    super.key,
    required this.state,
    this.customMessage,
    this.onRetryAction,
  });

  @override
  Widget build(BuildContext context) {
    if (state == JanSetuUIState.loading) {
      return _buildLoadingShimmer();
    }

    IconData icon;
    String title;
    String message;
    Color iconColor = JanSetuColors.slateNavy;

    switch (state) {
      case JanSetuUIState.empty:
        icon = Icons.inbox_outlined;
        title = "No Records Found";
        message = customMessage ?? "There are currently no civic grievances or capital works in this jurisdiction.";
        break;
      case JanSetuUIState.offline:
      case JanSetuUIState.noInternet:
        icon = Icons.wifi_off_rounded;
        title = "Offline Mode Active";
        message = customMessage ?? "Showing locally cached Riverpod data. Changes will sync automatically when online.";
        iconColor = JanSetuColors.saffronGold;
        break;
      case JanSetuUIState.permissionDenied:
        icon = Icons.lock_outline_rounded;
        title = "Access Restricted (RBAC)";
        message = customMessage ?? "You do not have the required officer or contractor clearance to view this classified ledger.";
        iconColor = JanSetuColors.crimsonAlert;
        break;
      case JanSetuUIState.noResults:
        icon = Icons.search_off_rounded;
        title = "No Matches Found";
        message = customMessage ?? "We could not find any development needs matching your ward or department filters.";
        break;
      case JanSetuUIState.aiError:
        icon = Icons.smart_toy_outlined;
        title = "Gemini AI Copilot Unavailable";
        message = customMessage ?? "Our multimodal routing engine is currently experiencing latency. Please try submitting again.";
        iconColor = JanSetuColors.saffronGold;
        break;
      case JanSetuUIState.serverError:
      case JanSetuUIState.retry:
        icon = Icons.error_outline_rounded;
        title = "Server Connection Error";
        message = customMessage ?? "We could not reach the Firestore database. Please check your network connection.";
        iconColor = JanSetuColors.crimsonAlert;
        break;
      case JanSetuUIState.maintenance:
        icon = Icons.build_circle_outlined;
        title = "Scheduled Governance Maintenance";
        message = customMessage ?? "The JanSetu platform is undergoing scheduled security and digital twin calibration.";
        iconColor = JanSetuColors.electricBlue;
        break;
      default:
        icon = Icons.info_outline_rounded;
        title = "System Status";
        message = customMessage ?? "Please check back later.";
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(JanSetuTheme.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: iconColor),
            const SizedBox(height: JanSetuTheme.space16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: JanSetuTheme.space8),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (onRetryAction != null) ...[
              const SizedBox(height: JanSetuTheme.space24),
              ElevatedButton.icon(
                onPressed: onRetryAction,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text("Retry Connection"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: JanSetuColors.electricBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 4,
      padding: const EdgeInsets.all(JanSetuTheme.space16),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: JanSetuTheme.space16),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
          ),
        );
      },
    );
  }
}
