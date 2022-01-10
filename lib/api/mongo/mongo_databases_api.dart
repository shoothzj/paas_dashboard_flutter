import 'package:mongo_dart/mongo_dart.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_database.dart';

class MongoDatabaseApi {
  static Future<List<DatabaseResp>> getDatabaseList(
      String addr, String username, String password) async {
    var db = await Db.create(addr);
    await db.open();
    var databases = await db.listDatabases();
    return databases.map((name) => new DatabaseResp(name)).toList();
  }
}
