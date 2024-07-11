import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dto/action_dto.dart';
import 'package:todo_list_app/utils/logger.dart';

import '../../domain/model/action.dart';
import '../../domain/repository/actions_api_repository.dart';
import '../dao/actions_dao.dart';
import '../mapper/action_mapper.dart';

class ActionsAPIRepositoryImpl implements ActionsAPIRepository {
  final ActionsDao actionsDao;
  final ListDao listDao;
  final ActionsMapper actionMapper;

  ActionsAPIRepositoryImpl(
    this.actionsDao,
    this.listDao,
    this.actionMapper,
  );

  @override
  Future<void> addAction(ActionToDo action) async {
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await listDao.addAction(actionDto);
  }

  @override
  Future<void> deleteAction(ActionToDo action) async {
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await listDao.deleteAction(actionDto);
  }

  @override
  Future<void> editAction(ActionToDo action) async {
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await listDao.editAction(actionDto);
  }

  @override
  Future<List<ActionToDo>> getAll() async {
    List<ActionDto> list = await listDao.getList();
    return list.map((e) => actionMapper.mapActionDtoToAction(e)).toList();
  }

  @override
  Future<ActionToDo> getById(String id) async {
    ActionDto actionDto = await listDao.getActionById(id);
    return actionMapper.mapActionDtoToAction(actionDto);
  }

  @override
  Future<List<ActionToDo>> synchronizeList() async {
    AppLogger.i("synchronize!");
    List<ActionDto> listDb = await actionsDao.getAll();
    List<ActionDto> listFromServer = await listDao.updateList(listDb);
    await actionsDao.updateList(listFromServer);
    return listFromServer
        .map((e) => actionMapper.mapActionDtoToAction(e))
        .toList();
  }
}
