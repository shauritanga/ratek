import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color color;
  final String icon;
  final void Function()? onTap;
  final Size? size;
  const CustomCard({
    super.key,
    this.title = "",
    required this.icon,
    this.color = Colors.white,
    this.onTap,
    this.size,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: color, width: 5),
          ),
          borderRadius: BorderRadius.circular(7),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0.5, 1),
                blurRadius: 0.5,
                spreadRadius: 1,
                color: Colors.grey)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              icon,
              width: 20,
              height: 20,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
