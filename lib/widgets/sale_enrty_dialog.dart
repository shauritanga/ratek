import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:ratek/db/local.dart';
import 'package:ratek/db/remote.dart';

class SaleEntryDialog extends StatefulWidget {
  const SaleEntryDialog({super.key});

  @override
  State<SaleEntryDialog> createState() => _SaleEntryDialogState();
}

class _SaleEntryDialogState extends State<SaleEntryDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<TextEditingController> _controllers = [];
  String? selectedFarmer;

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
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text("Mkulima"),
            const SizedBox(height: 8),
            Container(
              height: 56,
              decoration: BoxDecoration(
                //border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownSearch<String>(
                items: (String? filter, t) async {
                  final results =
                      await FirestoreService.getFullNames(filter ?? '');
                  debugPrint(results.toString());
                  return results
                      .map((row) => row['full_name'] as String)
                      .toList();
                },
                decoratorProps: const DropDownDecoratorProps(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    labelStyle: TextStyle(),
                    labelText: "Tafuta mkulima",
                    hintText: "Search for a farmer by name",
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    selectedFarmer = value;
                  });
                },
                popupProps: const PopupProps.menu(
                    showSearchBox: true, // Enables search box
                    searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(helperText: "tafuta hapa"),
                        autofocus: true)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Uzito(Kg)"),
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
                      keyboardType: TextInputType.number,
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
                  child: const Text('Ongeza'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    double cost = 0.0;
                    List<String> values = _controllers
                        .map((controller) => controller.text)
                        .toList();
                    final totalWeight = values.fold(0,
                        (previous, element) => previous + int.parse(element));
                    cost = totalWeight * 2000;
                    final Map<String, dynamic> data = {
                      "date": DateTime.now().toIso8601String(),
                      "farmer": selectedFarmer.toString(),
                      "amount": cost,
                      "synced": 0,
                      "corperate_id": "g45e",
                      "weight": totalWeight
                    };

                    final reference = await showDialog(
                      context: context,
                      builder: (context) => FutureProgressDialog(
                          LocalDatabase.insertSale(data),
                          message: const Text('Inatuma...')),
                    );

                    if (!reference) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mauzo hayajafanyika, jaribu tena!"),
                        ),
                      );
                      return;
                    }

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Mauzo yamefanyika"),
                        duration: Duration(seconds: 3),
                      ),
                    );

                    await Future.delayed(
                      const Duration(seconds: 3),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: const Text("Tuma"),
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
