import 'package:todo_list_app/data/dto/action_dto.dart';

abstract interface class ActionsDao {
  Future<void> addAction(ActionDto actionDto);
  Future<void> editAction(ActionDto actionDto);

  Future<void> deleteAction(ActionDto actionDto);

  Future<List<ActionDto>> getAll();
}
