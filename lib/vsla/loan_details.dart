import 'package:flutter/material.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({super.key});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 149, 108),
        foregroundColor: Colors.white,
        title: Text("Loan Details"),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Requested Amount"),
                    Text("1,500,000"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Approved Amount"),
                    Text("1,500,000"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Purpose"),
                    Text("Agriculture/Farming"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Number of installments"),
                    Text("9"),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Ouststanding Balance"),
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "OUTSTANDING BALANCE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text("TZS 1,079,656.24"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "INTEREST REMAINING",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text("TZS 216,631.45"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Payment Schedule"),
          ),
          SizedBox(height: 8),
          DataTable(
            decoration: BoxDecoration(color: Colors.white),
            columnSpacing: 15,
            columns: [
              DataColumn(
                label: Text("Date"),
              ),
              DataColumn(
                label: Text("Principal"),
              ),
              DataColumn(
                label: Text("Interest"),
              ),
              DataColumn(
                label: Text("Balance"),
              ),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    Text("08-11-2024"),
                  ),
                  DataCell(
                    Text("131,965.73"),
                  ),
                  DataCell(
                    Text("84,082.19"),
                  ),
                  DataCell(
                    Text("1,368,034.27"),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(
                    Text("10-12-2024"),
                  ),
                  DataCell(
                    Text("136,889.33"),
                  ),
                  DataCell(
                    Text("79,158.59"),
                  ),
                  DataCell(
                    Text("1,231,144.94"),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(
                    Text("08-01-2025"),
                  ),
                  DataCell(
                    Text("151,488.70"),
                  ),
                  DataCell(
                    Text("64,559.22"),
                  ),
                  DataCell(
                    Text("1,079,656.24"),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          child: TextButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Color.fromARGB(255, 64, 149, 108)),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            child: Text("Make Loan Payment"),
          ),
        ),
      ),
    );
  }
}
