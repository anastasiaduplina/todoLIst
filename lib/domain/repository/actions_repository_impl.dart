import 'package:todo_list_app/domain/repository/actions_repository.dart';

import '../model/action.dart';

/// для тестов
class ActionsRepositoryImplTest implements ActionsRepository {
  ActionsRepositoryImplTest();

  List<ActionToDo> database = [
    ActionToDo(1, "Позавтракать", true, false, DateTime.now(), Importance.no),
    ActionToDo(
        2, "Утренняя зарядка", false, true, DateTime.now(), Importance.high),
    ActionToDo(3, "Основные деловые задачи", false, true, DateTime.now(),
        Importance.low),
    ActionToDo(
        4, "Перерыв на обед", true, false, DateTime.now(), Importance.no),
    ActionToDo(5, "Домашние дела, которые не лень делать", false, true,
        DateTime.now(), Importance.high),
    ActionToDo(
        6, "Общение с котом", false, true, DateTime.now(), Importance.low),
    ActionToDo(
        7, "Хобби или увлечения", true, true, DateTime.now(), Importance.no),
    ActionToDo(8, "Ужин", false, false, DateTime.now(), Importance.high),
    ActionToDo(9, "Просмотр аниме и дорам", true, true, DateTime.now(),
        Importance.low),
    ActionToDo(
        10, "Вечерняя рутина", true, false, DateTime.now(), Importance.low),
  ];
  int sequense = 14;

  @override
  Future<List<ActionToDo>> addAction(ActionToDo action) {
    database.add(action);
    action.id = sequense;
    sequense++;
    return Future.value(database);
  }

  @override
  Future<List<ActionToDo>> deleteAction(ActionToDo action) {
    database.removeWhere((item) => item.id == action.id);
    return Future.value(database);
  }

  @override
  Future<List<ActionToDo>> editAction(ActionToDo action) {
    database[database.indexWhere((item) => item.id == action.id)] = action;
    return Future.value(database);
  }

  @override
  Future<List<ActionToDo>> getAll() {
    return Future.value(database);
  }
}
