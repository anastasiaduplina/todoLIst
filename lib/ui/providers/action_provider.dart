import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list_app/core/providers.dart';
import 'package:todo_list_app/domain/model/action.dart';

part 'action_provider.g.dart';

@riverpod
class ActionState extends _$ActionState {
  @override
  Future<List<ActionToDo>> build() async {
    List<ActionToDo> list = await ref.read(actionRepositoryProvider).getAll();
    return list;
  }

  Future<void> addOrEditAction(ActionToDo action) async {
    List<ActionToDo> list;
    if (action.id == -1) {
      list = await ref.read(actionRepositoryProvider).addAction(action);
    } else {
      list = await ref.read(actionRepositoryProvider).editAction(action);
    }
    state = AsyncValue.data(list);
  }

  Future<void> deleteAction(ActionToDo action) async {
    if (action.id != -1) {
      List<ActionToDo> list =
          await ref.read(actionRepositoryProvider).deleteAction(action);
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
