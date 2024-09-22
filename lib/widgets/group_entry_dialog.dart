import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class GroupEntryDialog extends StatefulWidget {
  const GroupEntryDialog({super.key});

  @override
  State<GroupEntryDialog> createState() => _GroupEntryDialogState();
}

class _GroupEntryDialogState extends State<GroupEntryDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedProduct;
  String? selectedZone;
  int crets = 0;
  String name = "";
  String region = "";
  String district = "";
  String ward = "";
  String village = "";
  int currentValue = 1;
  int totalMembers = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kikundi kipya"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text("Jina la kikundi"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Jaza jina la kikundi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => name = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jina la kikundi ni lazima";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Mkoa"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Jaza mkoa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => region = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jina la mkoa ni lazima";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Wilaya"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Jaza wilaya",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => district = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jina la wilaya ni lazima";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Kata"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Jaza kata",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => ward = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jina la kata ni lazima";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Kijiji"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Jaza kijiji au mtaa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => village = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza jina la mtaa au kijiji";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text("Idadi ya wanachama"),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onSaved: (value) => totalMembers = int.parse(value!),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Jina idadi ya wanachama";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Kanda"),
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
                        hint: const Text('Chagua Kanda'),
                        value: selectedZone,
                        onChanged: (String? value) {
                          setState(() {
                            selectedZone = value;
                          });
                        },
                        items: [
                          "Yombo",
                          "Kaskazini",
                          "Kanda ya ziwa",
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
                const SizedBox(height: 32),
                MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();

                      Map<String, dynamic> data = {
                        "name": name,
                        "region": region,
                        "district": district,
                        "ward": ward,
                        "village": village,
                        "total_members": totalMembers,
                        "zone": selectedZone,
                      };

                      DocumentReference reference = await showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                            firestore.collection("uwamambo-groups").add(data),
                            message: const Text('Saving...')),
                      );
                      reference.id;
                      if (reference.id.isEmpty) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Data not saved, try again"),
                          ),
                        );
                        return;
                      }

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Data saved successful"),
                          duration: Duration(seconds: 3),
                        ),
                      );

                      await Future.delayed(
                        const Duration(seconds: 3),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  height: 56,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  minWidth: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: Text("Tuma",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
