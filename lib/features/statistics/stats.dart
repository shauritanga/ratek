import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/models/production_data.dart';
import 'package:ratek/models/sale.dart';

class ProductionDataScreen extends StatefulWidget {
  const ProductionDataScreen({super.key});

  @override
  State createState() => _ProductionDataScreenState();
}

class _ProductionDataScreenState extends State<ProductionDataScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedYear = "2023/2024";
  bool showTable = false;
  final List<String> years = ["2023/2024", "2022/2023", "2021/2022"];

  @override
  void initState() {
    super.initState();
    _fetchAggregatedData();
  }

  Future<List<ProductionData>> _fetchAggregatedData() async {
    // Fetch all farmers
    final farmersSnapshot = await _firestore.collection('farmers').get();
    final farmersMap = {
      for (var doc in farmersSnapshot.docs) doc.id: Farmer.fromDocument(doc)
    };

    // Fetch all sales (add season filter if implemented)
    final salesSnapshot = await _firestore.collection('sales').get();
    final salesList =
        salesSnapshot.docs.map((doc) => Sale.fromDocument(doc)).toList();

    // Aggregate sales by zone
    final zoneDataMap = <String, Map<String, dynamic>>{};
    double totalKilograms = 0;

    for (var sale in salesList) {
      final farmer = farmersMap[sale.farmer];
      if (farmer != null) {
        final zone = farmer.zone;
        if (!zoneDataMap.containsKey(zone)) {
          zoneDataMap[zone] = {
            'district': farmer.ward,
            'kilograms': 0.0,
            'metricTons': 0.0,
          };
        }
        zoneDataMap[zone]!['kilograms'] =
            (zoneDataMap[zone]!['kilograms'] as double) + sale.weight;
        totalKilograms += sale.weight;
      }
    }

    // Convert to ProductionData list with calculated metrics
    return zoneDataMap.entries.map((entry) {
      final zone = entry.key;
      final data = entry.value;
      final kilograms = data['kilograms'];
      final metricTons = NumberFormat.decimalPatternDigits(decimalDigits: 1)
          .format((kilograms / 1000)); // Round down to match original data
      final percentage = NumberFormat.decimalPatternDigits(decimalDigits: 1)
          .format((kilograms / totalKilograms) * 100);
      return ProductionData(
        zone: zone,
        district: data['district'],
        kilograms: kilograms,
        metricTons: double.parse(metricTons),
        percentage: double.parse(percentage),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Takwimu"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Year Selection Dropdown
            DropdownButton<String>(
              value: selectedYear,
              onChanged: (String? newValue) {
                setState(() {
                  selectedYear = newValue!;
                  // In a real app, fetch data for the selected year here
                });
              },
              items: years.map<DropdownMenuItem<String>>((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text("Msimu $year"),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // Toggle between Chart and Table
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showTable = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showTable ? Colors.green : Colors.grey,
                    ),
                    child: const Text("Chart"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showTable = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showTable ? Colors.green : Colors.grey,
                    ),
                    child: Text("Jedwali"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: FutureBuilder<List<ProductionData>>(
                future: _fetchAggregatedData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  final data = snapshot.data!;
                  return showTable
                      ? _buildAggregatedTable(data)
                      : _buildBarChart(data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pie Chart Widget
  Widget _buildPieChart(List<ProductionData> data) {
    return PieChart(
      PieChartData(
        sections: data.asMap().entries.map((entry) {
          final data = entry.value;
          return PieChartSectionData(
            color: Colors.primaries[entry.key % Colors.primaries.length],
            value: data.percentage,
            title: "${data.zone}\n${data.percentage}%",
            radius: 100,
            titleStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildBarChart(List<ProductionData> data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100, // Maximum value for percentage (adjust based on your data)
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                "${data[groupIndex].zone}\n${rod.toY}%",
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return SideTitleWidget(
                    angle: 45 *
                        3.14159 /
                        180, // Rotate labels for better readability
                    meta: meta,
                    child: Text(
                      data[index].zone,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Text("");
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  "${value.toInt()}%",
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.percentage,
                color: Colors.primaries[index % Colors.primaries.length],
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Data Table Widget
  Widget _buildAggregatedTable(List<ProductionData> data) {
    // Calculate totals
    final totalKilograms =
        data.map((data) => data.kilograms).reduce((a, b) => a + b);
    final totalMetricTons =
        data.map((data) => data.metricTons).reduce((a, b) => a + b);
    final totalPercentage =
        data.map((data) => data.percentage).reduce((a, b) => a + b);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text("Kanda")),
          DataColumn(label: Text("Wilaya")),
          DataColumn(label: Text("Kiasi (Kgs)")),
          DataColumn(label: Text("Kiasi (Tani)")),
          DataColumn(label: Text("% Mchango")),
        ],
        rows: [
          ...data.map((data) {
            return DataRow(cells: [
              DataCell(Text(data.zone)),
              DataCell(Text(data.district)),
              DataCell(Text(NumberFormat.decimalPatternDigits(decimalDigits: 1)
                  .format(data.kilograms))),
              DataCell(Text(NumberFormat.decimalPatternDigits(decimalDigits: 1)
                  .format(data.metricTons))),
              DataCell(Text("${data.percentage}%")),
            ]);
          }),
          // Total Row
          DataRow(
            cells: [
              DataCell(
                  Text("Jumla", style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text("")),
              DataCell(Text(
                  NumberFormat.decimalPatternDigits(decimalDigits: 1)
                      .format(totalKilograms),
                  style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(
                  NumberFormat.decimalPatternDigits(decimalDigits: 1)
                      .format(totalMetricTons),
                  style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(
                  "${NumberFormat.decimalPatternDigits(decimalDigits: 1).format(totalPercentage)}%",
                  style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),
    );
  }
}
