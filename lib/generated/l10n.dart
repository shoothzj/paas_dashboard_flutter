// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
        _current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About author`
  String get aboutAuthor {
    return Intl.message(
      'About author',
      name: 'aboutAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Paas Dashboard`
  String get appName {
    return Intl.message(
      'Paas Dashboard',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Basic`
  String get basic {
    return Intl.message(
      'Basic',
      name: 'basic',
      desc: '',
      args: [],
    );
  }

  /// `Broker Instance`
  String get brokersName {
    return Intl.message(
      'Broker Instance',
      name: 'brokersName',
      desc: '',
      args: [],
    );
  }

  /// `byte`
  String get byte {
    return Intl.message(
      'byte',
      name: 'byte',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Clear Backlog`
  String get clearBacklog {
    return Intl.message(
      'Clear Backlog',
      name: 'clearBacklog',
      desc: '',
      args: [],
    );
  }

  /// `code query`
  String get codeQuery {
    return Intl.message(
      'code query',
      name: 'codeQuery',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `ConfirmClear?`
  String get confirmClearBacklog {
    return Intl.message(
      'ConfirmClear?',
      name: 'confirmClearBacklog',
      desc: '',
      args: [],
    );
  }

  /// `ConfirmDelete?`
  String get confirmDeleteQuestion {
    return Intl.message(
      'ConfirmDelete?',
      name: 'confirmDeleteQuestion',
      desc: '',
      args: [],
    );
  }

  /// `consume`
  String get consume {
    return Intl.message(
      'consume',
      name: 'consume',
      desc: '',
      args: [],
    );
  }

  /// `Consumer`
  String get consumer {
    return Intl.message(
      'Consumer',
      name: 'consumer',
      desc: '',
      args: [],
    );
  }

  /// `Consumer List`
  String get consumerList {
    return Intl.message(
      'Consumer List',
      name: 'consumerList',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Namespace`
  String get deleteNamespace {
    return Intl.message(
      'Delete Namespace',
      name: 'deleteNamespace',
      desc: '',
      args: [],
    );
  }

  /// `Delete Tenant`
  String get deleteTenant {
    return Intl.message(
      'Delete Tenant',
      name: 'deleteTenant',
      desc: '',
      args: [],
    );
  }

  /// `Delete Topic`
  String get deleteTopic {
    return Intl.message(
      'Delete Topic',
      name: 'deleteTopic',
      desc: '',
      args: [],
    );
  }

  /// `detail`
  String get detail {
    return Intl.message(
      'detail',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `execute`
  String get execute {
    return Intl.message(
      'execute',
      name: 'execute',
      desc: '',
      args: [],
    );
  }

  /// `Is Leader`
  String get isLeader {
    return Intl.message(
      'Is Leader',
      name: 'isLeader',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get languageSettings {
    return Intl.message(
      'Language Settings',
      name: 'languageSettings',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `namespace`
  String get namespace {
    return Intl.message(
      'namespace',
      name: 'namespace',
      desc: '',
      args: [],
    );
  }

  /// `Namespace Name`
  String get namespaceName {
    return Intl.message(
      'Namespace Name',
      name: 'namespaceName',
      desc: '',
      args: [],
    );
  }

  /// `Namespaces`
  String get namespaces {
    return Intl.message(
      'Namespaces',
      name: 'namespaces',
      desc: '',
      args: [],
    );
  }

  /// `Partition List`
  String get partitionList {
    return Intl.message(
      'Partition List',
      name: 'partitionList',
      desc: '',
      args: [],
    );
  }

  /// `Partition number`
  String get partitionNum {
    return Intl.message(
      'Partition number',
      name: 'partitionNum',
      desc: '',
      args: [],
    );
  }

  /// `Produce`
  String get produce {
    return Intl.message(
      'Produce',
      name: 'produce',
      desc: '',
      args: [],
    );
  }

  /// `Producer List`
  String get producerList {
    return Intl.message(
      'Producer List',
      name: 'producerList',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Search by Namespace Name`
  String get searchByNamespace {
    return Intl.message(
      'Search by Namespace Name',
      name: 'searchByNamespace',
      desc: '',
      args: [],
    );
  }

  /// `Search by Tenant Name`
  String get searchByTenant {
    return Intl.message(
      'Search by Tenant Name',
      name: 'searchByTenant',
      desc: '',
      args: [],
    );
  }

  /// `Search by Topic Name`
  String get searchByTopic {
    return Intl.message(
      'Search by Topic Name',
      name: 'searchByTopic',
      desc: '',
      args: [],
    );
  }

  /// `second`
  String get second {
    return Intl.message(
      'second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `subscription`
  String get subscription {
    return Intl.message(
      'subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Subscription list`
  String get subscriptionList {
    return Intl.message(
      'Subscription list',
      name: 'subscriptionList',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Name`
  String get subscriptionName {
    return Intl.message(
      'Subscription Name',
      name: 'subscriptionName',
      desc: '',
      args: [],
    );
  }

  /// `sql query`
  String get sqlQuery {
    return Intl.message(
      'sql query',
      name: 'sqlQuery',
      desc: '',
      args: [],
    );
  }

  /// `tenant`
  String get tenant {
    return Intl.message(
      'tenant',
      name: 'tenant',
      desc: '',
      args: [],
    );
  }

  /// `Tenant Name`
  String get tenantName {
    return Intl.message(
      'Tenant Name',
      name: 'tenantName',
      desc: '',
      args: [],
    );
  }

  /// `Tenants`
  String get tenants {
    return Intl.message(
      'Tenants',
      name: 'tenants',
      desc: '',
      args: [],
    );
  }

  /// `topic detail`
  String get topicDetail {
    return Intl.message(
      'topic detail',
      name: 'topicDetail',
      desc: '',
      args: [],
    );
  }

  /// `Topic Name`
  String get topicName {
    return Intl.message(
      'Topic Name',
      name: 'topicName',
      desc: '',
      args: [],
    );
  }

  /// `Topics`
  String get topics {
    return Intl.message(
      'Topics',
      name: 'topics',
      desc: '',
      args: [],
    );
  }

  /// `unit`
  String get unit {
    return Intl.message(
      'unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get versionName {
    return Intl.message(
      'Version',
      name: 'versionName',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
