import 'package:flutter/material.dart';

class DashboardStatCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  const DashboardStatCard({Key? key, required this.label, required this.value, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: SizedBox(
        width: 140,
        height: 80,
        child: onTap == null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const Spacer(),
                  Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
              )
            : InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Spacer(),
                    Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
      ),
    );

    return card;
  }
}
