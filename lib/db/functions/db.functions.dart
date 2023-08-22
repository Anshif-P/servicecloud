import 'dart:async';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // User Table
  static const dbName = 'users.db';
  static const dbVersion = 1;
  static const dbTable = 'userTable';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnEmail = 'email';
  static const columnPassword = 'password';
  static const loginCheck = 'loginCheck';
  static const columnStock = 'columnStock';
  static const columnImage = 'columnImage';

  // Details Table
  static const detailsTable = 'detailsTable';
  static const detailsColumnId = 'detailsColumnId';
  static const columnCustomerName = 'customerName';
  static const columnMobNo = 'mobNo';
  static const columnDeviceName = 'deviceName';
  static const columnModelName = 'modelName';
  static const columnServiceRequired = 'serviceRequired';
  static const columnDeviceCondition = 'deviceCondition';
  static const columnSecurityCode = 'securityCode';
  static const columnAmount = 'amount';
  static const columnDeviceImage = 'deviceImage';
  static const columnDeliveryDate = 'deliveryDate';
  static const userId = 'userId';
  static const columnServiceStatus = 'ServiceStatus';
  static const columnSpareCharge = 'SpareCharge';
  static const columnServiceCharge = 'ServiceCharge';
  static const columnComments = 'Comments';
  static const columnDate = 'Date';
  static const columnRevenue = 'revenue';
  static const columnProfit = 'profit';
  static const columnChoiceChips = 'ChoiceChips';

  static final DatabaseHelper instance = DatabaseHelper();
  static Database? _database;
  bool isAvailable = false;

  Future<Database?> get database async {
    _database ??= await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $dbTable(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnEmail TEXT NOT NULL,
      $columnPassword TEXT NOT NULL,
      $columnStock INTEGER DEFAULT 0,
      $columnImage TEXT,
      $loginCheck TEXT
     
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $detailsTable(
      $detailsColumnId INTEGER PRIMARY KEY,
      $columnDeviceName TEXT NOT NULL,
      $columnModelName TEXT NOT NULL,
      $columnDeliveryDate TEXT NOT NULL,
      $columnAmount TEXT NOT NULL,
      $columnServiceRequired TEXT NOT NULL,
      $columnDeviceImage TEXT NOT NULL,
      $columnDeviceCondition TEXT NOT NULL,
      $columnMobNo TEXT NOT NULL,
      $columnCustomerName TEXT NOT NULL,
      $columnSecurityCode TEXT NOT NULL,
      $userId INTEGER,
      $columnServiceStatus TEXT ,
      $columnSpareCharge INTEGER DEFAULT 0,
      $columnServiceCharge INTEGER DEFAULT 0,
      $columnDate TEXT ,
      $columnComments TEXT,
      $columnChoiceChips TEXT,
      $columnRevenue INTEGER DEFAULT 0,
      $columnProfit INTEGER DEFAULT 0
      



    )
    ''');
  }

  // Get Revenue and Profit Today  //

  Future<Map<String, int>> getTodayProfitRevenu(int id, currentDate) async {
    Database? db = await instance.database;
    final todayProfitRevenu =
        await db!.query(detailsTable, where: '$userId = ?', whereArgs: [id]);

    final List<int> profit =
        todayProfitRevenu.map((details) => details['profit'] as int).toList();
    final List<int> revenue =
        todayProfitRevenu.map((details) => details['revenue'] as int).toList();

    int profitAmount = 0;
    for (int i = 0; i < profit.length; i++) {
      profitAmount += profit[i];
    }
    int revenueAmount = 0;
    for (int i = 0; i < revenue.length; i++) {
      revenueAmount += revenue[i];
    }
    Map<String, int> map = {
      'profitAmount': profitAmount,
      'revenueAmount': revenueAmount,
    };

    return map;
  }

  //------------------------------------------------------------------------------------//
  // get revenue and profit date base this month  //
  Future<Map<String, int>> getRevenueProfit(id, startDate, currentDate) async {
    Database? db = await instance.database;
    final customRevenueProfit = await db!.query(detailsTable,
        where: '$userId = ? AND $columnDate >= ? AND $columnDate <= ?',
        whereArgs: [id, startDate, currentDate]);
    final List<int> profit =
        customRevenueProfit.map((details) => details['profit'] as int).toList();
    final List<int> revenue = customRevenueProfit
        .map((details) => details['revenue'] as int)
        .toList();

    int profitAmount = 0;
    for (int i = 0; i < profit.length; i++) {
      profitAmount += profit[i];
    }
    int revenueAmount = 0;
    for (int i = 0; i < revenue.length; i++) {
      revenueAmount += revenue[i];
    }
    Map<String, int> map = {
      'profitAmount': profitAmount,
      'revenueAmount': revenueAmount,
    };

    return map;
  }

  // Get Finished and Processing work   //
  Future<Map<String, int>> getFinishedPendingDetails(id) async {
    List<Map<String, dynamic>> processingDetail =
        await getSortedList(id, 'Processing');
    List<Map<String, dynamic>> finishedDetail =
        await getSortedList(id, 'Finished');
    List<Map<String, dynamic>> billedDetail = await getSortedList(id, 'Billed');
    int? processingCount = processingDetail.length;
    int? finishedCount = finishedDetail.length + billedDetail.length;
    Map<String, int> map = {
      'processingCount': processingCount,
      'finishedCount': finishedCount,
    };
    return map;
  }

  // Add profit and revenue  //
  updateProfitRevenue(id, revenue, profit) async {
    Database? db = await instance.database;
    await db!.update(
        detailsTable, {columnRevenue: revenue, columnProfit: profit},
        where: '$detailsColumnId=?', whereArgs: [id]);
  }

  // Update Name Email Image  //
  updateNameEmailPhoto(rowId, name, email, image) async {
    Database? db = await instance.database;
    await db!.update(
        dbTable, {columnImage: image, columnName: name, columnEmail: email},
        where: '$columnId=?', whereArgs: [rowId]);
    final data = await getLogedUser();
    return data;
  }

  Future<int> insertRecord(Map<String, dynamic> row) async {
    Database? db = await instance.database;

    return await db!.insert(dbTable, row);
  }

  // Log out User //
  Future<Map<String, Object?>?> getLogedUser() async {
    Database? db = await instance.database;
    final userLisr = await db!.query(dbTable, where: '$loginCheck=1', limit: 1);
    if (userLisr.length == 0) {
      return null;
    }
    final logedUser = userLisr.first;
    return logedUser;
  }

  // Get User   //

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database? db = await instance.database;
    return await db!.query(dbTable);
  }

  // stock update

  Future<void> userUpdateStock({required int id, required int stock}) async {
    Database? db = await instance.database;
    await db!.update(dbTable, {columnStock: stock},
        where: '$columnId = ?', whereArgs: [id]);
  }

  // upadate logincheck

  Future<void> userLogInUpdate(String emailId) async {
    Database? db = await instance.database;
    await db!.update(dbTable, {loginCheck: '1'},
        where: '$columnEmail = ?', whereArgs: [emailId]);
  }
  // Get Stock amount

  Future<int> getStockAmount(int userId) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> result = await db!.query(dbTable,
        columns: [columnStock], where: '$columnId = ?', whereArgs: [userId]);
    if (result.isNotEmpty) {
      int? stockAmount = result[0][columnStock] as int?;
      return stockAmount ??
          0; // Return the stock amount if not null, otherwise return 0
    } else {
      return 0; // Return 0 if the stock amount is not found
    }
  }

  UserEmailAvailable(String email) async {
    Database? db = await instance.database;
    final userList =
        await db!.query(dbTable, where: '$columnEmail = ?', whereArgs: [email]);
    return isAvailable = userList.isNotEmpty;
  }

  bool isUsernameAvailable() {
    return isAvailable;
  }

  Future<void> userLogoutUpdate(String emailId) async {
    Database? db = await instance.database;
    await db!.update(dbTable, {loginCheck: '0'},
        where: '$columnEmail = ?', whereArgs: [emailId]);
  }

  Future<int> insertInputRecord(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(detailsTable, row);
  }

  Future<List<Map<String, dynamic>>> getAllInputUsers() async {
    Database? db = await instance.database;
    return await db!.query(detailsTable);
  }
  // -------- update stusas ------- //

  Future<List<Map<String, dynamic>>> getLogedUserInputDetails(int Id) async {
    Database? db = await instance.database;
    final userLisr =
        await db!.query(detailsTable, where: '$userId = ?', whereArgs: [Id]);

    return userLisr;
  }

  // get Stutas  //

  Future<List<Map<String, dynamic>>> getServiceStutas(int customerId) async {
    Database? db = await instance.database;
    final customerStutas = await db!.query(detailsTable,
        where: '$detailsColumnId = ?', whereArgs: [customerId]);
    return customerStutas;
  }

  // Function to update the status in the database //

  Future<void> updateStutas(int customerId, String status) async {
    Database? db = await instance.database;
    await db!.update(detailsTable, {columnServiceStatus: status},
        where: '$detailsColumnId = ?', whereArgs: [customerId]);
  }

  // Get processing status List//

  Future<List<Map<String, dynamic>>> getSortedList(
      int Id, String status) async {
    Database? db = await instance.database;
    final processingWorkList = await db!.query(detailsTable,
        where: '$userId=? AND $columnServiceStatus=?', whereArgs: [Id, status]);
    return processingWorkList;
  }

  // insert Service charge and Spare charge //
  updateServiceChargeSpareCharge(rowId, spare, service, comment) async {
    Database? db = await instance.database;
    await db!.update(
        detailsTable,
        {
          columnServiceCharge: service,
          columnSpareCharge: spare,
          columnComments: comment
        },
        where: '$detailsColumnId=?',
        whereArgs: [rowId]);
  }

  /// Update Choice chips values  ///

  Future<void> UpdateChoiceChipsValues(
      {required int id, required selectedCounts}) async {
    Database? db = await instance.database;
    await db!.update(detailsTable, {columnChoiceChips: selectedCounts},
        where: '$detailsColumnId = ?', whereArgs: [id]);
  }

  // get Choice chips values //

  Future<String?> getColumnChoiceChipsValue(int id) async {
    Database? db = await instance.database;

    List<Map<String, dynamic>> result = await db!.query(
      detailsTable,
      columns: [columnChoiceChips],
      where: '$detailsColumnId = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      String? choiceChipsValue = result[0][columnChoiceChips];
      return choiceChipsValue;
    } else {
      return null; // Row not found
    }
  }
}
