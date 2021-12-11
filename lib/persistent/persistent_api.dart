import 'package:paas_dashboard_flutter/module/ssh/ssh_step.dart';
import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/k8s_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';

abstract class PersistentApi {
  Future<void> savePulsar(String name, String host, int port, String functionHost, int functionPort);

  Future<void> deletePulsar(int id);

  Future<List<PulsarInstancePo>> pulsarInstances();

  Future<void> saveBookkeeper(String name, String host, int port);

  Future<void> deleteBookkeeper(int id);

  Future<List<BkInstancePo>> bookkeeperInstances();

  Future<void> saveKubernetesSsh(String name, List<SshStep> sshSteps);

  Future<void> deleteKubernetes(int id);

  Future<List<K8sInstancePo>> kubernetesInstances();
}
