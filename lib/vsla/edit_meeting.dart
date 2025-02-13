import 'package:flutter/material.dart';

class EditMeetingScreen extends StatefulWidget {
  const EditMeetingScreen({super.key});

  @override
  State<EditMeetingScreen> createState() => _EditMeetingScreenState();
}

class _EditMeetingScreenState extends State<EditMeetingScreen> {
  late TextEditingController _purposeController;
  late TextEditingController _dateController;
  late TextEditingController _summaryController;

  @override
  void initState() {
    _purposeController = TextEditingController(text: "Weekly group meeting");
    _dateController = TextEditingController(text: "12-12-2024");
    _summaryController = TextEditingController(
        text: "Collections TZS 230,000 \n Loans Out 90,000");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 149, 108),
        foregroundColor: Colors.white,
        title: Text("Edit meeting"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: 16),
            Text("Purpose"),
            SizedBox(height: 8),
            TextFormField(
              controller: _purposeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text("Date"),
            SizedBox(height: 8),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text("Summary"),
            SizedBox(height: 8),
            TextFormField(
              controller: _summaryController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextButton(
            onPressed: () {},
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                const Color.fromARGB(255, 64, 149, 108),
              ),
            ),
            child: Text(
              "Save Update",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
