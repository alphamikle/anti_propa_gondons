import 'dart:async';
import 'dart:io';

import 'package:anti_propa_gondons/domain/main/entities/propa_gondon_resourse.dart';
import 'package:anti_propa_gondons/domain/main/entities/propa_gondon_update.dart';
import 'package:anti_propa_gondons/domain/main/logic/main_frontend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

typedef PropaGondonUrl = String;
typedef SuccessTicker = int;
typedef ErrorTicker = int;
typedef FrontendId = int;
typedef RequestsCount = int;

class MainScreenNotifier with ChangeNotifier {
  final Map<PropaGondonUrl, PropaGondonResource> _resources = {};
  final Set<PropaGondonUrl> _disabledResources = {};
  final Map<FrontendId, RequestsCount> _requestsCounts = {};
  final Map<FrontendId, RequestsCount> _totalRequestsCounts = {};
  final Completer<bool> _initializationCompleter = Completer<bool>();
  bool _isInitialized = false;
  final List<MainFrontend> _frontends = [];

  int get propaGondonResourcesCount => _resources.length;
  PropaGondonResource getResourceByIndex(int index) => _resources.values.toList()[index];
  bool isPropaGondonResourceDisabled(PropaGondonUrl url) => _disabledResources.contains(url);
  Future<bool> get isInitialized async {
    if (_isInitialized) {
      return _isInitialized;
    }
    if (_initializationCompleter.isCompleted) {
      return true;
    }
    final result = await _initializationCompleter.future;
    return result;
  }

  int get requestsInWork {
    if (_requestsCounts.isEmpty) {
      return 0;
    }
    return _requestsCounts.values.fold(0, (int totalCount, RequestsCount frontendCount) => totalCount + frontendCount);
  }

  int get totalRequests {
    if (_totalRequestsCounts.isEmpty) {
      return 0;
    }
    return _totalRequestsCounts.values.fold(0, (int totalCount, RequestsCount frontendCount) => totalCount + frontendCount);
  }

  bool get isAnyResourceDisabled => _disabledResources.isNotEmpty;

  bool get isAllResourceDisabled => _disabledResources.length == _resources.length;

  bool get isNoDisabledResources => !isAnyResourceDisabled;

  Timer? _updateTimer;

  void togglePropaGondonResource(PropaGondonUrl url) {
    if (isPropaGondonResourceDisabled(url)) {
      _disabledResources.remove(url);
      for (final MainFrontend frontend in _frontends) {
        frontend.enableResource(url);
      }
    } else {
      _disabledResources.add(url);
      for (final MainFrontend frontend in _frontends) {
        frontend.disableResource(url);
      }
    }
    notifyListeners();
  }

  void togglePropaGondonResources() {
    if (isAllResourceDisabled) {
      _disabledResources.clear();
      for (final MainFrontend frontend in _frontends) {
        frontend.enableAllResources();
      }
    } else {
      _disabledResources.addAll(_resources.keys);
      for (final MainFrontend frontend in _frontends) {
        frontend.disableAllResources();
      }
    }
    notifyListeners();
  }

  void _updateResourceInfo(PropaGondonUpdate data) {
    if (!_resources.containsKey(data.url)) {
      _resources[data.url] = PropaGondonResource.fromUrl(data.url);
    }
    final PropaGondonResource resource = _resources[data.url]!;
    final int success = data.isSuccess ? resource.successRequests + 1 : resource.successRequests;
    final int errors = data.isSuccess ? resource.errorRequests : resource.errorRequests + 1;
    _resources[data.url] = resource.copyWith(
      successRequests: success,
      errorRequests: errors,
    );
    _updateUI();
  }

  void _initLocalData(List<PropaGondonResource> data) {
    if (_resources.isEmpty) {
      for (final PropaGondonResource resource in data) {
        _resources[resource.url] = resource;
      }
    }
  }

  void _updateRequestsCount({required int frontendId, required int requestsCount}) {
    _requestsCounts[frontendId] = requestsCount;
    _updateUI();
  }

  void _updateRequestTotalCount(FrontendId frontendId) {
    if (!_totalRequestsCounts.containsKey(frontendId)) {
      _totalRequestsCounts[frontendId] = 0;
    }
    _totalRequestsCounts[frontendId] = _totalRequestsCounts[frontendId]! + 1;
    _updateUI();
  }

  void _updateUI() {
    _updateTimer?.cancel();
    _updateTimer = Timer(const Duration(milliseconds: 10), () {
      notifyListeners();
    });
  }

  Future<void> initialize() async {
    final int threadsNumber = true ? 1 : Platform.numberOfProcessors;
    for (int i = 0; i < threadsNumber; i++) {
      final MainFrontend frontend = MainFrontend(
        id: i,
        onUpdate: _updateResourceInfo,
        onRequestsCountUpdate: _updateRequestsCount,
        onTotalRequestsUpdate: _updateRequestTotalCount,
        onInit: i == 0 ? _initLocalData : null,
      );
      await frontend.init();
      _frontends.add(frontend);
    }
    _initializationCompleter.complete(true);
    _isInitialized = true;
    notifyListeners();
  }
}
