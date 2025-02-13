// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ratek/models/deduction.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/providers/deduction_provider.dart';
import 'package:ratek/providers/farmer_provider.dart';
import 'package:ratek/utils/sentense_cate.dart';

class DeductionScreen extends ConsumerStatefulWidget {
  const DeductionScreen({super.key});

  @override
  ConsumerState<DeductionScreen> createState() => _DeductionScreenState();
}

class _DeductionScreenState extends ConsumerState<DeductionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedFarmer;
  String fees = "";
  String hisa = "";
  String loan = "";
  bool isSaving = false;

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text("Mkulima"),
              SizedBox(height: 8),
              DropdownSearch<Farmer>(
                items: (String? filter, t) async {
                  final results = await ref.watch(farmerfutureProvider.future);
                  print("filer:$filter");
                  // If filter is empty or null, return all farmers
                  if (filter == null || filter.isEmpty) {
                    return results;
                  }

                  final normalizedFilter = filter.toLowerCase().trim();
                  final filtered = results.where((farmer) {
                    final firstName = farmer.firstName.toLowerCase().trim();
                    return firstName.contains(normalizedFilter);
                  }).toList();

                  print(filtered.length);

                  return filtered;
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
                  onItemsLoaded: (value) {
                    debugPrint(value.toString());
                  },
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
              SizedBox(height: 24),
              Text("Kiingilio"),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Jaza gharama za kiingilio",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => fees = value!,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 24),
              Text("Hisa"),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Jaza thamani ya hisa",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => hisa = value!,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 24),
              Text("Mkopo"),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Jaza thamani ya mkopo",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => loan = value!,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();

                Deduction deduction = Deduction(
                  id: "",
                  farmerId: selectedFarmer!,
                  loan: double.parse(loan),
                  hisa: double.parse(hisa),
                  fees: double.parse(fees),
                );

                try {
                  setState(() {
                    isSaving = true;
                  });
                  await ref
                      .read(deductionProvider.notifier)
                      .addDeduction(deduction);
                  setState(() {
                    isSaving = false;
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Umesajiri makato kikamilifu"),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    isSaving = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Makato hayajafanyika, jaribu baadae!"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  );
                }
              }
            },
            child: isSaving
                ? CupertinoActivityIndicator(
                    color: Colors.white,
                  )
                : Text("Hifadhi"),
          ),
        ),
      ),
    );
  }
}
