import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ratek/deduction.dart';
import 'package:ratek/models/farmer.dart';

class FarmerFeesTableScreen extends StatefulWidget {
  const FarmerFeesTableScreen({super.key});

  @override
  State createState() => _FarmerFeesTableScreenState();
}

class _FarmerFeesTableScreenState extends State<FarmerFeesTableScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageSize = 10; // Number of farmers per page
  DocumentSnapshot? _lastDocument; // Track the last document for pagination
  List<Farmer> _farmers = []; // Current page of farmers
  bool _hasMore = true; // Whether there are more farmers to fetch
  bool _isLoading = false; // Loading state for pagination

  @override
  void initState() {
    super.initState();
    _fetchFarmers(); // Fetch the first page on init
  }

  Future<void> _fetchFarmers({bool isNext = true}) async {
    if (_isLoading) return; // Prevent multiple simultaneous fetches

    setState(() {
      _isLoading = true;
    });

    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('farmers')
          .orderBy('first_name') // Order for consistent pagination
          .limit(_pageSize);

      if (isNext && _lastDocument != null) {
        // Fetch the next page
        query = query.startAfterDocument(_lastDocument!);
      } else if (!isNext && _lastDocument != null) {
        // Fetch the previous page
        query = _firestore
            .collection('farmers')
            .orderBy('first_name')
            .endBeforeDocument(_lastDocument!)
            .limitToLast(_pageSize);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _farmers = [];
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      _lastDocument = snapshot.docs.last;
      _hasMore = snapshot.docs.length == _pageSize;

      // Map the snapshot to Farmer objects
      setState(() {
        _farmers = snapshot.docs
            .map((doc) => Farmer.fromDocument(doc))
            .toList()
            .cast<Farmer>();
      });
    } catch (e) {
      print('Error fetching farmers: $e');
      setState(() {
        _farmers = [];
        _hasMore = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fees and Loans"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => DeductionScreen()),
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _farmers.isEmpty
                      ? Center(child: Text('No farmers found'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text("Jina la Mkulima")),
                              DataColumn(label: Text("Kiingilio (TZS)")),
                              DataColumn(label: Text("Ada (TZS)")),
                              DataColumn(label: Text("Mkopo (TZS)")),
                            ],
                            rows: _farmers.map((farmer) {
                              return DataRow(cells: [
                                DataCell(Text(farmer.formattedName)),
                                DataCell(Text(
                                    NumberFormat().format(farmer.entryFee))),
                                DataCell(Text(NumberFormat()
                                    .format(farmer.subscriptionFee))),
                                DataCell(
                                    Text(NumberFormat().format(farmer.loan))),
                              ]);
                            }).toList(),
                          ),
                        ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _lastDocument != null && !_isLoading
                        ? () => _fetchFarmers(isNext: false)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text("Previous"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hasMore && !_isLoading
                        ? () => _fetchFarmers(isNext: true)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text("Next"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
