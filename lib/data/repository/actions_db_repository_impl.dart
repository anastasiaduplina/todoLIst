import 'package:todo_list_app/data/dto/action_dto.dart';

import '../../domain/repository/actions_db_repository.dart';
import '../dao/actions_dao.dart';
import '../../domain/model/action.dart';
import '../mapper/action_mapper.dart';

class ActionsDBRepositoryImpl implements ActionsDBRepository {
  final ActionsDao actionsDao;
  final ActionsMapper actionMapper;

  ActionsDBRepositoryImpl(
    this.actionsDao,
    this.actionMapper,
  );

  @override
  Future<void> addAction(ActionToDo action) async {
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await actionsDao.addAction(actionDto);
  }

  @override
  Future<void> deleteAction(ActionToDo action) async {
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await actionsDao.deleteAction(actionDto);
  }

  @override
  Future<void> editAction(ActionToDo action) async {
    ActionDto actionDto = actionMapper.mapActionToActionDto(action);
    await actionsDao.editAction(actionDto);
  }

  @override
  Future<List<ActionToDo>> getAll() async {
    List<ActionDto> list = await actionsDao.getAll();
    List<ActionToDo> list2 =
        list.map((e) => actionMapper.mapActionDtoToAction(e)).toList();
    return list2;
  }

  @override
  Future<ActionToDo> getById(String id) async {
    ActionDto actionDto = await actionsDao.getActionById(id);
    return actionMapper.mapActionDtoToAction(actionDto);
  }
}
