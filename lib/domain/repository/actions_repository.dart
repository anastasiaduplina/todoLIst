import '../model/action.dart';

abstract interface class ActionsRepository {
  Future<void> addAction(ActionToDo action);

  Future<void> deleteAction(ActionToDo action);

  Future<void> editAction(ActionToDo action);
  Future<List<ActionToDo>> synchronizeList();

  Future<List<ActionToDo>> getAll();
}
