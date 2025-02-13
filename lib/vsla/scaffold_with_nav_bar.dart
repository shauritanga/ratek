import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ratek/vsla/dashboard.dart';
import 'package:ratek/vsla/members.dart';
import 'package:ratek/vsla/more_page.dart';
import 'package:ratek/vsla/transaction.dart';
import 'package:ratek/vsla/wallet.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int currentIndex = 0;
  @override
  Widget build(Object context) {
    return Scaffold(
      body: [
        Dashboard(),
        MembersScreen(),
        TransactionScreen(),
        WalletScreen(),
        MoreScreen(),
      ][currentIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedDashboardSquare01,
            ),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedUserGroup,
            ),
            label: "Members",
          ),
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedBank,
              color: Colors.black,
              size: 24.0,
            ),
            label: "Transaction",
          ),
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedWallet03,
              color: Colors.black,
              size: 24.0,
            ),
            label: "Wallet",
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: "More",
          ),
        ],
      ),
    );
  }
}
