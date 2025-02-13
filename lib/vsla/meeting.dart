import 'package:flutter/material.dart';
import 'package:ratek/vsla/edit_meeting.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final List<Map<String, dynamic>> attendee = [
    {"name": "Athanas Shauri", "phone": "+255 655 591 660"},
    {"name": "Jamal Zuberi", "phone": "+255 788 591 669"},
    {"name": "Amour Hassan", "phone": "+255 655 091 670"},
    {"name": "Hamza Said", "phone": "+255 655 000 128"},
    {"name": "Samwel Zenda", "phone": "+255 652 591 667"},
    {"name": "Zuwena Rashid", "phone": "+255 757 591 000"},
    {"name": "Latifa Ismail", "phone": "+255 773 591 860"},
    {"name": "Vailet Nyoni", "phone": "+255 785 591 009"},
    {"name": "Joseph Kibelezo", "phone": "+255 715 591 110"},
    {"name": "Monica Chipasula", "phone": "+255 625 591 608"},
    {"name": "Geophrey Mtweve", "phone": "+255 655 545 690"},
    {"name": "Bedon Kaisi", "phone": "+255 713 591 222"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 149, 108),
        foregroundColor: Colors.white,
        title: Text("Meeting"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18),
            Text("Main"),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Purpose",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Weekly group meeting"),
                  SizedBox(height: 16),
                  Text(
                    "Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("12-12-2024"),
                  SizedBox(height: 16),
                  Text(
                    "Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Collections: TZS 230,000"),
                  Text("Loans Out: TZS 90,000"),
                ],
              ),
            ),
            SizedBox(height: 18),
            Text("Attendance"),
            SizedBox(height: 8),
            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: attendee.length,
              itemBuilder: (context, index) {
                final attende = attendee[index];
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(attende['name']),
                      Text(attende['phone']),
                    ],
                  ),
                );
              },
            ))
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => EditMeetingScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    const Color.fromARGB(255, 64, 149, 108),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Text(
                  "Edit Meeting",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    const Color.fromARGB(255, 64, 149, 108),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Text(
                  "Attendance",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
