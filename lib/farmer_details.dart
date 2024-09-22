import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/new_farmer_entry_dialog.dart';

class FarmerDetailsScreen extends StatelessWidget {
  final Farmer farmer;
  const FarmerDetailsScreen({
    super.key,
    required this.farmer,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mkulima"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return FarmerEntryDialog(farmerData: farmer);
                    },
                    fullscreenDialog: true),
              );
            },
            icon: const Icon(FontAwesomeIcons.penToSquare),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: size.height * 0.17,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        Positioned(
                          top: 15,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: size.height * 0.12,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 112,
                          child: Container(
                            height: size.height * 0.17,
                            width: size.width * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 132,
                          child: Container(
                            height: size.height * 0.12,
                            width: size.width * 0.25,
                            decoration: BoxDecoration(
                              // color: Colors.green,
                              borderRadius: BorderRadius.circular(50),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    "https://img.freepik.com/premium-vector/vector-flat-illustration-grayscale-avatar-user-profile-person-icon-profile-picture-suitable-social-media-profiles-icons-screensavers-as-templatex9xa_719432-1256.jpg?semt=ais_hybrid"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            color: Colors.white,
                            height: 50,
                            width: size.width * 0.33,
                          ),
                        ),
                        Positioned(
                          top: 80,
                          child: Container(
                            color: Colors.white,
                            height: 20,
                            width: size.width * 0.30,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 34,
                          child: Container(
                            color: Colors.white,
                            height: 20,
                            width: size.width * 0.33,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 80,
                          child: Container(
                            color: Colors.white,
                            height: 40,
                            width: size.width * 0.33,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.grey,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.userTie,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 24),
                        Text(
                            "${farmer.firstName} ${farmer.middleName} ${farmer.lastName}")
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          farmer.gender.toLowerCase() == "ke"
                              ? Icons.female
                              : Icons.male,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 24),
                        Text(farmer.gender)
                      ],
                    ),
                    const SizedBox(height: 8),
                    // const Divider(
                    //   thickness: 0.5,
                    //   color: Colors.grey,
                    // ),
                    // const SizedBox(height: 8),
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       FontAwesomeIcons.clock,
                    //       size: 18,
                    //       color: Colors.green,
                    //     ),
                    //     const SizedBox(width: 24),
                    //     Text(" Miaka ${farmer.age}")
                    //   ],
                    // ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.grey,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.phone,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 24),
                        Text(farmer.phone)
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationPin,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 24),
                        Text(farmer.zone)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.grey,
                      ),
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.crop_landscape,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 24),
                        Text(" Hekari ${farmer.farmSize}")
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.wheatAwn,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 24),
                        Text(" Miti ${farmer.numberOfTrees}")
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.grey,
                      ),
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.buildingColumns,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 24),
                        Text(farmer.bankName)
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.creditCard,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 24),
                        Text(farmer.accountNumber)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
