import 'package:redis/redis.dart';

class RedisApi {
  static Future<void> set(String host, int port, String username, String password, String key, String value) async {
    final conn = RedisConnection();
    Command connect = await conn.connect(host, port);
    await connect.send_object(["SET", key, value]);
  }

  static Future<String> get(String host, int port, String username, String password, String key) async {
    final conn = RedisConnection();
    Command connect = await conn.connect(host, port);
    return await connect.send_object(["GET", key]);
  }
}
