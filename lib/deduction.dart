import 'package:flutter/material.dart';

class DeductionScreen extends StatefulWidget {
  const DeductionScreen({super.key});

  @override
  State<DeductionScreen> createState() => _DeductionScreenState();
}

class _DeductionScreenState extends State<DeductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("Makato"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text("Kiingilio"),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Jaza gharama za kiingilio",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Text("Hisa"),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Jaza thamani ya hisa",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Text("Mkopo"),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Jaza thamani ya mkopo",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            bottom: 24,
            right: 16,
            left: 16,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: 8),
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: Text("Hifadhi"),
          ),
        ),
      ),
    );
  }
}
