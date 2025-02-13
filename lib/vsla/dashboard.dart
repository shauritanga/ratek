import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ratek/vsla/loan_application.dart';
import 'package:ratek/vsla/loan_details.dart';

enum DropItem { loanApplication, loanDetails }

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DropItem? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      body: Column(
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.only(left: 16, right: 8),
            color: const Color.fromARGB(255, 64, 149, 108),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hansamba Group",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedNotification01,
                        color: Colors.white,
                      ),
                      SizedBox(width: 24),
                      PopupMenuButton(
                        initialValue: selectedItem,
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (DropItem value) {
                          setState(() {
                            selectedItem = value;
                          });
                        },
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) => <PopupMenuEntry<DropItem>>[
                          PopupMenuItem<DropItem>(
                            value: DropItem.loanApplication,
                            child: Text('Loan Application'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplicationScreen(),
                                ),
                              );
                            },
                          ),
                          PopupMenuItem<DropItem>(
                            value: DropItem.loanDetails,
                            child: Text('Loan Details'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoanDetailsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: const Color.fromARGB(205, 64, 149, 108),
                height: 180,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dan Thomas(Secretary)",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.5),
                            spreadRadius: 0.2,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Group Summary"),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.5,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                          "assets/images/bank_note.svg"),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "705, 5600",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text("Group Savings"),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.5,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 35,
                                        child: Image.asset(
                                            "assets/images/hand-money.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "201, 5600",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text("Outstanding Loans"),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.5),
                            spreadRadius: 0.2,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Group Loans"),
                          SizedBox(height: 8),
                          ListTile(
                            leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Center(
                                child: Icon(
                                  HugeIcons.strokeRoundedFiles01,
                                ),
                              ),
                            ),
                            title: Text("Pending Approvals"),
                            trailing: Text("5"),
                          ),
                          Divider(
                            thickness: 0.5,
                          ),
                          ListTile(
                            leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Center(
                                child: Icon(
                                  HugeIcons.strokeRoundedBitcoin03,
                                ),
                              ),
                            ),
                            title: Text("Pending Disbursements"),
                            trailing: Text("18"),
                          ),
                          Divider(
                            thickness: 0.5,
                          ),
                          ListTile(
                            leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Center(
                                child: Icon(
                                  HugeIcons.strokeRoundedCoins01,
                                ),
                              ),
                            ),
                            title: Text("Outstanding Loans"),
                            trailing: Text("20"),
                          ),
                          Divider(
                            thickness: 0.5,
                          ),
                          ListTile(
                            leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Center(
                                child: Icon(
                                  HugeIcons.strokeRoundedTick01,
                                ),
                              ),
                            ),
                            title: Text("Cleared"),
                            trailing: Text("57"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
