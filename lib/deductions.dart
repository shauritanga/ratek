import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  DocumentSnapshot? _currentStartDoc; // Start document for the current page
  bool _hasMore = true; // Whether there are more farmers to fetch
  bool _isLoading = false; // Loading state
  List<Farmer> _farmers = []; // Current page of farmers
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream; // Persistent stream

  @override
  void initState() {
    super.initState();
    _initializePage(); // Set up the initial page and stream
  }

  // Initialize the first page and set up the stream
  Future<void> _initializePage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final query = _firestore
          .collection('farmers')
          .orderBy('first_name')
          .limit(_pageSize);
      final snapshot = await query.get();
      if (kDebugMode) {
        print('Initial fetch: ${snapshot.docs.length} documents');
      }

      if (snapshot.docs.isNotEmpty) {
        _currentStartDoc = snapshot.docs.last;
        _hasMore = snapshot.docs.length == _pageSize;
        _farmers = snapshot.docs
            .map((doc) => Farmer.fromDocument(doc))
            .toList()
            .cast<Farmer>();
      } else {
        _farmers = [];
        _hasMore = false;
      }
      _stream = query.snapshots(); // Set the stream after initial fetch
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing page: $e');
      }
      _farmers = [];
      _hasMore = false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navigate to the next page
  Future<void> _nextPage() async {
    if (_hasMore && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        final query = _firestore
            .collection('farmers')
            .orderBy('first_name')
            .startAfterDocument(_currentStartDoc!)
            .limit(_pageSize);
        final snapshot = await query.get();
        if (kDebugMode) {
          print('Next page fetch: ${snapshot.docs.length} documents');
        }

        if (snapshot.docs.isNotEmpty) {
          _currentStartDoc = snapshot.docs.last;
          _hasMore = snapshot.docs.length == _pageSize;
          setState(() {
            _farmers = snapshot.docs
                .map((doc) => Farmer.fromDocument(doc))
                .toList()
                .cast<Farmer>();
          });
          _stream = query.snapshots(); // Update stream to new page
        } else {
          setState(() {
            _farmers = [];
            _hasMore = false;
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching next page: $e');
        }
        setState(() {
          _farmers = [];
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Navigate to the previous page
  Future<void> _previousPage() async {
    if (_currentStartDoc != null && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        final query = _firestore
            .collection('farmers')
            .orderBy('first_name')
            .endBeforeDocument(_currentStartDoc!)
            .limitToLast(_pageSize);
        final snapshot = await query.get();
        if (kDebugMode) {
          print('Previous page fetch: ${snapshot.docs.length} documents');
        }

        if (snapshot.docs.isNotEmpty) {
          _currentStartDoc = snapshot.docs.first;
          _hasMore = true; // Assume more until next fetch
          setState(() {
            _farmers = snapshot.docs
                .map((doc) => Farmer.fromDocument(doc))
                .toList()
                .cast<Farmer>();
          });
          _stream = query.snapshots(); // Update stream to new page
        } else {
          setState(() {
            _farmers = [];
            _hasMore = false;
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching previous page: $e');
        }
        setState(() {
          _farmers = [];
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
                    builder: (_) => DeductionScreen(),
                  ),
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
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (kDebugMode) {
                          print(
                              'Stream snapshot: ${snapshot.data?.docs.length} documents, _currentStartDoc: $_currentStartDoc, _hasMore: $_hasMore');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No farmers found'));
                        }

                        final docs = snapshot.data!.docs;
                        if (docs.length == _pageSize) {
                          _currentStartDoc = docs.last;
                          _hasMore = true;
                        } else {
                          _hasMore = false;
                        }
                        _farmers = docs
                            .map((doc) => Farmer.fromDocument(doc))
                            .toList()
                            .cast<Farmer>();

                        return SingleChildScrollView(
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
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _previousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _currentStartDoc == null ? Colors.grey : Colors.green,
                    ),
                    child: Text("Previous"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_hasMore ? Colors.grey : Colors.green,
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
