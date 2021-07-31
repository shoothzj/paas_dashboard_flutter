class TenantResp {
  final String tenantName;

  TenantResp(this.tenantName);

  TenantResp deepCopy() {
    return new TenantResp(this.tenantName);
  }

  factory TenantResp.fromJson(String name) {
    return TenantResp(name);
  }
}
