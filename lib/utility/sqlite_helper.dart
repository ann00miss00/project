import 'dart:ffi';

import 'package:myproject_yourstyle/models/sqlite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'shoppingmall.db';
  final int version = 1;
  final String tableDatabase = 'tableOrder';
  final String columnId = 'id';
  final String columnIdProduct = 'idProduct';
  final String columnTitle = 'title';
  final String columnPrice = 'price';
  final String columnAmount = 'amount';
  final String columnSum = 'sum';

  SQLiteHelper() {
    initialDatabase();
  }

  Future<Null> initialDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableDatabase ($columnId INTEGER PRIMARY KEY, $columnIdProduct TEXT, $columnTitle TEXT, $columnPrice TEXT, $columnAmount TEXT, $columnSum TEXT)'),
      version: version,
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<List<SQLiteModel>> readSQLite() async {
    Database database = await connectedDatabase();
    List<SQLiteModel> results = [];
    List<Map<String, dynamic>> maps = await database.query(tableDatabase);
    // print('### maps on SQLiteHelper ==>> $maps');
    for (var item in maps) {
      SQLiteModel model = SQLiteModel.fromMap(item);
      results.add(model);
    }
    return results;
  }

  Future<Null> insertValueSQLite(SQLiteModel sqLiteModel) async {
    Database database = await connectedDatabase();
    await database.insert(tableDatabase, sqLiteModel.toMap()).then(
        (value) => print('### insert Value title ==>> ${sqLiteModel.title}'));
  }

  Future<void> deleteSQLiteWhereId(int id) async {
    Database database = await connectedDatabase();
    await database
        .delete(tableDatabase, where: '$columnId= $id')
        .then((value) => print('### Success Delete id ==>> $id'));
  }

  Future<void> emptySQLite() async {
    Database database = await connectedDatabase();
    await database
        .delete(tableDatabase)
        .then((value) => print('### Success Empty Cart'));
  }
}
