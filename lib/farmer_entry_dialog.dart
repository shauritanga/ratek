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

class FarmerEntryDialog extends StatefulWidget {
  const FarmerEntryDialog({super.key});

  @override
  State<FarmerEntryDialog> createState() => _FarmerEntryDialogState();
}

class _FarmerEntryDialogState extends State<FarmerEntryDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _dayController = TextEditingController();
  String phoneNumber = "";
  String? selectedZone;
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
  String dob = "";
  String imageUrl = "";

  bool isLoading = false;
  UploadTask? uploadTask;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mkulima mpya"),
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
                ),
                const SizedBox(height: 16),
                const Text("Namba ya kitambulisho"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Namba ya NIDA au Kura",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (value) => nida = value,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Text("Tarehe ya kuzaliwa"),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Chagua tarehe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        DatePicker.localeFromString("kis");
                        var datePicked = await DatePicker.showSimpleDatePicker(
                          context,
                          // initialDate: DateTime(2020),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(DateTime.now().year - 18),
                          dateFormat: "dd-MMMM-yyyy",
                          locale: DateTimePickerLocale.en_us,
                          titleText: "Chagua tarehe",
                          backgroundColor: Colors.white,
                          looping: true,
                          confirmText: "Ndiyo",
                          cancelText: "Hapana",
                        );

                        setState(() {
                          dob = datePicked!.toIso8601String();
                          _dayController.text =
                              DateFormat.yMMMMd().format(datePicked);
                        });
                      },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ),
                  controller: _dayController,
                  keyboardType: TextInputType.datetime,
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
                const Text("Kijiji"),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Jaza Kijiji",
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
                /*const SizedBox(height: 16),
                const Text("Picha"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        ImagePicker picker = ImagePicker();
                        final pickedImage =
                            await picker.pickImage(source: ImageSource.camera);

                        final file = File(pickedImage!.path);
                        setState(() {
                          isLoading = true;
                        });
                        await uploadProfileImage(file, pickedImage);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: isLoading
                            ? const Material(
                                child: Center(
                                  child: SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              )
                            : Image.network(
                                imageUrl == ""
                                    ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQofHJFmvUkoZgk9cHJsB5XrkMGy2W-qIiCqkIhXWv3e1GkxA_N2mfS&usqp=CAE&s"
                                    : imageUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),*/
                const SizedBox(height: 32),
                MaterialButton(
                  onPressed: () async {
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
                        "zone": selectedZone!,
                        "village": village,
                        "bank_name": bankName!,
                        "account_number": accountNumber,
                        "farm_size": numberOfHectors,
                        "number_of_trees": numberOfTrees,
                        "number_of_trees_with_fruits": numberOfTreesWithFruits,
                      };

                      print(data);

                      final reference = await showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                          LocalDatabase.insertFarmer(data),
                          message: const Text('Saving...'),
                        ),
                      );

                      if (!reference) {
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
