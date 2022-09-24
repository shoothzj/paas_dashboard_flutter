import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_sink_api.dart';
import 'package:paas_dashboard_flutter/api/tls_context.dart';
import 'package:paas_dashboard_flutter/module/pulsar/const.dart';

void main() {
  test("test_create_sink", () async {
    var list = await PulsarSinkApi.getSinkList(1, PulsarConst.defaultHost, PulsarConst.defaultFunctionPort,
        TlsContext(false, "", "", "", ""), "public", "default");
    print(list);
  });
}
