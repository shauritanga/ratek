import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ratek/db/local.dart';
import 'package:ratek/models/farmer.dart';

class FarmerEntryDialog extends StatefulWidget {
  final Farmer? farmerData; // Data for editing
  const FarmerEntryDialog({super.key, this.farmerData});

  @override
  State<FarmerEntryDialog> createState() => _FarmerEntryDialogState();
}

class _FarmerEntryDialogState extends State<FarmerEntryDialog> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _dayController = TextEditingController();

  String phoneNumber = "";
  String? selectedZone;
  String ward = "";
  String village = "";
  String? bankName;
  String accountNumber = "";
  String? nida;
  String? selectedGender;
  String firstName = "";
  String secondName = "";
  String thirdName = "";
  String numberOfTrees = "";
  String numberOfTreesWithFruits = "";
  String numberOfHectors = "";
  String? dob;
  String imageUrl = "";

  bool isLoading = false;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();

    // If farmerData exists (edit mode), populate the form fields
    if (widget.farmerData != null) {
      Farmer farmer = widget.farmerData!;
      firstName = farmer.firstName;
      secondName = farmer.middleName;
      thirdName = farmer.lastName;
      phoneNumber = farmer.phone;
      selectedZone = farmer.zone;
      village = farmer.village;
      ward = farmer.ward;
      selectedGender = farmer.gender;
      bankName = farmer.bankName;
      accountNumber = farmer.accountNumber;
      nida = farmer.nida;
      numberOfHectors = farmer.farmSize.toString();
      numberOfTrees = farmer.numberOfTrees.toString();
      numberOfTreesWithFruits = farmer.numberOfTreesWithFruits.toString();

      _dayController.text = formatDate(DateTime.parse(farmer.dob));
    } else {
      final DateTime now = DateTime.now();
      _dayController.text = formatDate(now);
      dob = formatDate(now);
    }
  }

  Future uploadProfileImage(File file, XFile? pickedImage) async {
    final path = "images/${pickedImage!.name}";
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      ref.putFile(file);
    } catch (e) {
      throw Exception("File upload failed");
    }

    setState(() {
      uploadTask = ref.putFile(file);
    });
    try {
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = urlDownload;
      });
    } catch (e) {
      throw Exception("Fail to upload to firebase storage");
    }
  }

  @override
  void dispose() {
    _dayController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dayController.text = formatDate(pickedDate);
      });
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please select a date";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farmerData == null
            ? "Mkulima mpya"
            : "Badilisha Taarifa"), // Update title
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
                const Text("Jina la kwanza"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: firstName, // Pre-fill the field for edit mode
                  decoration: InputDecoration(
                    hintText: "Jina la kwanza",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => firstName = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jina la kwanza ni lazima";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Jina la pili"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: secondName, // Pre-fill the field for edit mode
                  decoration: InputDecoration(
                    hintText: "Jina la Pili",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => secondName = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jina la pili ni lazima";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Jina la ukoo"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: thirdName, // Pre-fill the field for edit mode
                  decoration: InputDecoration(
                    hintText: "Jina la Ukoo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => thirdName = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jina la ukoo ni lazima";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Jinsia"),
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
                        hint: const Text('Chagua'),
                        value: selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        items: [
                          "Me",
                          "Ke",
                        ].map((gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Namba ya simu"),
                const SizedBox(height: 8),
                IntlPhoneField(
                  initialValue: phoneNumber,
                  decoration: const InputDecoration(
                    labelText: 'Namba ya simu',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'TZ',
                  onChanged: (phone) {
                    setState(() {
                      phoneNumber = phone.completeNumber;
                    });
                  },
                  validator: (value) {
                    if (value!.completeNumber.length < 10) {
                      return "Jaza namba ya simu";
                    }
                    if (value.number.isEmpty) {
                      return "Jaza namba ya simu";
                    }
                    if (value.toString().isEmpty) {
                      return "Jaza namba ya simu";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Tarehe ya kuzaliwa"),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: true,
                  controller: _dayController,
                  decoration: InputDecoration(
                    hintText: "Chagua tarehe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                  onSaved: (value) {
                    dob = value;
                  },
                  validator: _validateDate,
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16),
                const Text("Namba ya kitambulisho"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: nida,
                  decoration: InputDecoration(
                    hintText: "Namba ya NIDA au Kura",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => nida = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza namba ya NIDA";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
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
                          "Hasamba",
                          "Hezya",
                          "Idiwili",
                          "Igamba",
                          "Ipunga",
                          "Iyula",
                          "Mlowo",
                          "Shiwinga",
                          "Vwawa"
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
                const SizedBox(height: 16.0),
                const Text("Kata"),
                TextFormField(
                  initialValue: village,
                  decoration: InputDecoration(
                    hintText: "Jaza Kata",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => ward = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza kata";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16.0),
                const Text("Kijiji"),
                TextFormField(
                  initialValue: village,
                  decoration: InputDecoration(
                    hintText: "Jaza Kijiji",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => village = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza kijiji";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Jina la banki"),
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
                        hint: const Text('Chagua banki'),
                        value: bankName,
                        onChanged: (String? value) {
                          setState(() {
                            bankName = value;
                          });
                        },
                        items: [
                          "NMB",
                          "CRDB",
                          "PBZ",
                          "Akiba",
                          "BOA",
                          "Stanbic",
                          "Access",
                          "Absa",
                          "BancABC",
                          "Amana",
                          "Azania",
                          "Bank of India",
                          "Citibank",
                          "DCB",
                          "DTB",
                          "Ecobank",
                          "Equity",
                          "Exim",
                          "GTBank",
                          "Habib African Bank",
                          "I&M Bank",
                          "ICBank",
                          "KCB",
                          "Letshengo",
                          "NBC",
                          "Mwalimu Commercial Bank",
                          "Mkombozi",
                          "NCBA",
                          "Standard Charted",
                          "TCB",
                          "UBA",
                          "Mwanga Hakika"
                        ].map((bankName) {
                          return DropdownMenuItem<String>(
                            value: bankName,
                            child: Text(bankName),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Akaunti namba"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: accountNumber,
                  decoration: InputDecoration(
                    hintText: "Jaza namba ya akaunti",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => accountNumber = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza akaunti namba";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                const Text("Ukubwa wa shamba (Hekari)"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: numberOfHectors,
                  decoration: InputDecoration(
                    hintText: "Shamba ni heka ngapi?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => numberOfHectors = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza akaunti namba";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Text("Idadi ya miti shambani"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: numberOfTrees,
                  decoration: InputDecoration(
                    hintText: "Jaza idadi ya miti kwenye shaamba",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => numberOfTrees = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza akaunti namba";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                const Text("Idadi ya miti inayozaa"),
                TextFormField(
                  initialValue: numberOfTreesWithFruits,
                  decoration: InputDecoration(
                    hintText: "Jaza idadi ya miti yenye matunda",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => numberOfTreesWithFruits = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza akaunti namba";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                MaterialButton(
                  onPressed: () async {
                    bool reference = false;
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();

                      if (selectedGender == null ||
                          bankName == null ||
                          selectedZone == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Jaza taarifa zote"),
                          ),
                        );
                        return;
                      }
                      Map<String, dynamic> data = {
                        "first_name": firstName,
                        "middle_name": secondName,
                        "last_name": thirdName,
                        "gender": selectedGender!,
                        "phone": phoneNumber,
                        "nida": nida,
                        "dob": dob,
                        "synced": 0,
                        "zone": selectedZone!,
                        "ward": ward,
                        "village": village,
                        "bank_name": bankName!,
                        "account_number": accountNumber,
                        "farm_size": numberOfHectors,
                        "number_of_trees": numberOfTrees,
                        "number_of_trees_with_fruits": numberOfTreesWithFruits,
                      };

                      if (widget.farmerData == null) {
                        // New farmer - Insert to Firestore
                        reference = await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            LocalDatabase.insertFarmer(data),
                            message: const Text('Saving...'),
                          ),
                        );
                      } else {
                        // Edit farmer - Update Firestore record
                        data['id'] = widget.farmerData!.id;
                        reference = await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            LocalDatabase.updateFarmer(data),
                            message: const Text('Saving...'),
                          ),
                        );
                      }
                      if (!reference) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Hujafanikiwa kusajiri"),
                          ),
                        );
                        return;
                      }

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Umefanikwa kusajiri"),
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
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  height: 45,
                  minWidth: double.infinity,
                  child: isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(widget.farmerData == null
                          ? "Tuma taarifa"
                          : "Badilisha taarifa"),
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
