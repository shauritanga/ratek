import 'package:ratek/db/local.dart';
import 'package:ratek/utils/execel.dart';

Future<void> importExcelToDatabase() async {
  List<Map<String, dynamic>> farmers = await readExcelFile();

  for (var farmer in farmers) {
    await LocalDatabase.insertFarmer(farmer);
  }
  print('Data imported successfully');
}
