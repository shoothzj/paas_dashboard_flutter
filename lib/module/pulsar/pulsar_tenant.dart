import 'package:paas_dashboard_flutter/module/pulsar/pulsar_instance.dart';

class PulsarTenantModule {
  final String tenantName;

  PulsarTenantModule(this.tenantName);
}

class TenantPageContext {
  final PulsarInstanceContext instanceContext;
  final PulsarTenantModule tenantModule;

  TenantPageContext(this.instanceContext, this.tenantModule);

  String get host {
    return instanceContext.host;
  }

  int get port {
    return instanceContext.port;
  }

  String get tenantName {
    return tenantModule.tenantName;
  }
}

class TenantResp {
  final String tenantName;

  TenantResp(this.tenantName);

  factory TenantResp.fromJson(String name) {
    return TenantResp(name);
  }
}