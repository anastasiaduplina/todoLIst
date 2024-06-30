import 'dart:io';

import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dto/action_dto.dart';
import 'package:todo_list_app/domain/repository/actions_repository.dart';
import 'package:todo_list_app/utils/exceptions/not_valid_revision_exception.dart';
import 'package:todo_list_app/utils/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../data/dao/actions_dao.dart';
import '../mapper/action_mapper.dart';
import '../model/action.dart';

class ActionsRepositoryImpl implements ActionsRepository {
  final Uuid uuid;
  final ActionsDao actionsDao;
  final ListDao listDao;
  final ActionsMapper actionMapper;

  ActionsRepositoryImpl(
    this.uuid,
    this.actionsDao,
    this.listDao,
    this.actionMapper,
  );

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

  @override
  Future<void> addAction(ActionToDo action) async {
    if (action.id.isEmpty) {
      action.id = uuid.v1();
    }
    action
      ..createdAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await actionsDao.addAction(actionDto);
    try {
      await listDao.addAction(actionDto);
    } on NotValidRevisionException catch (e) {
      AppLogger.e(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<void> deleteAction(ActionToDo action) async {
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await actionsDao.deleteAction(actionDto);
    try {
      await listDao.deleteAction(actionDto);
    } on NotValidRevisionException catch (e) {
      AppLogger.e(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<void> editAction(ActionToDo action) async {
    action
      ..changedAt = DateTime.now()
      ..lastUpdatedBy = await getId() ?? "";
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await actionsDao.editAction(actionDto);
    try {
      await listDao.editAction(actionDto);
    } on NotValidRevisionException catch (e) {
      AppLogger.e(e.toString());
      synchronizeList();
    }
  }

  @override
  Future<List<ActionToDo>> getAll() async {
    List<ActionToDo> list = await synchronizeList();
    return list;
  }

  @override
  Future<List<ActionToDo>> synchronizeList() async {
    List<ActionDto> listDb = await actionsDao.getAll();
    try {
      List<ActionDto> listFromServer = await listDao.getList();
      listDb.addAll(listFromServer);
      listFromServer = await listDao.updateList(listDb.toSet().toList());
      return listFromServer
          .map((e) => actionMapper.mapActionDtoToAction(e))
          .toList();
    } on Exception catch (e) {
      AppLogger.e(e.toString());
    }
    return listDb.map((e) => actionMapper.mapActionDtoToAction(e)).toList();
  }
}
