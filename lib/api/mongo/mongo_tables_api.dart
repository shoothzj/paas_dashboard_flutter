import 'package:mongo_dart/mongo_dart.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_table.dart';

class MongoTablesApi {
  static Future<List<TableResp>> getTableList(String addr, String username,
      String password, String databaseName) async {
    var db = await Db.create(addr + "/" + databaseName);
    await db.open();
    var collectionNames = await db.getCollectionNames();
    return collectionNames.whereType<String>().map((name) {
      return new TableResp(name);
    }).toList();
  }
}
