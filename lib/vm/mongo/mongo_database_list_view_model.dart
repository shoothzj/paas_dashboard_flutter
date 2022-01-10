import 'package:paas_dashboard_flutter/api/mongo/mongo_databases_api.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_database_view_model.dart';

class MongoDatabaseListViewModel
    extends BaseLoadListPageViewModel<MongoDatabaseViewModel> {
  final MongoInstancePo mongoInstancePo;

  MongoDatabaseListViewModel(this.mongoInstancePo);

  MongoDatabaseListViewModel deepCopy() {
    return new MongoDatabaseListViewModel(mongoInstancePo.deepCopy());
  }

  Future<void> fetchDatabases() async {
    try {
      final results = await MongoDatabaseApi.getDatabaseList(
          mongoInstancePo.addr,
          mongoInstancePo.username,
          mongoInstancePo.password);
      this.fullList = results
          .map((e) => MongoDatabaseViewModel(mongoInstancePo, e))
          .toList();
      this.displayList = this.fullList;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> filter(String str) async {
    if (str == "") {
      this.displayList = this.fullList;
      notifyListeners();
      return;
    }
    if (!loading && loadException == null) {
      this.displayList = this
          .fullList
          .where((element) => element.databaseName.contains(str))
          .toList();
    }
    notifyListeners();
  }
}
