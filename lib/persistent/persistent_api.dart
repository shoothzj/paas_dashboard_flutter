import 'package:paas_dashboard_flutter/module/ssh/ssh_step.dart';
import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/k8s_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/mysql_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/zk_instance_po.dart';

abstract class PersistentApi {
  Future<void> savePulsar(String name, String host, int port,
      String functionHost, int functionPort);

  Future<void> deletePulsar(int id);

  Future<List<PulsarInstancePo>> pulsarInstances();

  Future<void> saveBookkeeper(String name, String host, int port);

  Future<void> deleteBookkeeper(int id);

  Future<List<BkInstancePo>> bookkeeperInstances();

  Future<void> saveZooKeeper(String name, String host, int port);

  Future<void> deleteZooKeeper(int id);

  Future<List<ZkInstancePo>> zooKeeperInstances();

  Future<void> saveKubernetesSsh(String name, List<SshStep> sshSteps);

  Future<void> deleteKubernetes(int id);

  Future<List<K8sInstancePo>> kubernetesInstances();

  Future<void> saveMongo(
      String name, String addr, String username, String password);

  Future<void> deleteMongo(int id);

  Future<List<MongoInstancePo>> mongoInstances();

  Future<void> saveMysql(
      String name, String host, int port, String username, String password);

  Future<void> deleteMysql(int id);

  Future<List<MysqlInstancePo>> mysqlInstances();
}
