import 'dart:math';
import 'package:flutter/material.dart';

class ApplicationsPieChart extends StatelessWidget {
  final Map<String, int> data;
  const ApplicationsPieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<int>(0, (p, n) => p + n);
    if (total == 0) {
      return Container(
        height: 160,
        color: Colors.grey.shade200,
        child: const Center(child: Text('Aucune donnée')),
      );
    }

    final colors = [
      Theme.of(context).colorScheme.primary,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    final entries = data.entries.toList();

    return SizedBox(
      height: 160,
      child: Row(children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomPaint(
              painter: _PieChartPainter(entries.map((e) => e.value.toDouble()).toList(), colors),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(entries.length, (i) {
              final key = entries[i].key;
              final val = entries[i].value;
              final c = colors[i % colors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(children: [
                  Container(width: 12, height: 12, color: c),
                  const SizedBox(width: 8),
                  Expanded(child: Text('$key — $val')),
                ]),
              );
            }),
          ),
        ),
      ]),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  _PieChartPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(rect.width / 2, rect.height / 2);
    final radius = (rect.shortestSide) * 0.4;

    final total = values.fold<double>(0, (p, n) => p + n);
    double startAngle = -pi / 2;
    for (int i = 0; i < values.length; i++) {
      final sweep = values[i] / total * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweep, true, paint);
      startAngle += sweep;
    }

    // draw center circle
    final centerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.36, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.colors != colors;
  }
}


