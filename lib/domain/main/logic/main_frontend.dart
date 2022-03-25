import 'package:anti_propa_gondons/domain/main/entities/propa_gondon_resourse.dart';
import 'package:anti_propa_gondons/domain/main/entities/propa_gondon_update.dart';
import 'package:anti_propa_gondons/domain/main/logic/main_backend.dart';
import 'package:anti_propa_gondons/domain/main/logic/main_screen_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:isolator/isolator.dart';

typedef ResourceUpdateCallback = ValueChanged<PropaGondonUpdate>;
typedef MainFrontendInitCallback = ValueChanged<List<PropaGondonResource>>;
typedef RequestsCountUpdateCallback = void Function({required int frontendId, required int requestsCount});
typedef TotalRequestsIncrementCallback = ValueChanged<FrontendId>;

enum MainEvents {
  startSpecialOperation,
  initializationComplete,
  enableResource,
  disableResource,
  enableAllResources,
  disableAllResources,
  updateResourceInfo,
  updateRequestsCount,
  incrementTotalRequestsCount,
}

class MainFrontend with Frontend {
  MainFrontend({
    required this.id,
    required this.onUpdate,
    required this.onRequestsCountUpdate,
    required this.onTotalRequestsUpdate,
    this.onInit,
  });

  final int id;
  final ValueSetter<List<PropaGondonResource>>? onInit;
  final ResourceUpdateCallback onUpdate;
  final RequestsCountUpdateCallback onRequestsCountUpdate;
  final TotalRequestsIncrementCallback onTotalRequestsUpdate;

  Future<void> init() async {
    await initBackend(initializer: MainBackend.create);
    run(event: MainEvents.startSpecialOperation, data: onInit != null);
  }

  void enableResource(PropaGondonUrl url) => run(event: MainEvents.enableResource, data: url);

  void disableResource(PropaGondonUrl url) => run(event: MainEvents.disableResource, data: url);

  void enableAllResources() => run(event: MainEvents.enableAllResources);

  void disableAllResources() => run(event: MainEvents.disableAllResources);

  void _updateInfo({required MainEvents event, required PropaGondonUpdate data}) => onUpdate(data);

  void _initializationComplete({required MainEvents event, required List<PropaGondonResource> data}) {
    if (onInit != null) {
      onInit!(data);
    }
  }

  void _updateRequestsCount({required MainEvents event, required int data}) => onRequestsCountUpdate(frontendId: id, requestsCount: data);

  void _incrementTotalRequests({required MainEvents event, void data}) => onTotalRequestsUpdate(id);

  @override
  void initActions() {
    whenEventCome(MainEvents.initializationComplete).run(_initializationComplete);
    whenEventCome(MainEvents.updateResourceInfo).run(_updateInfo);
    whenEventCome(MainEvents.updateRequestsCount).run(_updateRequestsCount);
    whenEventCome(MainEvents.incrementTotalRequestsCount).run(_incrementTotalRequests);
  }
}
