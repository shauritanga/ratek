import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String? shortDescriprion;
  final String? description;
  final double? width;
  final double? height;
  final Color color;
  final String? image;
  final void Function()? onTap;
  final Size? size;
  const NewsCard({
    super.key,
    this.title = "",
    this.image,
    this.color = Colors.white,
    this.onTap,
    this.shortDescriprion,
    this.description,
    this.size,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                image: DecorationImage(
                  image: AssetImage("$image"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      maxLines: 2,
                      "$shortDescriprion",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 129, 129, 129),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
