class PulsarTenantModule {
  final String tenantName;

  PulsarTenantModule(this.tenantName);
}

class TenantPageContext {
  final String host;
  final int port;
  final PulsarTenantModule tenantModule;

  TenantPageContext(this.host, this.port, this.tenantModule);

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
