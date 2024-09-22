import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

Future<List<Map<String, dynamic>>> readExcelFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/uwamambo.xlsx';
  final file = File(path);

  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  List<Map<String, dynamic>> data = [];

  for (var table in excel.tables.keys) {
    print(table); //sheet Name
    print(excel.tables[table]?.maxColumns);
    print(excel.tables[table]?.maxRows);

    for (var row in excel.tables[table]!.rows) {
      // Assuming the first row contains headers
      if (row.isNotEmpty) {
        data.add({
          'first_name': row[0]?.toString() ?? '',
          'middle_name': row[1]?.toString() ?? '',
          'last_name': row[2]?.toString() ?? '',
          'gender': row[3]?.toString() ?? '',
          'phone': row[4]?.toString() ?? '',
          'nida': row[5]?.toString() ?? '',
          'dob': row[6]?.toString() ?? '',
          'zone': row[7]?.toString() ?? '',
          'ward': row[8]?.toString() ?? '',
          'village': row[9]?.toString() ?? '',
          'bank_name': row[10]?.toString() ?? '',
          'account_number': row[11]?.toString() ?? '',
          'farm_size': row[12]?.toString() ?? '',
          'number_of_trees': row[13]?.toString() ?? '',
          'number_of_trees_with_fruits': row[14]?.toString() ?? '',
        });
      }
    }
  }

  return data;
}
