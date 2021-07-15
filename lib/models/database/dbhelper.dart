import 'dart:core';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trungchuyen/models/entity/account.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/entity/notification_of_limo.dart';
import 'package:trungchuyen/models/entity/notification_trung_chuyen.dart';
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
       idKhungGio INTEGER,
       idVanPhong INTEGER,
       ngayTC TEXT)
  ''');
    print("DB CustomerPending was created!");

    db.execute('''
    CREATE TABLE NotificationCustomer(
       idTrungChuyen TEXT,
       chuyen TEXT,
       thoiGian TEXT,
       loaiKhach INTEGER)
  ''');
    print("DB NotificationCustomer was created!");

    db.execute('''
    CREATE TABLE AccountSave(
      userName TEXT,
      pass TEXT)
  ''');
    print("Database AccountSave was created!");

    db.execute('''
    CREATE TABLE NotificationLimo(
       idTrungChuyen TEXT,
       nameTC TEXT,
       phoneTC TEXT,
       numberCustomer TEXT,
       listIdTAIXELIMO TEXT,
       idDriverTC TEXT)
  ''');
    print("DB NotificationLimo was created!");

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
       idKhungGio INTEGER,
       idVanPhong INTEGER,
       ngayTC TEXT)
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
      db.execute('ALTER TABLE NotificationLimo ADD COLUMN attributes TEXT');
      db.delete("NotificationLimo");
      db.execute('ALTER TABLE AccountSave ADD COLUMN attributes TEXT');
      db.delete("AccountSave");
    }
    db.execute('DROP TABLE IF EXISTS CustomerPending');
    db.delete("CustomerPending");
    db.execute('DROP TABLE IF EXISTS NotificationCustomer');
    db.delete("NotificationCustomer");
    db.execute('DROP TABLE IF EXISTS DriverLimoInfo');
    db.delete("DriverLimoInfo");
    db.execute('DROP TABLE IF EXISTS NotificationLimo');
    db.delete("NotificationLimo");
    db.execute('DROP TABLE IF EXISTS AccountSave');
    db.delete("AccountSave");
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = p.join(directory.toString(), 'database.db');
    var database = openDatabase(dbPath,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  /// Account
  Future<void> saveAccount(AccountInfo accountInfo) async {
    var client = await db;
    AccountInfo oldAccountInfo = await fetchAccountInfo(accountInfo.userName);
    if (oldAccountInfo == null)
      await client.insert('AccountSave', accountInfo.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      await updateAccountInfo(oldAccountInfo);
    }
  }

  Future<int> updateAccountInfo(AccountInfo accountInfo) async {
    var client = await db;
    return client.update('AccountSave', accountInfo.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<AccountInfo> fetchAccountInfo(String userName,) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
    client.query('AccountSave', where: 'userName = ?', whereArgs: [userName]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return AccountInfo.fromDb(maps.first);
    }
    return null;
  }

  Future<List<AccountInfo>> fetchAllAccountInfo() async {
    var client = await db;
    var res = await client.query('AccountSave');

    if (res.isNotEmpty) {
      var accountInfo =
      res.map((productMap) => AccountInfo.fromDb(productMap)).toList();
      return accountInfo;
    }
    return [];
  }

  ///Customer
  Future<void> addNew(Customer customer) async {
    var client = await db;
    Customer oldCustomer = await fetchCustomer(customer.idTrungChuyen);
    if (oldCustomer == null)
      await client.insert('CustomerPending', customer.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      await updateCustomer(oldCustomer);
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

  Future<int> updateCustomer(Customer customer) async {
    var client = await db;
    return client.update('CustomerPending', customer.toMapForDb(),
        where: 'idTrungChuyen = ?',
        whereArgs: [customer.idTrungChuyen],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateCustomerHuyOrDoiTaiXe(String idTCOld,Customer customer) async {
    var client = await db;
    return client.update('CustomerPending', customer.toMapForDb(),
        where: 'idTrungChuyen = ?',
        whereArgs: [idTCOld],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> remove(String idTC) async {
    var client = await db;
    return client.delete('CustomerPending', where: 'idTrungChuyen = ?', whereArgs: [idTC]);
  }

  ///Notification_Customer
  Future<void> addNotificationCustomer(NotificationCustomerOfTC notificationCustomer) async {
    var client = await db;
    NotificationCustomerOfTC oldNotificationCustomer = await fetchNotificationCustomer(notificationCustomer.idTrungChuyen);
    if (oldNotificationCustomer == null)
      await client.insert('NotificationCustomer', notificationCustomer.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      await updateNotificationCustomer(oldNotificationCustomer);
    }
  }

  Future<NotificationCustomerOfTC> fetchNotificationCustomer(String idTrungChuyen,) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
    client.query('NotificationCustomer', where: 'idTrungChuyen = ?', whereArgs: [idTrungChuyen]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return NotificationCustomerOfTC.fromDb(maps.first);
    }
    return null;
  }

  Future<int> updateNotificationCustomer(NotificationCustomerOfTC notificationCustomer) async {
    var client = await db;
    return client.update('NotificationCustomer', notificationCustomer.toMapForDb(),
        where: 'idTrungChuyen = ?',
        whereArgs: [notificationCustomer.idTrungChuyen],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NotificationCustomerOfTC>> fetchAllNotificationCustomer() async {
    var client = await db;
    var res = await client.query('NotificationCustomer');

    if (res.isNotEmpty) {
      var products =
      res.map((productMap) => NotificationCustomerOfTC.fromDb(productMap)).toList();
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


  ///Notification_Limo
  Future<void> addNotificationLimo(NotificationOfLimo notificationOfLimo) async {
    var client = await db;
    NotificationOfLimo oldNotificationLimo = await fetchNotificationLimo(notificationOfLimo.idTrungChuyen);
    if (oldNotificationLimo == null)
      await client.insert('NotificationLimo', notificationOfLimo.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      await updateNotificationLimo(oldNotificationLimo);
    }
  }

  Future<NotificationOfLimo> fetchNotificationLimo(String idTrungChuyen,) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
    client.query('NotificationLimo', where: 'idTrungChuyen = ?', whereArgs: [idTrungChuyen]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return NotificationOfLimo.fromDb(maps.first);
    }
    return null;
  }

  Future<int> updateNotificationLimo(NotificationOfLimo notificationCustomer) async {
    var client = await db;
    return client.update('NotificationLimo', notificationCustomer.toMapForDb(),
        where: 'idTrungChuyen = ?',
        whereArgs: [notificationCustomer.idTrungChuyen],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NotificationOfLimo>> fetchAllNotificationLimo() async {
    var client = await db;
    var res = await client.query('NotificationLimo');

    if (res.isNotEmpty) {
      var products =
      res.map((productMap) => NotificationOfLimo.fromDb(productMap)).toList();
      return products;
    }
    return [];
  }

  Future<void> removeNotificationLimo(String idTrungChuyen) async {
    var client = await db;
    return client.delete('NotificationLimo', where: 'idTrungChuyen = ?', whereArgs: [idTrungChuyen]);
  }

  Future<void> deleteAllNotificationLimo() async {
    var client = await db;
    await client.delete('NotificationLimo');
  }

  ///Tai xe Limo
  Future<void> addDriverLimo(Customer customer) async {
    var client = await db;
    Customer oldCustomer = await fetchDriverLimo(customer.idTaiXeLimousine);
    if (oldCustomer == null)
      await client.insert('DriverLimoInfo', customer.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      int sk = oldCustomer.soKhach + customer.soKhach;
      String listIdTC = oldCustomer.idTrungChuyen + ',' + customer.idTrungChuyen;
      await updateRowDriverLimo(oldCustomer,sk,listIdTC);
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

  Future<int> updateRowDriverLimo(Customer customer, int soKhach,String listIdTC) async{
    var client = await db;
    return client.rawUpdate('UPDATE DriverLimoInfo SET soKhach = ?,idTrungChuyen = ? WHERE idTaiXeLimousine = ?', [soKhach,listIdTC ,customer.idTaiXeLimousine]);
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
