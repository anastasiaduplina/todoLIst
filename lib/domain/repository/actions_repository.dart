import '../model/action.dart';

abstract interface class ActionsRepository {
  Future<List<ActionToDo>> addAction(ActionToDo action);

  Future<List<ActionToDo>> deleteAction(ActionToDo action);

  Future<List<ActionToDo>> editAction(ActionToDo action);

  Future<List<ActionToDo>> getAll();
}
