import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list_app/core/providers.dart';
import 'package:todo_list_app/domain/model/action.dart';
import 'package:todo_list_app/utils/logger.dart';

part 'action_provider.g.dart';

@riverpod
class ActionState extends _$ActionState {
  @override
  Future<List<ActionToDo>> build() async {
    AppLogger.i("build");
    List<ActionToDo> list;
    try {
      list = await ref
          .read(Providers.actionAPIRepositoryProvider)
          .synchronizeList();
    } catch (e) {
      AppLogger.e("Sannot synchronize");
      list = await ref.read(Providers.actionDBRepositoryProvider).getAll();
    }
    return list;
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    } else if (Platform.isWindows) {
      var windowsDeviceInfo = await deviceInfo.windowsInfo;
      return windowsDeviceInfo.deviceId;
    }
    return null;
  }

  Future<void> addOrEditAction(ActionToDo action, bool hasConnection) async {
    List<ActionToDo> list = [];
    action
      ..changedAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";

    if (action.id.isEmpty) {
      action
        ..id = ref.read(Providers.uuidProvider).v1()
        ..createdAt = DateTime.now();
      await ref.read(Providers.actionDBRepositoryProvider).addAction(action);
      list = await ref.read(Providers.actionDBRepositoryProvider).getAll();

      state = AsyncValue.data(list);
      if (hasConnection) {
        await ref.read(Providers.actionAPIRepositoryProvider).addAction(action);
      }
    } else {
      await ref.read(Providers.actionDBRepositoryProvider).editAction(action);
      list = await ref.read(Providers.actionDBRepositoryProvider).getAll();

      state = AsyncValue.data(list);
      if (hasConnection) {
        await ref
            .read(Providers.actionAPIRepositoryProvider)
            .editAction(action);
      }
    }
  }

  Future<void> deleteAction(ActionToDo action, bool hasConnection) async {
    List<ActionToDo> list = [];

    if (action.id.isNotEmpty) {
      await ref.read(Providers.actionDBRepositoryProvider).deleteAction(action);
      list = await ref.read(Providers.actionDBRepositoryProvider).getAll();

      state = AsyncValue.data(list);
      if (hasConnection) {
        await ref
            .read(Providers.actionAPIRepositoryProvider)
            .deleteAction(action);
      }
    }
  }

  Future<void> getAllActions(bool hasConnection) async {
    List<ActionToDo> list =
        await ref.read(Providers.actionDBRepositoryProvider).getAll();
    state = AsyncValue.data(list);
  }

  Future<void> markDoneOrNot(
    ActionToDo action,
    bool done,
    bool hasConnection,
  ) async {
    List<ActionToDo> list = [];

    action
      ..done = done
      ..changedAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";

    await ref.read(Providers.actionDBRepositoryProvider).editAction(action);
    list = await ref.read(Providers.actionDBRepositoryProvider).getAll();

    state = AsyncValue.data(list);
    if (hasConnection) {
      await ref.read(Providers.actionAPIRepositoryProvider).editAction(action);
    }
  }

  Future<ActionToDo> getActionById(String id, bool hasConnection) async {
    if (id.isNotEmpty) {
      return await ref.read(Providers.actionDBRepositoryProvider).getById(id);
    }
    return getEmptyAction();
  }

  int countDoneActions() {
    List<ActionToDo> list = state.valueOrNull ?? [];
    int count = list.where((item) => item.done).length;
    return count;
  }

  Future<void> synchronizeList(bool hasConnection) async {
    if (hasConnection) {
      List<ActionToDo> list = await ref
          .read(Providers.actionAPIRepositoryProvider)
          .synchronizeList();
      state = AsyncValue.data(list);
    }
  }
}
