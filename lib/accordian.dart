import 'package:flutter/material.dart';

class MyAccordion extends StatelessWidget {
  final String title;
  const MyAccordion({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), const Text("85,000")],
        ),
        children: <Widget>[
          ListTile(
            title: Text('Kukata miti'),
            trailing: Text("30,000"),
          ),
          ListTile(
            title: Text('Kutengeneza matuta'),
            trailing: Text("55,000"),
          ),
        ],
      ),
    );
  }
}
