import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/models/sale.dart';
import 'package:ratek/providers/farmer_provider.dart';

// Provider for selected year
final selectedYearProvider = StateProvider<int>((ref) {
  return 0; // 0 means all years
});

// Provider for selected period type (Year, Quarter, Month)
final periodTypeProvider = StateProvider<String>((ref) {
  return 'Year';
});

// Provider for selected period (Quarter number 1-4 or Month number 1-12)
final selectedPeriodProvider = StateProvider<int>((ref) {
  return 0; // 0 means all periods
});

// Provider for comparison mode
final comparisonModeProvider = StateProvider<bool>((ref) {
  return false;
});

// Provider for selected zone
final selectedZoneProvider = StateProvider<String>((ref) {
  return 'All Zones';
});

// Provider for available zones
final zonesProvider = StreamProvider<List<String>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('farmers').snapshots().map((snapshot) {
    final zones = snapshot.docs
        .map((doc) => doc.data()['zone'] as String)
        .where((zone) => zone.isNotEmpty)
        .toSet()
        .toList();
    zones.sort();
    return ['All Zones', ...zones];
  });
});

// Provider for aggregated farmer sales data
final farmerSalesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final selectedYear = ref.watch(selectedYearProvider);
  final periodType = ref.watch(periodTypeProvider);
  final selectedPeriod = ref.watch(selectedPeriodProvider);
  final selectedZone = ref.watch(selectedZoneProvider);

  // Create a stream that combines both farmers and sales data
  return firestore
      .collection('farmers')
      .snapshots()
      .asyncMap((farmersSnapshot) async {
    final farmerZones = Map.fromEntries(farmersSnapshot.docs
        .map((doc) => MapEntry(doc.id, doc.data()['zone'] as String)));

    final salesSnapshot = await firestore.collection('sales').get();
    final sales =
        salesSnapshot.docs.map((doc) => Sale.fromDocument(doc)).toList();

    // Filter sales by selected year, period, and zone
    final filteredSales = sales.where((sale) {
      final saleDate = DateTime.parse(sale.date);

      // Check zone filter if not "All Zones"
      if (selectedZone != 'All Zones') {
        final farmerZone = farmerZones[sale.farmer] ?? '';
        if (farmerZone != selectedZone) {
          return false;
        }
      }

      // Check year filter if not "All Years"
      if (selectedYear > 0 && saleDate.year != selectedYear) {
        return false;
      }

      // Check period filter
      if (periodType == 'Quarter' && selectedPeriod > 0) {
        final quarter = ((saleDate.month - 1) ~/ 3) + 1;
        return quarter == selectedPeriod;
      } else if (periodType == 'Month' && selectedPeriod > 0) {
        return saleDate.month == selectedPeriod;
      }

      return true;
    }).toList();

    final Map<String, Map<String, dynamic>> farmerSales = {};

    for (var sale in filteredSales) {
      if (!farmerSales.containsKey(sale.farmer)) {
        farmerSales[sale.farmer] = {
          'totalWeight': 0.0,
          'totalAmount': 0.0,
          'salesCount': 0,
          'averageAmount': 0.0,
          'monthlySales': List.filled(12, 0.0),
        };
      }

      farmerSales[sale.farmer]!['totalWeight'] += sale.weight;
      farmerSales[sale.farmer]!['totalAmount'] += sale.amount;
      farmerSales[sale.farmer]!['salesCount']++;

      // Track monthly sales for charts
      final saleDate = DateTime.parse(sale.date);
      farmerSales[sale.farmer]!['monthlySales'][saleDate.month - 1] +=
          sale.amount;
    }

    // Calculate averages
    for (var entry in farmerSales.values) {
      entry['averageAmount'] = entry['totalAmount'] / entry['salesCount'];
    }

    return farmerSales.entries.map((entry) {
      return {
        'farmerId': entry.key,
        'totalWeight': entry.value['totalWeight'],
        'totalAmount': entry.value['totalAmount'],
        'salesCount': entry.value['salesCount'],
        'averageAmount': entry.value['averageAmount'],
        'monthlySales': entry.value['monthlySales'],
      };
    }).toList();
  });
});

class FarmerSales extends ConsumerWidget {
  const FarmerSales({super.key});

  Future<void> _exportToPDF(
    BuildContext context,
    List<Map<String, dynamic>> salesData,
    List<Farmer> farmers,
    String periodType,
    int selectedPeriod,
    int selectedYear,
    NumberFormat numberFormat,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Farmer Sales Report - ${selectedYear > 0 ? selectedYear.toString() : "All Years"}',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: [
              'Farmer Name',
              'Total Weight (kg)',
              'Total Amount (TZS)',
              'Sales Count',
              'Average Sale (TZS)',
            ],
            data: salesData.map((data) {
              final farmer = farmers.firstWhere(
                (f) => f.id == data['farmerId'],
                orElse: () => Farmer(
                  id: "",
                  firstName: "Unknown",
                  middleName: "",
                  lastName: "Farmer",
                  phone: "",
                  gender: "",
                  nida: "",
                  dob: "",
                  zone: "",
                  ward: "",
                  district: "",
                  village: "",
                  accountNumber: "",
                  bankName: "",
                  farmSize: 0,
                  numberOfTrees: 0,
                  numberOfTreesWithFruits: 0,
                ),
              );

              return [
                farmer.formattedName,
                numberFormat.format(data['totalWeight']),
                numberFormat.format(data['totalAmount']),
                data['salesCount'].toString(),
                numberFormat.format(data['averageAmount']),
              ];
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'farmer_sales_${selectedYear}_report.pdf',
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<Map<String, dynamic>> salesData,
    List<Farmer> farmers,
    NumberFormat numberFormat,
  ) {
    // Define a list of distinct colors
    final List<Color> barColors = [
      Theme.of(context).primaryColor,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.blue,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.pink,
    ];

    return Container(
      height: 200.h,
      padding: EdgeInsets.all(16.r),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: salesData.fold(
            0.0,
            (max, data) => math.max(
                max!, (data['totalAmount'] as double?)?.toDouble() ?? 0.0),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                'Farmers',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= salesData.length) return const Text('');
                  final farmer = farmers.firstWhere(
                    (f) => f.id == salesData[value.toInt()]['farmerId'],
                    orElse: () => Farmer(
                      id: "",
                      firstName: "Unknown",
                      middleName: "",
                      lastName: "",
                      phone: "",
                      gender: "",
                      nida: "",
                      dob: "",
                      zone: "",
                      ward: "",
                      district: "",
                      village: "",
                      accountNumber: "",
                      bankName: "",
                      farmSize: 0,
                      numberOfTrees: 0,
                      numberOfTreesWithFruits: 0,
                    ),
                  );
                  return RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      farmer.firstName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                'Amount (TZS)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  return Text(
                    numberFormat.format(value),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10.sp,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: salesData.asMap().entries.map((entry) {
            final amount = (entry.value['totalAmount'] as num).toDouble();
            // Use colors cyclically
            final colorIndex = entry.key % barColors.length;
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: amount,
                  color: barColors[colorIndex],
                  width: 7,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmersAsync = ref.watch(farmersStreamProvider);
    final farmerSalesAsync = ref.watch(farmerSalesProvider);
    final selectedYear = ref.watch(selectedYearProvider);
    final periodType = ref.watch(periodTypeProvider);
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final comparisonMode = ref.watch(comparisonModeProvider);
    final selectedZone = ref.watch(selectedZoneProvider);
    final zonesAsync = ref.watch(zonesProvider);
    final numberFormat = NumberFormat("#,##0.00", "en_US");

    final currentYear = DateTime.now().year;
    final years = [
      const DropdownMenuItem<int>(
        value: 0,
        child: Text('All Years'),
      ),
      ...List.generate(
        currentYear - 2019,
        (index) => DropdownMenuItem<int>(
          value: currentYear - index,
          child: Text((currentYear - index).toString()),
        ),
      ),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Farmer Sales Summary',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () => farmersAsync.whenData((farmers) {
                    farmerSalesAsync.whenData((salesData) {
                      _exportToPDF(
                        context,
                        salesData,
                        farmers,
                        periodType,
                        selectedPeriod,
                        selectedYear,
                        numberFormat,
                      );
                    });
                  }),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Filters Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Period Type Selector
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: periodType,
                        icon: Icon(
                          Icons.access_time,
                          color: Theme.of(context).primaryColor,
                        ),
                        items: ['Year', 'Quarter', 'Month'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value != null) {
                            ref.read(periodTypeProvider.notifier).state = value;
                            ref.read(selectedPeriodProvider.notifier).state = 0;
                          }
                        },
                      ),
                    ),
                  ),
                  // Period Selector (Quarter or Month)
                  if (periodType != 'Year')
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedPeriod,
                          icon: Icon(
                            Icons.calendar_view_month,
                            color: Theme.of(context).primaryColor,
                          ),
                          items: [
                            const DropdownMenuItem<int>(
                              value: 0,
                              child: Text('All'),
                            ),
                            ...List.generate(
                              periodType == 'Quarter' ? 4 : 12,
                              (index) => DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text(
                                  periodType == 'Quarter'
                                      ? 'Q${index + 1}'
                                      : DateFormat('MMMM').format(
                                          DateTime(2024, index + 1),
                                        ),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (int? value) {
                            if (value != null) {
                              ref.read(selectedPeriodProvider.notifier).state =
                                  value;
                            }
                          },
                        ),
                      ),
                    ),
                  // Year Selector
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedYear,
                        icon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                        ),
                        items: years,
                        onChanged: (int? value) {
                          if (value != null) {
                            ref.read(selectedYearProvider.notifier).state =
                                value;
                          }
                        },
                      ),
                    ),
                  ),
                  // Zone Selector
                  zonesAsync.when(
                    data: (zones) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedZone,
                          icon: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                          ),
                          items: zones.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              ref.read(selectedZoneProvider.notifier).state =
                                  value;
                            }
                          },
                        ),
                      ),
                    ),
                    error: (error, stackTrace) => const SizedBox(),
                    loading: () => const CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Content
            farmersAsync.when(
              data: (farmers) {
                return farmerSalesAsync.when(
                  data: (salesData) {
                    if (salesData.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 40.h),
                            Icon(
                              Icons.bar_chart,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No sales data found for the selected period',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Sort salesData by farmer name
                    final sortedSalesData = salesData.map((data) {
                      final farmer = farmers.firstWhere(
                        (f) => f.id == data['farmerId'],
                        orElse: () => Farmer(
                          id: "",
                          firstName: "Unknown",
                          middleName: "",
                          lastName: "Farmer",
                          phone: "",
                          gender: "",
                          nida: "",
                          dob: "",
                          zone: "",
                          ward: "",
                          district: "",
                          village: "",
                          accountNumber: "",
                          bankName: "",
                          farmSize: 0,
                          numberOfTrees: 0,
                          numberOfTreesWithFruits: 0,
                        ),
                      );
                      return {...data, 'farmerName': farmer.formattedName};
                    }).toList()
                      ..sort((a, b) => (a['farmerName'] as String)
                          .compareTo(b['farmerName'] as String));

                    // Calculate summary statistics using sorted data
                    final totalSales = sortedSalesData.fold<double>(0,
                        (sum, item) => sum + (item['totalAmount'] as double));
                    final totalWeight = sortedSalesData.fold<double>(0,
                        (sum, item) => sum + (item['totalWeight'] as double));
                    final averageSale = totalSales / sortedSalesData.length;

                    return Column(
                      children: [
                        // Summary Cards
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: [
                            _buildSummaryCard(
                              context,
                              'Total Sales',
                              'TZS ${numberFormat.format(totalSales)}',
                              Icons.monetization_on,
                            ),
                            _buildSummaryCard(
                              context,
                              'Total Weight',
                              '${numberFormat.format(totalWeight)} kg',
                              Icons.scale,
                            ),
                            _buildSummaryCard(
                              context,
                              'Average Sale',
                              'TZS ${numberFormat.format(averageSale)}',
                              Icons.analytics,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        // Sales Chart
                        Text(
                          'Sales Distribution',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildChart(
                            context, sortedSalesData, farmers, numberFormat),
                        SizedBox(height: 20.h),
                        // Data Table
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              const DataColumn(
                                label: Text(
                                  'S/N',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Farmer Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Total Weight (kg)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Total Amount (TZS)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Sales Count',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Average Sale (TZS)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: sortedSalesData.asMap().entries.map((entry) {
                              final index = entry.key;
                              final data = entry.value;

                              return DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(data['farmerName'] as String)),
                                  DataCell(Text(
                                    numberFormat.format(data['totalWeight']),
                                  )),
                                  DataCell(Text(
                                    numberFormat.format(data['totalAmount']),
                                  )),
                                  DataCell(Text(
                                    data['salesCount'].toString(),
                                  )),
                                  DataCell(Text(
                                    numberFormat.format(data['averageAmount']),
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => Text('Error: $error'),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
