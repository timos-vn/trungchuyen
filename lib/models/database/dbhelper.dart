import 'dart:core';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trungchuyen/models/entity/lang.dart';
import 'package:trungchuyen/utils/log.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();

    return _database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE language(
      code TEXT,
      name TEXT,
      hot TEXT,
      id TEXT,
      pass TEXT)
  ''');
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
    logger.i(
      "Migration: $oldVersion, $newVersion",
    );
    if (oldVersion == 1 && newVersion == 2) {
      db.execute('ALTER TABLE language ADD COLUMN attributes TEXT');
      db.delete("product");
//        db.execute('ALTER TABLE product ADD COLUMN unit TEXT');
    }
    db.execute('DROP TABLE IF EXISTS language');
    db.delete("language");
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = p.join(directory.toString(), 'database.db');
    var database = openDatabase(dbPath,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  Future<void> addProduct(Lang lang) async {
    var client = await db;
    Lang oldLang = await fetchProduct(lang.code);
    if (oldLang == null)
      await client.insert('language', lang.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      await updateProduct(oldLang);
    }
  }

  // Future<void> decreaseProduct(Product product) async {
  //   if (product.count > 1) {
  //     product.count = product.count - 1;
  //     updateProduct(product);
  //   }
  // }

  // Future<void> increaseProduct(Product product) async {
  //   product.count = product.count + 1;
  //   updateProduct(product);
  // }

  Future<Lang> fetchProduct(String code) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('language', where: 'code = ?', whereArgs: [code]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return Lang.fromDb(maps.first);
    }
    return null;
  }

  // Future<void> deleteAllProduct() async {
  //   var client = await db;
  //   await client.delete('product');
  // }

  Future<List<Lang>> fetchAllProduct() async {
    var client = await db;
    var res = await client.query('language');

    if (res.isNotEmpty) {
      var products =
          res.map((productMap) => Lang.fromDb(productMap)).toList();
      return products;
    }
    return [];
  }

  Future<List<Lang>> getLang() async {
    var client = await db;
    var res = await client.query('language',);//where: 'code = ?', whereArgs: [1]
    if (res.isNotEmpty) {
      var products =
          res.map((productMap) => Lang.fromDb(productMap)).toList();
      return products;
    }
    return [];
  }

  Future<void> deleteLang(Lang lang) async {
    var client = await db;
    await client.delete('language', where: 'code = ?', whereArgs: [lang.code]);
  }

  Future<int> updateProduct(Lang lang) async {
    var client = await db;
    return client.update('language', lang.toMapForDb(),
        // where: 'code = ?',
        // whereArgs: [lang.code],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeProduct(int id) async {
    var client = await db;
    return client.delete('language', where: 'id = ?', whereArgs: [id]);
  }

  // Future<List<Map<String, dynamic>>> countProduct({Database database}) async {
  //   var client = database ?? await db;
  //   return client.rawQuery('SELECT COUNT (id) FROM product', null);
  // }

  // Future<int> getCountProduct({Database database}) async {
  //   var client = database ?? await db;
  //   var countDb = await countProduct(database: client);
  //   if (countDb == null) return 0;
  //   return countDb[0]['COUNT (id)'];
  // }

  Future closeDb() async {
    var client = await db;
    client.close();
  }
}
