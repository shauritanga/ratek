import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String title = "Marketpalce";

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 149, 108),
        foregroundColor: Colors.white,
        leading: Icon(Icons.menu),
        title: Text(title),
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: const Color.fromARGB(255, 147, 203, 136),
          controller: _tabController,
          indicatorColor: Colors.white,
          onTap: (value) {
            if (value == 0) {
              setState(() {
                title = "Marketplace";
              });
            } else if (value == 1) {
              setState(() {
                title = "Education";
              });
            } else {
              setState(() {
                title = "Crops";
              });
            }
          },
          tabs: [
            Tab(
              text: "Marketplace",
            ),
            Tab(
              text: "Education",
            ),
            Tab(
              text: "Crops",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Order for products and services and we'll deliver them in less than 7 days",
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2.5 / 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  padding: EdgeInsets.all(16),
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("8"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/peasant.png",
                            height: 80,
                            width: 80,
                          ),
                          Text("Agro-inputs"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("5"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/tractor.png",
                            height: 80,
                            width: 80,
                          ),
                          Text("Tractors"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("15"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/solar.png",
                            height: 80,
                            width: 80,
                          ),
                          Text("Solar and Stoves"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("20"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/drone.png",
                            height: 80,
                            width: 80,
                          ),
                          Text("Irrigation Materials"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedShoppingCart01,
                color: Colors.black,
                size: 24.0,
              ),
            ),
          ),
          Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Learn new skills and access useful information"),
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2.5 / 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  padding: EdgeInsets.all(16),
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("4"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/financial.png",
                            height: 80,
                            width: 80,
                          ),
                          Text("Financial Literacy"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("35"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/nutrition.png",
                            height: 80,
                            width: 80,
                          ),
                          Text("Nutrition"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("12"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/insurance.png",
                            height: 80,
                            width: 80,
                          ),
                          Text("Crop Insurance"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("8"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/form.png",
                            height: 80,
                            width: 80,
                          ),
                          Text(
                            "Application of inputs",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                      "Learn more on this selected crops for you.  The crops are worth knowing them in details"),
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.3),
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 220, 220, 220),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text("7"),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/images/corn.png",
                            height: 80,
                            width: 80,
                          ),
                          Text(
                            "Sorghum",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                  // children: [
                  //   Container(
                  //     padding: EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(12),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           offset: Offset(0, 0.3),
                  //           spreadRadius: 3,
                  //           color: const Color.fromARGB(255, 220, 220, 220),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Spacer(),
                  //             Container(
                  //               height: 25,
                  //               width: 25,
                  //               decoration: BoxDecoration(
                  //                 color:
                  //                     const Color.fromARGB(255, 197, 197, 197),
                  //                 borderRadius: BorderRadius.circular(35),
                  //               ),
                  //               child: Center(
                  //                 child: Text("7"),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         Image.asset(
                  //           "assets/images/corn.png",
                  //           height: 80,
                  //           width: 80,
                  //         ),
                  //         Text(
                  //           "Sorghum",
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Container(
                  //     padding: EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(12),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           offset: Offset(0, 0.3),
                  //           spreadRadius: 3,
                  //           color: const Color.fromARGB(255, 220, 220, 220),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Spacer(),
                  //             Container(
                  //               height: 25,
                  //               width: 25,
                  //               decoration: BoxDecoration(
                  //                 color:
                  //                     const Color.fromARGB(255, 197, 197, 197),
                  //                 borderRadius: BorderRadius.circular(35),
                  //               ),
                  //               child: Center(
                  //                 child: Text("3"),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         Image.asset(
                  //           "assets/images/sunflower.png",
                  //           height: 80,
                  //           width: 80,
                  //         ),
                  //         Text(
                  //           "Sunflower",
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Container(
                  //     padding: EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(12),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           offset: Offset(0, 0.3),
                  //           spreadRadius: 3,
                  //           color: const Color.fromARGB(255, 220, 220, 220),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Spacer(),
                  //             Container(
                  //               height: 25,
                  //               width: 25,
                  //               decoration: BoxDecoration(
                  //                 color:
                  //                     const Color.fromARGB(255, 197, 197, 197),
                  //                 borderRadius: BorderRadius.circular(35),
                  //               ),
                  //               child: Center(
                  //                 child: Text("2"),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         Image.asset(
                  //           "assets/images/form.png",
                  //           height: 80,
                  //           width: 80,
                  //         ),
                  //         Text(
                  //           "Common beans",
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Container(
                  //     padding: EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(12),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           offset: Offset(0, 0.3),
                  //           spreadRadius: 3,
                  //           color: const Color.fromARGB(255, 220, 220, 220),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Spacer(),
                  //             Container(
                  //               height: 25,
                  //               width: 25,
                  //               decoration: BoxDecoration(
                  //                 color:
                  //                     const Color.fromARGB(255, 197, 197, 197),
                  //                 borderRadius: BorderRadius.circular(35),
                  //               ),
                  //               child: Center(
                  //                 child: Text("11"),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         Image.asset(
                  //           "assets/images/nutrition.png",
                  //           height: 80,
                  //           width: 80,
                  //         ),
                  //         Text(
                  //           "Vegetables",
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
