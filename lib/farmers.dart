import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ratek/db/local.dart';
import 'package:ratek/farmer_details.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/new_farmer_entry_dialog.dart';

class FarmersScreen extends StatefulWidget {
  const FarmersScreen({super.key});

  @override
  State<FarmersScreen> createState() => _FarmersScreenState();
}

class _FarmersScreenState extends State<FarmersScreen> {
  Stream getSales() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("uwamambo-farmers").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalDatabase.getFarmers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Farmer> farmers = snapshot.data!.map((farmerMap) {
          return Farmer.fromMap(farmerMap);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Wakulima"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ListView.builder(
              itemCount: farmers.length,
              itemBuilder: (context, index) {
                final farmer = farmers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FarmerDetailsScreen(farmer: farmer),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://img.freepik.com/premium-vector/vector-flat-illustration-grayscale-avatar-user-profile-person-icon-profile-picture-suitable-social-media-profiles-icons-screensavers-as-templatex9xa_719432-1256.jpg?semt=ais_hybrid"),
                          radius: 28,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${farmer.firstName} ${farmer.lastName}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "Gusa kuona taarifa zaidi",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              const Icon(
                                FontAwesomeIcons.chevronRight,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return const FarmerEntryDialog();
                    },
                    fullscreenDialog: true),
              );
              setState(() {});
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
