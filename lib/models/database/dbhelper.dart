import 'dart:core';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trungchuyen/models/entity/customer.dart';
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
    CREATE TABLE CustomerPending(
       idTrungChuyen TEXT,
       idTaiXeLimousine TEXT,
       hoTenTaiXeLimousine TEXT,
       dienThoaiTaiXeLimousine TEXT,
       tenXeLimousine TEXT,
       bienSoXeLimousine TEXT,
       tenKhachHang TEXT,
       soDienThoaiKhach TEXT,
       diaChiKhachDi TEXT,
       toaDoDiaChiKhachDi TEXT,
       diaChiKhachDen TEXT,
       toaDoDiaChiKhachDen TEXT,
       diaChiLimoDi TEXT,
       toaDoLimoDi TEXT,
       diaChiLimoDen TEXT,
       toaDoLimoDen TEXT,
       loaiKhach INTEGER,
       trangThaiTC TEXT,
       soKhach INTEGER,
       soKhach INTEGER,
       statusCustomer INTEGER,
      )
  ''');
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
    logger.i(
      "Migration: $oldVersion, $newVersion",
    );
    if (oldVersion == 1 && newVersion == 2) {
      db.execute('ALTER TABLE CustomerPending ADD COLUMN attributes TEXT');
      db.delete("CustomerPending");
    }
    db.execute('DROP TABLE IF EXISTS CustomerPending');
    db.delete("CustomerPending");
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = p.join(directory.toString(), 'database.db');
    var database = openDatabase(dbPath,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  Future<void> addNew(Customer customer) async {
    var client = await db;
    Customer oldCustomer = await fetchCustomer(customer.idTrungChuyen);
    if (oldCustomer == null)
      await client.insert('CustomerPending', customer.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      await update(oldCustomer);
    }
  }


  Future<Customer> fetchCustomer(String idTrungChuyen,) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('CustomerPending', where: 'idTrungChuyen = ?', whereArgs: [idTrungChuyen]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return Customer.fromDb(maps.first);
    }
    return null;
  }

  Future<void> deleteAll() async {
    var client = await db;
    await client.delete('CustomerPending');
  }

  Future<List<Customer>> fetchAll() async {
    var client = await db;
    var res = await client.query('CustomerPending');

    if (res.isNotEmpty) {
      var products =
          res.map((productMap) => Customer.fromDb(productMap)).toList();
      return products;
    }
    return [];
  }


  Future<void> delete(Customer customer) async {
    var client = await db;
    await client.delete('CustomerPending', where: 'idTrungChuyen = ?', whereArgs: [customer.idTrungChuyen]);
  }

  Future<int> update(Customer customer) async {
    var client = await db;
    return client.update('CustomerPending', customer.toMapForDb(),
        where: 'idTrungChuyen = ?',
        whereArgs: [customer.idTrungChuyen],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> remove(String idTC) async {
    var client = await db;
    return client.delete('CustomerPending', where: 'idTrungChuyen = ?', whereArgs: [idTC]);
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
