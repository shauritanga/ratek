import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'agrip.db'),
      onCreate: (db, version) async {
        // Create each table separately
        await db.execute('''
          CREATE TABLE farmers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            synced INTEGER,
            first_name TEXT,
            middle_name TEXT,
            last_name TEXT,
            age INTEGER,
            phone TEXT,
            gender TEXT,
            nida TEXT,
            dob TEXT,
            zone TEXT,
            ward TEXT,
            village TEXT,
            account_number TEXT,
            bank_name TEXT,
            farm_size INTEGER,
            number_of_trees INTEGER,
            number_of_trees_with_fruits INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            synced INTEGER,
            date TEXT, 
            farmer TEXT,
            amount REAL,
            corperate_id TEXT,
            weight INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE groups (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            synced INTEGER,
            corperate_id TEXT,
            name TEXT,
            district TEXT,
            region TEXT,
            total_member TEXT,
            ward TEXT,
            village TEXT,
            zone TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE farms (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            synced INTEGER,
            name TEXT,
            coordinates TEXT,
            product TEXT,
            region TEXT,
            village TEXT,
            ward TEXT,
            farmer TEXT,
            farm_ownership TEXT,
            district TEXT,
            area INTEGER
          );
        ''');
      },
      version: 1,
    );

    return _database!;
  }

  // Insert a new farmer
  static Future<bool> insertFarmer(Map<String, dynamic> farmer) async {
    final db = await getDatabase();
    final result = await db.insert('farmers', farmer,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result > 0; // If result > 0, the insert operation succeeded
  }

  static Future<List<Map<String, dynamic>>> getUnsyncedFarmers() async {
    final db = await getDatabase();
    return await db.query('farmers', where: 'synced = ?', whereArgs: [0]);
  }

  static Future<void> syncFarmer(var row) async {
    final db = await getDatabase();
    await db.update(
      'farmers',
      {'synced': 1}, // Mark as synced
      where: 'id = ?', // Assuming 'id' is the primary key in your sqflite table
      whereArgs: [row['id']],
    );
  }

  // Get count of farmers
  static Future<int> getFarmerCount() async {
    final db = await getDatabase();
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM farmers');
    if (result.isNotEmpty) {
      return result.first['count'] as int? ?? 0;
    }
    return 0;
  }

//search farmer
  static Future<List<Map<String, dynamic>>> getFullNames(String query) async {
    final db = await getDatabase();
    return db.rawQuery('''
    SELECT first_name || ' ' || middle_name || ' ' || last_name AS full_name
    FROM farmers
    WHERE first_name LIKE ? OR middle_name LIKE ? OR last_name LIKE ?
  ''', ['%$query%', '%$query%', '%$query%']);
  }

  // Retrieve all farmers
  static Future<List<Map<String, dynamic>>> getFarmers() async {
    final db = await getDatabase();
    return db.query('farmers');
  }

  // Delete a farmer
  static Future<void> deleteFarmer(String id) async {
    final db = await getDatabase();
    await db.delete('farmers', where: 'id = ?', whereArgs: [id]);
  }

  // Update a farmer
  static Future<bool> updateFarmer(Map<String, dynamic> farmer) async {
    final db = await getDatabase();
    final result = await db
        .update('farmers', farmer, where: 'id = ?', whereArgs: [farmer['id']]);

    return result > 0;
  }

  // Insert a new sale
  static Future<bool> insertSale(Map<String, dynamic> sale) async {
    final db = await getDatabase();
    final result = await db.insert('sales', sale,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result > 0;
  }

  static Future<List<Map<String, dynamic>>> getUnsyncedSales() async {
    final db = await getDatabase();
    return await db.query('sales', where: 'synced = ?', whereArgs: [0]);
  }

  static Future<void> syncSale(var row) async {
    final db = await getDatabase();
    await db.update(
      'sales',
      {'synced': 1}, // Mark as synced
      where: 'id = ?', // Assuming 'id' is the primary key in your sqflite table
      whereArgs: [row['id']],
    );
  }

  // Retrieve all sales
  static Future<List<Map<String, dynamic>>> getSales() async {
    final db = await getDatabase();
    return db.query('sales');
  }

  // Get total sales
  static Future<double> getTotalSales() async {
    final db = await getDatabase();
    final result = await db.rawQuery('SELECT SUM(amount) as total FROM sales');

    if (result.isNotEmpty) {
      return result.first['total'] as double? ?? 0.0;
    }
    return 0.0;
  }

  static Future<int> getTotalWeight() async {
    final db = await getDatabase();
    final result = await db.rawQuery('SELECT SUM(weight) as total FROM sales');
    if (result.isNotEmpty) {
      return result.first['total'] as int? ?? 0;
    }
    return 0;
  }

  // Delete a sale
  static Future<void> deleteSale(String id) async {
    final db = await getDatabase();
    await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  // Update a sale
  static Future<void> updateSale(Map<String, dynamic> sale) async {
    final db = await getDatabase();
    await db.update('sales', sale, where: 'id = ?', whereArgs: [sale['id']]);
  }

  // Insert a new group
  static Future<void> insertGroup(Map<String, dynamic> group) async {
    final db = await getDatabase();
    await db.insert('groups', group,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get count of groups
  static Future<int> getGroupCount() async {
    final db = await getDatabase();
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM groups');
    if (result.isNotEmpty) {
      return result.first['count'] as int? ?? 0;
    }
    return 0;
  }

  // Retrieve all groups
  static Future<List<Map<String, dynamic>>> getGroups() async {
    final db = await getDatabase();
    return db.query('groups');
  }

  // Delete a group
  static Future<void> deleteGroup(String id) async {
    final db = await getDatabase();
    await db.delete('groups', where: 'id = ?', whereArgs: [id]);
  }

  // Update a group
  static Future<void> updateGroup(Map<String, dynamic> group) async {
    final db = await getDatabase();
    await db.update('groups', group, where: 'id = ?', whereArgs: [group['id']]);
  }

  // Insert a new farm
  static Future<void> insertFarm(Map<String, dynamic> farm) async {
    final db = await getDatabase();
    await db.insert('farms', farm,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all farms
  static Future<List<Map<String, dynamic>>> getFarms() async {
    final db = await getDatabase();
    return db.query('farms');
  }

  // Delete a farm
  static Future<void> deleteFarm(String id) async {
    final db = await getDatabase();
    await db.delete('farms', where: 'id = ?', whereArgs: [id]);
  }

  // Update a farm
  static Future<void> updateFarm(Map<String, dynamic> farm) async {
    final db = await getDatabase();
    await db.update('farms', farm, where: 'id = ?', whereArgs: [farm['id']]);
  }
}
