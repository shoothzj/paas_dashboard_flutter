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

class TenantInfoResp {
  final String adminRoles;
  final String allowedClusters;

  TenantInfoResp(this.adminRoles, this.allowedClusters);

  TenantInfoResp deepCopy() {
    return new TenantInfoResp(this.adminRoles, this.allowedClusters);
  }

  factory TenantInfoResp.fromJson(Map name) {
    return TenantInfoResp(name["adminRoles"], name["allowedClusters"]);
  }
}
