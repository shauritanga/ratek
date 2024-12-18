import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ratek/models/sale.dart';
import 'package:ratek/providers/sales_provider.dart';
import 'package:ratek/widgets/sale_enrty_dialog.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final NumberFormat _formatter =
      NumberFormat.currency(decimalDigits: 2, name: " ");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final salesAsync = ref.watch(salesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("Mauzo"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: salesAsync.when(
          data: (data) {
            if (data.isEmpty) {
              return Text("No sales yet!");
            }

            final sales = data;

            return ListView.builder(
              itemCount: sales.length,
              itemBuilder: (context, index) {
                Sale sale = sales[index];
                return SaleSummary(
                  size: size,
                  sale: sale,
                  formatter: _formatter,
                );
              },
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return const SaleEntryDialog();
              },
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class SaleSummary extends StatelessWidget {
  const SaleSummary({
    super.key,
    required this.size,
    required this.sale,
    required NumberFormat formatter,
  }) : formatter = formatter;

  final Size size;
  final Sale sale;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        //height: size.height * 0.27,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            left: BorderSide(
              color: Color.fromARGB(255, 36, 111, 34),
              width: 5,
            ),
          ),
          borderRadius: BorderRadius.circular(7),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0.5, 1),
              blurRadius: 0.5,
              spreadRadius: 1,
              color: Colors.grey,
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              sale.farmer,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mchanganuo",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Expanded(child: Text("Jumla ya kilo")),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text("${sale.weight} Kg"),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.3,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    const Expanded(child: Text("Jumla ya mauzo")),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text("${formatter.format((sale.amount))} Tsh/="),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.3,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    const Expanded(child: Text("Malipo ya Mkulima")),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${formatter.format(sale.receive)} Tsh/=",
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.3,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text("Malipo ya UWAMAMBO"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${formatter.format((sale.amount - sale.receive))} Tsh/=",
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
