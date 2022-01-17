import 'package:paas_dashboard_flutter/persistent/po/redis_instance_po.dart';

class RedisInstanceViewModel {
  final RedisInstancePo redisInstancePo;

  RedisInstanceViewModel(this.redisInstancePo);

  RedisInstanceViewModel deepCopy() {
    return new RedisInstanceViewModel(redisInstancePo.deepCopy());
  }

  int get id {
    return this.redisInstancePo.id;
  }

  String get name {
    return this.redisInstancePo.name;
  }

  String get addr {
    return this.redisInstancePo.addr;
  }

  String get username {
    return this.redisInstancePo.username;
  }
}
