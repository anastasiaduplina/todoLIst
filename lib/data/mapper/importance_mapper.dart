import 'package:todo_list_app/data/dto/action_dto.dart';
import 'package:todo_list_app/domain/model/action.dart';

class ImportanceMapper {
  Importance mapStringToImportance(ImportanceDto importance) {
    switch (importance) {
      case ImportanceDto.basic:
        return Importance.no;
      case ImportanceDto.low:
        return Importance.low;
      case ImportanceDto.high:
        return Importance.high;
    }
  }

  ImportanceDto mapImportanceToString(Importance importance) {
    switch (importance) {
      case Importance.no:
        return ImportanceDto.basic;
      case Importance.low:
        return ImportanceDto.low;
      case Importance.high:
        return ImportanceDto.high;
    }
  }
}
