import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';

class PulsarNamespaceModule {
  final String namespaceName;

  PulsarNamespaceModule(this.namespaceName);
}

class NamespacePageContext {
  final TenantPageContext tenantPageContext;
  final PulsarNamespaceModule namespaceModule;

  NamespacePageContext(this.tenantPageContext, this.namespaceModule);

  String get host {
    return tenantPageContext.host;
  }

  int get port {
    return tenantPageContext.port;
  }

  String get tenantName {
    return tenantPageContext.tenantModule.tenantName;
  }

  String get namespaceName {
    return namespaceModule.namespaceName;
  }
}

class NamespaceResp {
  final String namespaceName;

  NamespaceResp(this.namespaceName);

  factory NamespaceResp.fromJson(String name) {
    var split = name.split("/");
    return NamespaceResp(split[split.length - 1]);
  }
}
