import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list_app/core/providers.dart';
import 'package:todo_list_app/domain/model/action.dart';
import 'package:todo_list_app/utils/logger.dart';

part 'action_provider.g.dart';

@riverpod
class ActionState extends _$ActionState {
  @override
  Future<List<ActionToDo>> build() async {
    List<ActionToDo> list = await ref.read(actionRepositoryProvider).getAll();
    AppLogger.d(
      "provider ${list.map((e) => "${e.text} ${e.id} ${e.done}").toList().toString()}",
    );
    return list;
  }

  Future<void> addOrEditAction(ActionToDo action) async {
    List<ActionToDo> list;

    if (action.id.isEmpty) {
      await ref.read(actionRepositoryProvider).addAction(action);
      list = await ref.read(actionRepositoryProvider).getAll();
    } else {
      await ref.read(actionRepositoryProvider).editAction(action);
      list = await ref.read(actionRepositoryProvider).getAll();
    }
    state = AsyncValue.data(list);
  }

  Future<void> deleteAction(ActionToDo action) async {
    if (action.id.isNotEmpty) {
      await ref.read(actionRepositoryProvider).deleteAction(action);
      List<ActionToDo> list = await ref.read(actionRepositoryProvider).getAll();
      AppLogger.d(list.toString());
      state = AsyncValue.data(list);
    }
  }

  Future<void> getAllActions() async {
    List<ActionToDo> list = await ref.read(actionRepositoryProvider).getAll();
    state = AsyncValue.data(list);
  }

  Future<void> markDoneOrNot(ActionToDo action, bool done) async {
    action.done = done;
    addOrEditAction(action);
  }

  int countDoneActions() {
    List<ActionToDo> list = state.valueOrNull ?? [];
    int count = list.where((item) => item.done).length;
    return count;
  }
}
