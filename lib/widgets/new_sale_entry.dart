import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaleEntryDialogg extends StatefulWidget {
  const SaleEntryDialogg({super.key});

  @override
  State<SaleEntryDialogg> createState() => _SaleEntryDialoggState();
}

class _SaleEntryDialoggState extends State<SaleEntryDialogg> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<TextEditingController> _controllers = [];
  String? selectedFarmer;

  int currentValue = 1;

  @override
  void initState() {
    super.initState();
    // Initialize with the first input field
    _controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addInputField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mauzo"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text("Mkulima"),
            const SizedBox(height: 8),
            Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Chagua mkulima'),
                    value: selectedFarmer,
                    onChanged: (String? value) {
                      setState(() {
                        selectedFarmer = value;
                      });
                    },
                    items: [
                      "Athanas Shauritanga",
                      "Hamis Kigwangala",
                      "James Mwang'amba",
                    ].map((product) {
                      return DropdownMenuItem<String>(
                        value: product,
                        child: Text(product),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _controllers[index],
                      decoration: const InputDecoration(
                        suffix: Text("Kg"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addInputField,
                  child: const Text('Add Input Field'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
