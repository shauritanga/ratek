import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const Summary({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.green,
          size: 12,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(color: Colors.green, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Flexible(
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
