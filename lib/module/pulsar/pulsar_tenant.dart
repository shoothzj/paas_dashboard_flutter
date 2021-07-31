class TenantResp {
  final String tenant;

  TenantResp(this.tenant);

  TenantResp deepCopy() {
    return new TenantResp(this.tenant);
  }

  factory TenantResp.fromJson(String name) {
    return TenantResp(name);
  }
}
