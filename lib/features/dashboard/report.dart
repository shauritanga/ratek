import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ratek/models/farmer.dart';
import 'package:ratek/models/sale.dart';
import 'package:ratek/features/dashboard/farmer_sales.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  List<Sale> sales = [];
  List<Farmer> farmers = [];
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final salesSnapshot =
          await FirebaseFirestore.instance.collection('sales').get();
      final farmersSnapshot =
          await FirebaseFirestore.instance.collection('farmers').get();

      setState(() {
        sales = salesSnapshot.docs
            .map((doc) => Sale.fromDocument(doc))
            .toList()
            .cast();
        farmers = farmersSnapshot.docs
            .map((doc) => Farmer.fromDocument(doc))
            .toList()
            .cast<Farmer>();

        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  int calculateAge(String dob) {
    final birthYear = int.parse(dob.split("/")[2]);
    final today = DateTime.now();
    var age = today.year - birthYear;
    return age;
  }

  Widget _buildSummaryCard(String title, String value,
      {IconData? icon, Color? color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color ?? Colors.blue,
              color?.withOpacity(0.7) ?? Colors.blue.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon ?? Icons.analytics,
                      color: Colors.white, size: 24.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartContainer({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              height: 250.h,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Key metrics
    final totalSales = sales.fold(0.0, (acc, sale) => acc + sale.amount);
    final totalWeight = sales.fold(0.0, (acc, sale) => acc + sale.weight);
    final totalGoodWeight = sales
        .where((sale) => sale.type == 'good')
        .fold(0.0, (acc, sale) => acc + sale.weight);
    final totalRejectWeight = sales
        .where((sale) => sale.type == 'reject')
        .fold(0.0, (acc, sale) => acc + sale.weight);

    // Top performers
    final topPerformers = farmers
        .map((farmer) => {
              'name':
                  '${farmer.firstName} ${farmer.lastName == "Unknown" ? farmer.middleName : farmer.lastName}',
              'sales': sales
                  .where((sale) => sale.farmer == farmer.id)
                  .fold(0.0, (acc, sale) => acc + sale.amount),
            })
        .toList(); // Get the initial list

    topPerformers.sort((a, b) => (b['sales'] as double)
        .compareTo(a['sales'] as double)); // Sort in place
    final result = topPerformers
        .take(10)
        .toList(); // Take top 10 // Convert the iterable back to a list

    // Chart data
    final salesByTypeData = [
      PieChartSectionData(
        value: sales.where((s) => s.type == 'good').length.toDouble(),
        title: 'Good',
        color: Colors.blue,
        radius: 50.w,
        titleStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
      PieChartSectionData(
        value: sales.where((s) => s.type == 'reject').length.toDouble(),
        title: 'Reject',
        color: Colors.red,
        radius: 50.w,
        titleStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    ];

    final salesByMonthData = List.generate(
        12,
        (i) => sales
            .where((s) => DateTime.parse(s.date).month == i + 1)
            .fold(0.0, (acc, s) => acc + s.amount));
    final genderData = [
      PieChartSectionData(
        value: farmers
            .where((f) => f.gender.toLowerCase() == 'me')
            .length
            .toDouble(),
        title: 'Wanaume',
        color: Colors.blue,
        radius: 60.w,
        titleStyle: TextStyle(color: Colors.white, fontSize: 8.sp),
      ),
      PieChartSectionData(
        value: farmers
            .where((f) => f.gender.toLowerCase() == 'ke')
            .length
            .toDouble(),
        title: 'Wanawake',
        color: Colors.pink,
        radius: 60.w,
        titleStyle: TextStyle(color: Colors.white, fontSize: 8.sp),
      ),
    ];

    final ageGroups = [
      {'range': 'Under 20', 'min': 0, 'max': 19},
      {'range': '20-29', 'min': 20, 'max': 29},
      {'range': '30-39', 'min': 30, 'max': 39},
      {'range': '40-49', 'min': 40, 'max': 49},
      {'range': '50+', 'min': 50, 'max': double.infinity},
    ];
    final ageData = ageGroups
        .map((g) => farmers
            .where((f) =>
                calculateAge(f.dob) >= (g['min'] as num) &&
                calculateAge(f.dob) <= (g['max'] as num))
            .length
            .toDouble())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        bottom: TabBar(
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.greenAccent,
          labelStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
            fontWeight: FontWeight.w700,
          ),
          controller: _tabController,
          tabs: [
            Tab(text: 'Kifupi'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    color: Colors.grey[50],
                    child: Padding(
                      padding: EdgeInsets.all(16.0.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.h,
                            crossAxisSpacing: 16.h,
                            childAspectRatio: 1.5,
                            children: [
                              _buildSummaryCard(
                                'Mauzo',
                                'TZS ${NumberFormat('#,###').format(totalSales)}',
                                icon: Icons.monetization_on,
                                color: Colors.green,
                              ),
                              _buildSummaryCard(
                                'Jumla ya uzito',
                                '${totalWeight.toStringAsFixed(2)} kg',
                                icon: Icons.scale,
                                color: Colors.blue,
                              ),
                              _buildSummaryCard(
                                'Uzito bora',
                                '${totalGoodWeight.toStringAsFixed(2)} kg',
                                icon: Icons.thumb_up,
                                color: Colors.teal,
                              ),
                              _buildSummaryCard(
                                'Uzito reject',
                                '${totalRejectWeight.toStringAsFixed(2)} kg',
                                icon: Icons.thumb_down,
                                color: Colors.red,
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          // Charts section
                          _buildChartContainer(
                            title: 'Mauzo kwa ubora',
                            child: PieChart(
                              PieChartData(
                                sections: salesByTypeData,
                                centerSpaceRadius: 40,
                                sectionsSpace: 2,
                                pieTouchData: PieTouchData(enabled: true),
                              ),
                            ),
                          ),

                          _buildChartContainer(
                            title: 'Mauzo kwa mwezi',
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                barGroups: salesByMonthData
                                    .asMap()
                                    .entries
                                    .map((e) => BarChartGroupData(
                                          x: e.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: e.value,
                                              color: Colors.teal,
                                              width: 16,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(6),
                                              ),
                                            )
                                          ],
                                        ))
                                    .toList(),
                                titlesData: FlTitlesData(
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) => Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(
                                          [
                                            'Jan',
                                            'Feb',
                                            'Mar',
                                            'Apr',
                                            'May',
                                            'Jun',
                                            'Jul',
                                            'Aug',
                                            'Sep',
                                            'Oct',
                                            'Nov',
                                            'Dec'
                                          ][value.toInt()],
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(show: false),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),

                          _buildChartContainer(
                            title: 'Wana Uwamambo kwa Jinsia',
                            child: PieChart(
                              PieChartData(
                                sections: genderData,
                                centerSpaceRadius: 40,
                                sectionsSpace: 2,
                                pieTouchData: PieTouchData(enabled: true),
                              ),
                            ),
                          ),

                          _buildChartContainer(
                            title: 'Wana Uwamambo kwa Umri',
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                barGroups: ageData
                                    .asMap()
                                    .entries
                                    .map((e) => BarChartGroupData(
                                          x: e.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: e.value,
                                              color: Colors.teal,
                                              width: 16,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(6),
                                              ),
                                            )
                                          ],
                                        ))
                                    .toList(),
                                titlesData: FlTitlesData(
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) => Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(
                                          ageGroups[value.toInt()]['range']
                                              as String,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(show: false),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),

                          // Top Performers Table
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Text(
                                    'Wakulima Kumi(10) wakubwa',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Divider(height: 1),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowHeight: 50.h,
                                    dataRowHeight: 56.h,
                                    headingRowColor: MaterialStateProperty.all(
                                      Colors.grey[100],
                                    ),
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Jina la Mkulima',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Jumla ya mauzo (TZS)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: result
                                        .map((p) => DataRow(
                                              cells: [
                                                DataCell(Text(
                                                  p['name'] as String,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14.sp,
                                                  ),
                                                )),
                                                DataCell(Text(
                                                  NumberFormat('#,###')
                                                      .format(p['sales']),
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14.sp,
                                                  ),
                                                )),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Recent Sales Table
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Text(
                                    'Mauzo yaliyopita',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Divider(height: 1),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowHeight: 50.h,
                                    dataRowHeight: 56.h,
                                    headingRowColor: MaterialStateProperty.all(
                                      Colors.grey[100],
                                    ),
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Jina la Mkulima',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Tarehe ya mauzo',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Aina ya mauzo',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Kiasi (kg)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Jumla ya mauzo (TZS)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: (() {
                                      final sortedSales = sales.toList()
                                        ..sort((a, b) => DateTime.parse(b.date)
                                            .compareTo(DateTime.parse(a.date)));
                                      return sortedSales.take(5);
                                    })()
                                        .map((sale) {
                                      final farmer = farmers.firstWhere(
                                          (f) => f.id == sale.farmer,
                                          orElse: () => Farmer(
                                              id: '',
                                              firstName: 'Unknown',
                                              middleName: '',
                                              lastName: '',
                                              gender: '',
                                              dob: "",
                                              phone: '',
                                              nida: '',
                                              zone: '',
                                              ward: '',
                                              district: '',
                                              village: '',
                                              accountNumber: '',
                                              bankName: '',
                                              farmSize: 0,
                                              numberOfTrees: 0,
                                              numberOfTreesWithFruits: 0));
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(
                                            "${farmer.firstName} ${farmer.lastName == "Unknown" ? farmer.middleName : farmer.lastName}",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp,
                                            ),
                                          )),
                                          DataCell(Text(
                                            DateFormat.yMMMMd().format(
                                                DateTime.parse(sale.date)),
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp,
                                            ),
                                          )),
                                          DataCell(Text(
                                            sale.type,
                                            style: TextStyle(
                                              color: sale.type == 'good'
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                            ),
                                          )),
                                          DataCell(Text(
                                            sale.weight.toString(),
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp,
                                            ),
                                          )),
                                          DataCell(Text(
                                            NumberFormat('#,###')
                                                .format(sale.amount),
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.sp,
                                            ),
                                          )),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          FarmerSales(),
        ],
      ),
    );
  }
}
