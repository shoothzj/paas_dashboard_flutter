import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_sink_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/const.dart';

void main() {
  test("test_create_sink", () async {
    var list = await PulsarSinkApi.getSinkList(PulsarConst.defaultHost,
        PulsarConst.defaultFunctionPort, "public", "default");
    print(list);
  });
}
