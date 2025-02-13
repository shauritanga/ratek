// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:ratek/models/deduction.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/models/sale.dart';
import 'package:ratek/providers/deduction_provider.dart';
import 'package:ratek/providers/farmer_provider.dart';
import 'package:ratek/providers/sales_provider.dart';
import 'package:ratek/utils/sentense_cate.dart';

class SaleEntryDialog extends ConsumerStatefulWidget {
  const SaleEntryDialog({super.key});

  @override
  ConsumerState<SaleEntryDialog> createState() => _SaleEntryDialogState();
}

class _SaleEntryDialogState extends ConsumerState<SaleEntryDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<TextEditingController> _controllers = [];
  String? selectedFarmer;
  bool _isLoading = true;
  List<String> _priceList = [];
  int _selectedPrice = 2000;

  @override
  void initState() {
    super.initState();
    // Initialize with the first input field
    _controllers.add(TextEditingController());
    _fetchPrices();
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

  Future<void> _fetchPrices() async {
    try {
      // Reference to your Firestore collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('prices') // Your collection name
          .get();

      // Map Firestore data into a list of strings (zones)
      setState(() {
        _priceList =
            snapshot.docs.map((doc) => doc['price'].toString()).toList();
        _isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      debugPrint("Error fetching zones: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deductions = ref.watch(deductionProvider);
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
            DropdownSearch<Farmer>(
              items: (String? filter, t) async {
                final results = await ref.watch(farmerfutureProvider.future);
                return results
                    .map((farmer) => farmer)
                    .where(
                      (farmer) => farmer.firstName.toLowerCase().contains(
                            filter!.toLowerCase(),
                          ),
                    )
                    .toList();
              },
              compareFn: (item1, item2) => item1 != item2,
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  labelStyle: TextStyle(),
                  hintText: "Chagua mkulima",
                ),
              ),
              dropdownBuilder: (context, selectedItem) {
                return Text(
                    "${selectedItem?.firstName.toSentenceCase() ?? ''} ${selectedItem?.lastName.toSentenceCase() ?? ''}");
              },
              onChanged: (Farmer? value) {
                setState(() {
                  selectedFarmer = value?.id;
                });
              },
              popupProps: PopupProps.menu(
                showSearchBox: true, // Enables search box
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 239, 239, 239),
                    hintText: "Tafuta hapa",
                    isDense: true,
                    prefixIcon: Icon(CupertinoIcons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  autofocus: true,
                ),
                itemBuilder: (context, item, isDisabled, isSelected) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Text(
                        "${item.firstName.toSentenceCase()} ${item.lastName.toSentenceCase()}"),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text("Bei"),
            SizedBox(height: 8),
            _isLoading
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    isExpanded: true,
                    value: _selectedPrice.toString(),
                    hint: Text('Chagua bei'),
                    onChanged: (value) {
                      setState(() {
                        _selectedPrice = int.parse(value!);
                      });
                    },
                    items: _priceList
                        .map<DropdownMenuItem<String>>((String price) {
                      return DropdownMenuItem<String>(
                        value: price,
                        child: Text(price),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 24),
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
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                    final deduction = deductions.firstWhere(
                      (deduction) => deduction.farmerId == selectedFarmer,
                      orElse: () => Deduction(
                        id: "",
                        farmerId: "",
                        loan: 0.0,
                        hisa: 0.0,
                        fees: 0.0,
                      ),
                    );
                    final totalDeduction =
                        deduction.fees + deduction.hisa + deduction.loan;
                    try {
                      double cost = 0.0;
                      List<String> values = _controllers
                          .map((controller) => controller.text)
                          .toList();
                      final totalWeight = values.fold(
                          0.0,
                          (previous, element) =>
                              previous + double.parse(element));
                      cost = totalWeight * _selectedPrice;
                      final receive = totalWeight * (_selectedPrice - 70);
                      final uwamambo = cost - receive;
                      Sale sale = Sale(
                        id: "",
                        date: DateTime.now().toIso8601String(),
                        farmer: selectedFarmer!,
                        amount: cost,
                        corperate: "g45e",
                        weight: totalWeight,
                        uwamambo: uwamambo,
                        receive: receive - totalDeduction,
                      );

                      await showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                            ref.read(saleProvider.notifier).addDeduction(sale),
                            message: const Text('Inatuma...')),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mauzo yamefanyika"),
                          duration: Duration(seconds: 3),
                        ),
                      );

                      await Future.delayed(
                        const Duration(seconds: 3),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mauzo hayajafanyika, jaribu tena!"),
                        ),
                      );
                    }
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
