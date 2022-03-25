import 'dart:async';
import 'dart:math';

import 'package:anti_propa_gondons/config.dart';
import 'package:anti_propa_gondons/domain/main/entities/propa_gondon_resourse.dart';
import 'package:anti_propa_gondons/domain/main/entities/propa_gondon_update.dart';
import 'package:anti_propa_gondons/domain/main/logic/main_frontend.dart';
import 'package:anti_propa_gondons/domain/main/logic/main_screen_notifier.dart';
import 'package:anti_propa_gondons/propa_gondon_resources.dart';
import 'package:dio/dio.dart';
import 'package:isolator/isolator.dart';

typedef SpecialOperationId = String;

class MainBackend extends Backend {
  MainBackend({required BackendArgument<bool> argument}) : super(argument: argument);

  final _dio = Dio(
    BaseOptions(
        // connectTimeout: 10000,
        // receiveTimeout: 10000,
        // sendTimeout: 10000,
        ),
  );

  final Set<PropaGondonUrl> _disabledResources = {};
  final Set<SpecialOperationId> _specialOperationsIds = {};

  int _operationsCounter = 0;
  int _emptyCycleCounter = 0;
  int _prevOperationsCount = 0;

  static MainBackend create(BackendArgument<bool> argument) {
    return MainBackend(argument: argument);
  }

  void _init({required MainEvents event, required bool data}) {
    if (data) {
      final List<PropaGondonResource> resources = propaGondonResources.map(PropaGondonResource.fromUrl).toList();
      send(event: MainEvents.initializationComplete, data: resources, sendDirectly: true);
    }
    _startOperations();
  }

  Future<void> _startOperations() async {
    const Duration delay = Duration(milliseconds: Config.requestsDelay);
    Timer.periodic(delay, (timer) async {
      print('OPERATION $_operationsCounter; LIST SIZE: ${_specialOperationsIds.length}; EMPTY CYCLE: $_emptyCycleCounter');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (_specialOperationsIds.length < Config.requestQueueSize) {
        for (final PropaGondonUrl url in propaGondonResources) {
          if (_disabledResources.contains(url)) {
            continue;
          }
          _startOperation(url);
        }
      }
      if (_prevOperationsCount == _specialOperationsIds.length) {
        _emptyCycleCounter++;
        if (_emptyCycleCounter >= Config.requestQueueSize) {
          _specialOperationsIds.clear();
          _emptyCycleCounter = 0;
          _prevOperationsCount = 0;
        }
      } else {
        _emptyCycleCounter = 0;
      }
      _operationsCounter++;
      send(event: MainEvents.updateRequestsCount, data: _specialOperationsIds.length, sendDirectly: true);
      _prevOperationsCount = _specialOperationsIds.length;
    });
  }

  Future<void> _startOperation(PropaGondonUrl url) async {
    final SpecialOperationId id = _generateOperationId(url);
    _specialOperationsIds.add(id);
    send(event: MainEvents.incrementTotalRequestsCount, sendDirectly: true);
    try {
      if (Config.demoMode) {
        await Future<void>.delayed(Duration(milliseconds: Random().nextInt(2000 - 200) + 200));
        if (Random().nextDouble() > 0.25) {
          throw Error();
        }
      } else {
        final result = await _dio.get(url);
        print('SUCCESS IN OPERATION [$url]: "${result.statusCode}"');
      }
      if (!_disabledResources.contains(url)) {
        send(event: MainEvents.updateResourceInfo, data: PropaGondonUpdate.ok(url), sendDirectly: true);
      }
    } catch (error) {
      print('ERROR IN OPERATION [$url]: $error');
      if (!_disabledResources.contains(url)) {
        send(event: MainEvents.updateResourceInfo, data: PropaGondonUpdate.error(url), sendDirectly: true);
      }
    }
    _specialOperationsIds.remove(id);
  }

  void _enableResource({required MainEvents event, required PropaGondonUrl data}) {
    _disabledResources.remove(data);
  }

  void _disableResource({required MainEvents event, required PropaGondonUrl data}) {
    _disabledResources.add(data);
    _specialOperationsIds.removeWhere((SpecialOperationId me) => me.contains(data));
  }

  void _enableAllResources({required MainEvents event, void data}) {
    _disabledResources.clear();
  }

  void _disableAllResources({required MainEvents event, void data}) {
    _disabledResources.addAll(propaGondonResources);
    _specialOperationsIds.clear();
  }

  @override
  void initActions() {
    whenEventCome(MainEvents.startSpecialOperation).run(_init);
    whenEventCome(MainEvents.enableResource).run(_enableResource);
    whenEventCome(MainEvents.disableResource).run(_disableResource);
    whenEventCome(MainEvents.enableAllResources).run(_enableAllResources);
    whenEventCome(MainEvents.disableAllResources).run(_disableAllResources);
  }
}

String _generateOperationId(PropaGondonUrl url) {
  final List<String> symbols = 'abcdefghijklmnopqrstuvwxyz0123456789'.split('');
  final Random random = Random();
  final List<String> result = [];
  for (int i = 0; i < 10; i++) {
    result.add(symbols[random.nextInt(symbols.length)]);
  }
  return '$url:${result.join()}';
}
