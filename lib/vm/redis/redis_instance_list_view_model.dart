import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/vm/redis/redis_instance_view_model.dart';

class RedisInstanceListViewModel extends ChangeNotifier {
  List<RedisInstanceViewModel> instances = <RedisInstanceViewModel>[];

  Future<void> fetchRedisInstances() async {
    final results = await Persistent.redisInstances();
    this.instances = results.map((e) => RedisInstanceViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createRedis(String name, String host, int port, String username, String password) async {
    Persistent.saveRedis(name, host, port, username, password);
    fetchRedisInstances();
  }

  Future<void> deleteRedis(int id) async {
    Persistent.deleteRedis(id);
    fetchRedisInstances();
  }
}
