import 'dart:core';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/entity/notification_customer.dart';
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
       trangThaiTC INTEGER,
       soKhach INTEGER,
       statusCustomer INTEGER,
       chuyen TEXT,
       totalCustomer INTEGER,
       indexListCustomer INTEGER)
  ''');
    print("DB CustomerPending was created!");

    db.execute('''
    CREATE TABLE NotificationCustomer(
       idTrungChuyen TEXT,
       chuyen TEXT,
       thoiGian TEXT,
       loaiKhach TEXT)
  ''');
    print("DB NotificationCustomer was created!");

    db.execute('''
    CREATE TABLE DriverLimoInfo(
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
       trangThaiTC INTEGER,
       soKhach INTEGER,
       statusCustomer INTEGER,
       chuyen TEXT,
       totalCustomer INTEGER,
       indexListCustomer INTEGER)
  ''');
    print("DB CustomerPending was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
    logger.i(
      "Migration: $oldVersion, $newVersion",
    );
    if (oldVersion == 1 && newVersion == 2) {
      db.execute('ALTER TABLE CustomerPending ADD COLUMN attributes TEXT');
      db.delete("CustomerPending");
      db.execute('ALTER TABLE NotificationCustomer ADD COLUMN attributes TEXT');
      db.delete("NotificationCustomer");
      db.execute('ALTER TABLE DriverLimoInfo ADD COLUMN attributes TEXT');
      db.delete("DriverLimoInfo");
    }
    db.execute('DROP TABLE IF EXISTS CustomerPending');
    db.delete("CustomerPending");
    db.execute('DROP TABLE IF EXISTS NotificationCustomer');
    db.delete("NotificationCustomer");
    db.execute('DROP TABLE IF EXISTS DriverLimoInfo');
    db.delete("DriverLimoInfo");
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

  ///Notification_Customer
  Future<void> addNotificationCustomer(NotificationCustomer notificationCustomer) async {
    var client = await db;
    NotificationCustomer oldNotificationCustomer = await fetchNotificationCustomer(notificationCustomer.idTrungChuyen);
    if (oldNotificationCustomer == null)
      await client.insert('NotificationCustomer', notificationCustomer.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      await updateNotificationCustomer(oldNotificationCustomer);
    }
  }

  Future<NotificationCustomer> fetchNotificationCustomer(String idTrungChuyen,) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
    client.query('NotificationCustomer', where: 'idTrungChuyen = ?', whereArgs: [idTrungChuyen]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return NotificationCustomer.fromDb(maps.first);
    }
    return null;
  }

  Future<int> updateNotificationCustomer(NotificationCustomer notificationCustomer) async {
    var client = await db;
    return client.update('NotificationCustomer', notificationCustomer.toMapForDb(),
        where: 'idTrungChuyen = ?',
        whereArgs: [notificationCustomer.idTrungChuyen],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NotificationCustomer>> fetchAllNotificationCustomer() async {
    var client = await db;
    var res = await client.query('NotificationCustomer');

    if (res.isNotEmpty) {
      var products =
      res.map((productMap) => NotificationCustomer.fromDb(productMap)).toList();
      return products;
    }
    return [];
  }

  Future<void> removeNotificationCustomer(String idTrungChuyen) async {
    var client = await db;
    return client.delete('NotificationCustomer', where: 'idTrungChuyen = ?', whereArgs: [idTrungChuyen]);
  }

  Future<void> deleteAllNotificationCustomer() async {
    var client = await db;
    await client.delete('NotificationCustomer');
  }

  ///Tai xe Limo
  Future<void> addDriverLimo(Customer customer) async {
    var client = await db;
    Customer oldCustomer = await fetchDriverLimo(customer.idTaiXeLimousine);
    if (oldCustomer == null)
      await client.insert('DriverLimoInfo', customer.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      int sk = oldCustomer.soKhach + 1;
      await updateRowDriverLimo(oldCustomer,sk);
    }
  }

  Future<Customer> fetchDriverLimo(String idTaiXeLimousine,) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
    client.query('DriverLimoInfo', where: 'idTaiXeLimousine = ?', whereArgs: [idTaiXeLimousine]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return Customer.fromDb(maps.first);
    }
    return null;
  }

  Future<int> updateRowDriverLimo(Customer customer, int soKhach) async{
    var client = await db;
    return client.rawUpdate('UPDATE DriverLimoInfo SET soKhach = ? WHERE idTrungChuyen = ?', [soKhach, customer.idTrungChuyen]);
    // await db.rawUpdate('UPDATE dogs SET age = ? WHERE id = ?', [35, 0]);
  }

  Future<int> updateDriverLimo(Customer customer) async {
    var client = await db;
    return client.update('DriverLimoInfo', customer.toMapForDb(),
        where: 'idTrungChuyen = ?', whereArgs: [customer.idTrungChuyen],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Customer>> fetchAllDriverLimo() async {
    var client = await db;
    var res = await client.query('DriverLimoInfo');

    if (res.isNotEmpty) {
      var products =
      res.map((productMap) => Customer.fromDb(productMap)).toList();
      return products;
    }
    return [];
  }

  Future<void> removeDriverLimo(String idTrungChuyen) async {
    var client = await db;
    return client.delete('DriverLimoInfo', where: 'idTrungChuyen = ?', whereArgs: [idTrungChuyen]);
  }

  Future<void> deleteAllDriverLimo() async {
    var client = await db;
    await client.delete('DriverLimoInfo');
  }
  Future closeDb() async {
    var client = await db;
    client.close();
  }
}
