import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._init();

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ratek.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Create farmers table
    await db.execute('''
      CREATE TABLE farmers (
        id $idType,
        name $textType,
        phone $textType,
        location $textType,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // Create farms table
    await db.execute('''
      CREATE TABLE farms (
        id $idType,
        farmer_id $integerType,
        size $textType,
        crop_type $textType,
        planting_date $textType,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (farmer_id) REFERENCES farmers (id)
      )
    ''');

    // Create sales table
    await db.execute('''
      CREATE TABLE sales (
        id $idType,
        farmer_id $integerType,
        amount $textType,
        date $textType,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (farmer_id) REFERENCES farmers (id)
      )
    ''');

    // Create groups table
    await db.execute('''
      CREATE TABLE groups (
        id $idType,
        name $textType,
        description $textType,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // Create group_members table
    await db.execute('''
      CREATE TABLE group_members (
        id $idType,
        group_id $integerType,
        farmer_id $integerType,
        joined_at $textType,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (group_id) REFERENCES groups (id),
        FOREIGN KEY (farmer_id) REFERENCES farmers (id)
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  // Generic CRUD operations
  Future<int> create(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> read(String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await instance.database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(String table, Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await instance.database;
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await instance.database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }
} 