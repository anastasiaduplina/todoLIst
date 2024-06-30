import 'package:todo_list_app/domain/model/action.dart';

class ImportanceMapper {
  Importance mapStringToImportance(String importance) {
    switch (importance) {
      case "basic":
        return Importance.no;
      case "low":
        return Importance.low;
      case "high":
        return Importance.high;
    }
    return Importance.no;
  }

  String mapImportanceToString(Importance importance) {
    switch (importance) {
      case Importance.no:
        return "basic";
      case Importance.low:
        return "low";
      case Importance.high:
        return "high";
    }
  }
}
