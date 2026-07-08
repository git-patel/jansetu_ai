import 'package:flutter/material.dart';
import '../theme/jansetu_theme.dart';

/// Reusable Material 3 Card Container for JanSetu AI
/// Provides standard elevation, border styling, and optional tap callback.
class JanSetuCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderSide? border;

  const JanSetuCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(JanSetuTheme.space16),
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = backgroundColor ?? theme.cardTheme.color ?? theme.colorScheme.surface;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
        border: border != null
            ? Border.fromBorderSide(border!)
            : (theme.cardTheme.shape as RoundedRectangleBorder?)?.side != null
                ? Border.fromBorderSide((theme.cardTheme.shape as RoundedRectangleBorder).side)
                : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
          child: content,
        ),
      );
    }

    return content;
  }
}
