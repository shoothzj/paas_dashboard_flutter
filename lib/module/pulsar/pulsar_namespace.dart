import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_view_model.dart';

class PulsarNamespaceModule {
  final String namespaceName;

  PulsarNamespaceModule(this.namespaceName);
}

class NamespacePageContext {
  final PulsarNamespaceViewModel pulsarNamespaceViewModel;
  final PulsarNamespaceModule namespaceModule;

  NamespacePageContext(this.pulsarNamespaceViewModel, this.namespaceModule);

  String get host {
    return pulsarNamespaceViewModel.host;
  }

  int get port {
    return pulsarNamespaceViewModel.port;
  }

  String get tenantName {
    return pulsarNamespaceViewModel.tenantName;
  }

  String get namespaceName {
    return namespaceModule.namespaceName;
  }
}

class NamespaceResp {
  final String namespaceName;

  NamespaceResp(this.namespaceName);

  NamespaceResp deepCopy() {
    return new NamespaceResp(namespaceName);
  }

  factory NamespaceResp.fromJson(String name) {
    var split = name.split("/");
    return NamespaceResp(split[split.length - 1]);
  }
}
