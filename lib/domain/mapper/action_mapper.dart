import 'package:todo_list_app/data/dto/action_dto.dart';
import 'package:todo_list_app/domain/mapper/importance_mapper.dart';
import 'package:todo_list_app/domain/model/action.dart';

class ActionsMapper {
  final ImportanceMapper importanceMapper;
  ActionsMapper(this.importanceMapper);
  ActionDto mapActionToActionDto(ActionToDo actionToDo) => ActionDto(
        actionToDo.id,
        actionToDo.text,
        actionToDo.done,
        actionToDo.deadlineON
            ? actionToDo.deadline.millisecondsSinceEpoch
            : null,
        importanceMapper.mapImportanceToString(actionToDo.importance),
        actionToDo.color,
        actionToDo.createdAt.millisecondsSinceEpoch,
        actionToDo.changedAt.millisecondsSinceEpoch,
        actionToDo.lastUpdatedBy,
      );

  ActionToDo mapActionDtoToAction(ActionDto actionDto) => ActionToDo(
        actionDto.id,
        actionDto.text,
        actionDto.done,
        (actionDto.deadline == null) ? false : true,
        (actionDto.deadline == null)
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(actionDto.deadline as int),
        importanceMapper.mapStringToImportance(actionDto.importance),
        actionDto.color,
        DateTime.fromMillisecondsSinceEpoch(actionDto.createdAt),
        DateTime.fromMillisecondsSinceEpoch(actionDto.changedAt),
        actionDto.lastUpdatedBy,
      );
}
