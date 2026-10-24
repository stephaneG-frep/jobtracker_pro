import 'package:flutter/material.dart';
import '../theme/status_colors.dart';

/// A card tinted with [color], with a colored stripe on its left edge.
class AccentCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const AccentCard({
    super.key,
    required this.color,
    required this.child,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      child: child,
    );

    return Card(
      margin: margin,
      color: tintedCardColor(context, color),
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
