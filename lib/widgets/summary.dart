import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          size: 12.w,
        ),
        SizedBox(height: 6.h),
        Text(
          title,
          style: TextStyle(color: Colors.green, fontSize: 14.sp),
        ),
        SizedBox(height: 6.h),
        Flexible(
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 10.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
