import 'package:todo_list_app/data/dto/action_dto.dart';

abstract interface class ListDao {
  Future<List<ActionDto>> updateList(List<ActionDto> list);
  Future<void> addAction(ActionDto actionDto);
  Future<void> editAction(ActionDto actionDto);
  Future<ActionDto> getActionById(String id);
  Future<void> deleteAction(ActionDto actionDto);

  Future<List<ActionDto>> getList();
}
