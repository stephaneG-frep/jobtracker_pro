import 'package:flutter/material.dart';
import '../models/job_application.dart';

/// One color per status, shared by cards, chips, Kanban columns and charts.
const Map<ApplicationStatus, MaterialColor> _statusPalette = {
  ApplicationStatus.prepare: Colors.blueGrey,
  ApplicationStatus.sent: Colors.blue,
  ApplicationStatus.followUp: Colors.orange,
  ApplicationStatus.interview: Colors.purple,
  ApplicationStatus.rejected: Colors.red,
  ApplicationStatus.accepted: Colors.green,
};

/// Accent color of [status], lighter on dark themes so it stays readable.
Color statusColor(BuildContext context, ApplicationStatus status) {
  final base = _statusPalette[status]!;
  return Theme.of(context).brightness == Brightness.dark
      ? base.shade300
      : base.shade600;
}

/// Card background lightly tinted with [accent], on top of the theme's card color.
Color tintedCardColor(BuildContext context, Color accent) {
  final theme = Theme.of(context);
  final cardColor =
      theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
  final alpha = theme.brightness == Brightness.dark ? 56 : 40;
  return Color.alphaBlend(accent.withAlpha(alpha), cardColor);
}
