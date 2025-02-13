import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<Map<String, dynamic>> transactions = [
    {
      "name": "Athanas Shauritanga",
      "transaction": "Expenses",
      "amount": "45,000",
      "date": "11-12-2024",
    },
    {
      "name": "Joseph kibelezo",
      "transaction": "Fees",
      "amount": "25,000",
      "date": "09-12-2024",
    },
    {
      "name": "James Mjelansimi",
      "transaction": "fines",
      "amount": "75,000",
      "date": "11-09-2024",
    },
    {
      "name": "Jamila Zuberi",
      "transaction": "Welfare collection",
      "amount": "45,00",
      "date": "21-07-2024",
    },
    {
      "name": "Shabani Yata",
      "transaction": "Expenses",
      "amount": "4,000",
      "date": "10-05-2024",
    },
    {
      "name": "Alex Milambo",
      "transaction": "Welfare collection",
      "amount": "5,000",
      "date": "01-04-2024",
    },
  ];

  String selectedType = "All Transactions";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.only(left: 16, right: 12),
            color: const Color.fromARGB(255, 64, 149, 108),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transactions",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Select a transaction type to filter"),
          ),
          DropdownButtonFormField(
            value: selectedType,
            items: [
              "All Transactions",
              "Savings Deposit",
              "Expenses",
              "Welfare Collection",
              "Incomes",
              "Fees",
              "Fines",
            ]
                .map<DropdownMenuItem>(
                  (entry) => DropdownMenuItem(
                    value: entry,
                    child: Text(entry),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedType = value;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          Divider(),
          Expanded(
              child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0.5),
                      spreadRadius: 0.2,
                      color: Colors.grey,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transaction['name']),
                        Text(transaction['transaction']),
                        Text("Amount ${transaction['amount']}"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(transaction['date']),
                        Text(
                          "Reverse",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
