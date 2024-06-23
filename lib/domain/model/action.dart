class ActionToDo {
  int id;
  String text;
  bool done;
  bool deadlineON;
  DateTime deadline;
  Importance importance;

  ActionToDo(this.id, this.text, this.done, this.deadlineON, this.deadline,
      this.importance);
}

enum Importance {
  no("Нет"),
  low("Низкий"),
  high("!!Высокий");

  const Importance(this.value);

  final String value;
}

ActionToDo getEmptyAction() {
  return ActionToDo(-1, "", false, false, DateTime.now(), Importance.no);
}
